const { Router } = require("express");
const { requireAuth } = require("../middleware/auth");
const { createOrder, verifyWebhookSignature, verifyPaymentSignature } = require("../services/paymentGateway");
const { HttpError } = require("../middleware/errorHandler");
const r = Router();

// POST /payments/create-order — authenticated; returns Razorpay order
r.post("/create-order", requireAuth, async (req, res, next) => {
  try {
    const { amountPaise, currency, notes } = req.body || {};
    if (!Number.isInteger(amountPaise) || amountPaise <= 0) {
      throw new HttpError(400, "amountPaise must be a positive integer");
    }
    const order = await createOrder({
      amountPaise,
      currency,
      receipt: `anbucrm_${Date.now()}`,
      notes: { ...(notes || {}), uid: req.user.uid },
    });
    res.json({
      orderId: order.id,
      amountPaise: order.amount,
      currency: order.currency,
      keyId: process.env.RAZORPAY_KEY_ID,
    });
  } catch (e) { next(e); }
});

// POST /payments/verify — client-side after Razorpay success callback
r.post("/verify", requireAuth, (req, res, next) => {
  try {
    const { razorpay_order_id, razorpay_payment_id, razorpay_signature } = req.body || {};
    if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature) {
      throw new HttpError(400, "Missing Razorpay response fields");
    }
    const ok = verifyPaymentSignature({
      orderId: razorpay_order_id,
      paymentId: razorpay_payment_id,
      signature: razorpay_signature,
    });
    if (!ok) throw new HttpError(400, "Signature mismatch");
    // TODO: persist payment record against req.user.uid
    res.json({ ok: true, paymentId: razorpay_payment_id, orderId: razorpay_order_id });
  } catch (e) { next(e); }
});

// POST /payments/webhook — Razorpay server-side webhook (no bearer token; HMAC verified)
r.post("/webhook", (req, res) => {
  const signature = req.headers["x-razorpay-signature"];
  const secret = process.env.RAZORPAY_WEBHOOK_SECRET;
  if (!secret) return res.status(503).json({ error: "webhook not configured" });
  const body = req.rawBody.toString("utf8");
  const ok = verifyWebhookSignature({ body, signature, secret });
  if (!ok) return res.status(401).json({ error: "bad signature" });
  const event = JSON.parse(body);
  // TODO: handle event.event (payment.captured, payment.failed, etc.)
  console.log("[razorpay:event]", event.event);
  res.json({ ok: true });
});

module.exports = r;
