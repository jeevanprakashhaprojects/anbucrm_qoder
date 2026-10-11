require('dotenv').config();

const crypto = require('crypto');
const express = require('express');
const Razorpay = require('razorpay');
const admin = require('firebase-admin');

const PORT = Number(process.env.PORT || 3000);
const PLAN_AMOUNT_INR = Number(process.env.PLAN_AMOUNT_INR || 500);
const AMOUNT_PAISE = PLAN_AMOUNT_INR * 100;
const CURRENCY = process.env.CURRENCY || 'INR';

const KEY_ID = process.env.RAZORPAY_KEY_ID;
const KEY_SECRET = process.env.RAZORPAY_KEY_SECRET;
const WEBHOOK_SECRET = process.env.RAZORPAY_WEBHOOK_SECRET;
const DATABASE_URL = process.env.FIREBASE_DATABASE_URL;

for (const [name, value] of Object.entries({
  RAZORPAY_KEY_ID: KEY_ID,
  RAZORPAY_KEY_SECRET: KEY_SECRET,
  RAZORPAY_WEBHOOK_SECRET: WEBHOOK_SECRET,
  FIREBASE_DATABASE_URL: DATABASE_URL,
})) {
  if (!value) {
    console.error(`Missing required environment variable: ${name}`);
    process.exit(1);
  }
}

function loadServiceAccount() {
  if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
    return JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
  }
  if (process.env.FIREBASE_SERVICE_ACCOUNT_PATH) {
    return require(process.env.FIREBASE_SERVICE_ACCOUNT_PATH);
  }
  console.error(
    'Missing FIREBASE_SERVICE_ACCOUNT_JSON or FIREBASE_SERVICE_ACCOUNT_PATH'
  );
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(loadServiceAccount()),
  databaseURL: DATABASE_URL,
});
const db = admin.database();

const rzp = new Razorpay({ key_id: KEY_ID, key_secret: KEY_SECRET });

const app = express();
app.disable('x-powered-by');
app.set('trust proxy', true);

// ─── Helpers ──────────────────────────────────────────────────────────────────

function hmacSha256Hex(secret, payload) {
  return crypto.createHmac('sha256', secret).update(payload).digest('hex');
}

// The Razorpay SDK rejects with different shapes depending on the failure, and
// some carry no message at all — fall back to the raw value so logs stay useful.
function describeError(err) {
  if (!err) return 'unknown error';
  return (
    err.error_description ||
    err.error?.description ||
    err.message ||
    err.error?.code ||
    String(err)
  );
}

function safeEqual(a, b) {
  const left = Buffer.from(String(a || ''), 'utf8');
  const right = Buffer.from(String(b || ''), 'utf8');
  if (left.length !== right.length) return false;
  return crypto.timingSafeEqual(left, right);
}

async function verifyIdToken(req) {
  const header = req.get('authorization') || '';
  const token = header.toLowerCase().startsWith('bearer ')
    ? header.slice(7).trim()
    : '';
  if (!token) return null;
  try {
    return await admin.auth().verifyIdToken(token);
  } catch {
    return null;
  }
}

// Fixed-window limiter: payment endpoints are worth rate limiting because
// signature verification is an online brute-force target.
const WINDOW_MS = 60_000;
const MAX_HITS = 30;
const hits = new Map();

function rateLimit(req, res, next) {
  const now = Date.now();
  const key = req.ip || 'unknown';
  const entry = hits.get(key);
  if (!entry || now - entry.start > WINDOW_MS) {
    hits.set(key, { start: now, count: 1 });
    if (hits.size > 5000) hits.clear();
    return next();
  }
  entry.count += 1;
  if (entry.count > MAX_HITS) {
    return res.status(429).json({ paid: false, error: 'too_many_requests' });
  }
  next();
}

function userPaymentRef(uid) {
  return db.ref(`admin/Users/${uid}/payment`);
}

async function fetchOrder(orderId) {
  return rzp.orders.fetch(orderId);
}

async function fetchPayment(paymentId) {
  return rzp.payments.fetch(paymentId);
}

// Resolves the uid from Razorpay notes. The order was created by this server,
// so its notes are authoritative — never accept a uid from the client.
function resolveUid(order, payment) {
  const fromOrder = order && order.notes && order.notes.uid;
  const fromPayment = payment && payment.notes && payment.notes.uid;
  const uid = fromOrder || fromPayment;
  if (!uid || typeof uid !== 'string' || uid.length > 200) return null;
  return uid;
}

function isFullyCaptured(payment, order) {
  if (!payment || payment.status !== 'captured') return false;
  if (Number(payment.amount) !== Number(AMOUNT_PAISE)) return false;
  if (Number(payment.amount_paid) !== Number(payment.amount)) return false;
  if (payment.currency !== order.currency) return false;
  if (order.status !== 'paid' && order.status !== 'closed') return false;
  return true;
}

async function markPaid(uid, { order, payment, source }) {
  const nowIso = new Date().toISOString();
  await userPaymentRef(uid).update({
    uid,
    paid: true,
    status: 'captured',
    razorpay_order_id: order.id,
    razorpay_payment_id: payment.id,
    amount_paise: Number(payment.amount),
    amount_inr: Number(payment.amount) / 100,
    currency: payment.currency,
    method: payment.method || 'unknown',
    signature_verified: true,
    confirmed_by: source,
    paid_at: payment.created_at
      ? new Date(Number(payment.created_at) * 1000).toISOString()
      : nowIso,
    updated_at: nowIso,
  });
}

async function markFailed(uid, { orderId, paymentId, source, reason }) {
  const nowIso = new Date().toISOString();
  const payload = {
    paid: false,
    status: 'failed',
    failure_reason: reason,
    confirmed_by: source,
    updated_at: nowIso,
  };
  if (orderId) payload.razorpay_order_id = orderId;
  if (paymentId) payload.razorpay_payment_id = paymentId;
  await userPaymentRef(uid).update(payload);
}

// ─── Routes ───────────────────────────────────────────────────────────────────

app.get('/health', (req, res) => {
  res.json({ ok: true, amount_inr: PLAN_AMOUNT_INR, currency: CURRENCY });
});

// Step 1 — app asks for an order. Requires a Firebase ID token so the uid
// comes from the signed-in user, not from the request body.
app.post('/create-order', rateLimit, express.json(), async (req, res) => {
  try {
    const decoded = await verifyIdToken(req);
    if (!decoded) {
      return res.status(401).json({ error: 'unauthenticated' });
    }

    const alreadyPaid = await userPaymentRef(decoded.uid).once('value');
    const existing = alreadyPaid.val();
    if (existing && existing.paid === true && existing.razorpay_order_id) {
      return res.json({
        already_paid: true,
        order_id: existing.razorpay_order_id,
        payment_id: existing.razorpay_payment_id,
        key_id: KEY_ID,
        amount: Number(existing.amount_paise || AMOUNT_PAISE),
        currency: existing.currency || CURRENCY,
      });
    }

    const order = await rzp.orders.create({
      amount: AMOUNT_PAISE,
      currency: CURRENCY,
      receipt: `rcpt_${decoded.uid.slice(-10)}_${Date.now()}`,
      notes: {
        uid: decoded.uid,
        email: decoded.email || '',
      },
    });

    res.json({
      already_paid: false,
      order_id: order.id,
      key_id: KEY_ID,
      amount: order.amount,
      currency: order.currency,
      name: process.env.BUSINESS_NAME || 'AnbuCRM',
      description: process.env.PLAN_DESCRIPTION || 'AnbuCRM monthly plan',
    });
  } catch (err) {
    console.error('create-order failed:', describeError(err));
    res.status(500).json({ error: 'order_creation_failed' });
  }
});

// Step 2 — app reports checkout success. Signature check, then a server-side
// fetch of the payment: only a truly captured payment returns paid:true.
app.post('/verify-payment', rateLimit, express.json(), async (req, res) => {
  try {
    const decoded = await verifyIdToken(req);
    if (!decoded) {
      return res.status(401).json({ paid: false, error: 'unauthenticated' });
    }

    const {
      razorpay_order_id: orderId,
      razorpay_payment_id: paymentId,
      razorpay_signature: signature,
    } = req.body || {};

    if (!orderId || !paymentId || !signature) {
      return res.status(400).json({ paid: false, error: 'missing_fields' });
    }

    const expected = hmacSha256Hex(KEY_SECRET, `${orderId}|${paymentId}`);
    if (!safeEqual(expected, signature)) {
      console.warn(`Bad checkout signature for order ${orderId}`);
      return res.status(400).json({ paid: false, error: 'signature_invalid' });
    }

    const [order, payment] = await Promise.all([
      fetchOrder(orderId),
      fetchPayment(paymentId),
    ]);

    if (payment.order_id !== order.id) {
      return res.status(400).json({ paid: false, error: 'order_mismatch' });
    }

    const uid = resolveUid(order, payment);
    if (!uid || uid !== decoded.uid) {
      console.warn(`uid mismatch: token=${decoded.uid} order=${uid}`);
      return res.status(403).json({ paid: false, error: 'uid_mismatch' });
    }

    if (!isFullyCaptured(payment, order)) {
      await markFailed(uid, {
        orderId,
        paymentId,
        source: 'verify',
        reason: payment.status || 'not_captured',
      });
      return res.json({
        paid: false,
        status: payment.status,
        error: 'payment_not_captured',
      });
    }

    await markPaid(uid, { order, payment, source: 'verify' });
    res.json({
      paid: true,
      status: 'captured',
      razorpay_order_id: order.id,
      razorpay_payment_id: payment.id,
      amount_inr: Number(payment.amount) / 100,
      currency: payment.currency,
    });
  } catch (err) {
    console.error('verify-payment failed:', describeError(err));
    res.status(500).json({ paid: false, error: 'verification_failed' });
  }
});

// Step 3 — app polls this until the backend says paid. Also covers the case
// where the webhook confirmed the payment before the app could ask.
app.get('/payment-status', rateLimit, async (req, res) => {
  const decoded = await verifyIdToken(req);
  if (!decoded) {
    return res.status(401).json({ paid: false, error: 'unauthenticated' });
  }
  try {
    const snap = await userPaymentRef(decoded.uid).once('value');
    const data = snap.val() || {};
    res.json({
      paid: data.paid === true,
      status: data.status || 'none',
      razorpay_order_id: data.razorpay_order_id || null,
      razorpay_payment_id: data.razorpay_payment_id || null,
      confirmed_by: data.confirmed_by || null,
    });
  } catch (err) {
    console.error('payment-status failed:', describeError(err));
    res.status(500).json({ paid: false, error: 'lookup_failed' });
  }
});

// Webhook — raw body is required because Razorpay signs the exact bytes sent.
// Mounted before express.json() so nothing rewrites the payload.
app.post(
  '/razorpay/webhook',
  express.raw({ type: '*/*' }),
  async (req, res) => {
    const signature =
      req.get('x-razorpay-signature') || req.get('X-Razorpay-Signature');
    const raw = Buffer.isBuffer(req.body)
      ? req.body
      : Buffer.from(req.body || '', 'utf8');

    if (!signature || raw.length === 0) {
      return res.status(400).json({ error: 'missing_signature' });
    }

    const expected = hmacSha256Hex(WEBHOOK_SECRET, raw);
    if (!safeEqual(expected, signature)) {
      console.warn('Rejected webhook: signature mismatch');
      return res.status(400).json({ error: 'signature_invalid' });
    }

    let event;
    try {
      event = JSON.parse(raw.toString('utf8'));
    } catch {
      return res.status(400).json({ error: 'bad_json' });
    }

    const type = event && event.event;
    const entity = (event && event.payload && event.payload.payment
      && event.payload.payment.entity) || {};

    // Acknowledge fast; Razorpay retries on non-2xx and can disable the hook.
    res.status(200).json({ received: true });

    try {
      if (type === 'payment.captured' || type === 'order.paid') {
        const orderId = entity.order_id;
        const paymentId = entity.id;
        if (!orderId || !paymentId) return;

        // Re-fetch: trust the API, not the webhook body alone.
        const [order, payment] = await Promise.all([
          fetchOrder(orderId),
          fetchPayment(paymentId),
        ]);

        const uid = resolveUid(order, payment);
        if (!uid) {
          console.warn(`Webhook ${type}: no uid in notes for ${orderId}`);
          return;
        }

        if (!isFullyCaptured(payment, order)) {
          await markFailed(uid, {
            orderId,
            paymentId,
            source: 'webhook',
            reason: payment.status || 'not_captured',
          });
          return;
        }

        await markPaid(uid, { order, payment, source: 'webhook' });
        console.log(`Webhook ${type}: marked ${uid} as paid (${paymentId})`);
        return;
      }

      if (type === 'payment.failed') {
        const orderId = entity.order_id;
        if (!orderId) return;
        const order = await fetchOrder(orderId);
        const uid = resolveUid(order, entity);
        if (!uid) return;
        await markFailed(uid, {
          orderId,
          paymentId: entity.id,
          source: 'webhook',
          reason: (entity.error_description || entity.error_code || 'failed'),
        });
        console.log(`Webhook payment.failed: ${uid}`);
      }
    } catch (err) {
      console.error(`Webhook ${type} handling failed:`, describeError(err));
    }
  }
);

app.use((req, res) => res.status(404).json({ error: 'not_found' }));

app.listen(PORT, () => {
  console.log(`AnbuCRM payment backend listening on port ${PORT}`);
  console.log(`Plan: ${PLAN_AMOUNT_INR} ${CURRENCY}`);
});
