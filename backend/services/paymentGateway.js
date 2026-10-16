const Razorpay = require("razorpay");
const crypto = require("crypto");

let client = null;

function getClient() {
  if (client) return client;
  const { RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET } = process.env;
  if (!RAZORPAY_KEY_ID || !RAZORPAY_KEY_SECRET) {
    throw new Error("Razorpay keys not configured");
  }
  client = new Razorpay({ key_id: RAZORPAY_KEY_ID, key_secret: RAZORPAY_KEY_SECRET });
  return client;
}

async function createOrder({ amountPaise, currency = "INR", receipt, notes }) {
  const rz = getClient();
  return rz.orders.create({ amount: amountPaise, currency, receipt, notes });
}

function verifyWebhookSignature({ body, signature, secret }) {
  const expected = crypto
    .createHmac("sha256", secret)
    .update(body)
    .digest("hex");
  return crypto.timingSafeEqual(
    Buffer.from(expected, "hex"),
    Buffer.from(signature || "", "hex"),
  );
}

function verifyPaymentSignature({ orderId, paymentId, signature }) {
  const expected = crypto
    .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET)
    .update(orderId + "|" + paymentId)
    .digest("hex");
  return crypto.timingSafeEqual(
    Buffer.from(expected, "hex"),
    Buffer.from(signature || "", "hex"),
  );
}

module.exports = { createOrder, verifyWebhookSignature, verifyPaymentSignature };
