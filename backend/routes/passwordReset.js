const { Router } = require("express");
const { createHash } = require("node:crypto");
const path = require("node:path");
const rateLimit = require("express-rate-limit");
const nodemailer = require("nodemailer");
const helmet = require("helmet");
const { getAdmin } = require("../services/firebase");

const r = Router();
const publicDir = path.join(__dirname, "..", "public");
const origin = "https://api.anbucrm.com";
const sentMessage = "If an account exists for this email, a password reset link has been sent.";
const invalidLink = "This reset link is invalid or has expired. Please request a new link.";
const unavailable = "Password reset is temporarily unavailable. Please try again shortly.";
const throttled = "Too many attempts. Please wait 15 minutes before trying again.";
const codeThrottled = "Too many attempts with this reset link. Please request a new link.";
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const weakPasswordMessage = "Choose a stronger password with uppercase and lowercase letters, a number, and a symbol.";

// Same conditions as the app's create-account password rules.
const passwordRules = [
  (v) => v.length >= 8,
  (v) => /[A-Z]/.test(v) && /[a-z]/.test(v),
  (v) => /[0-9]/.test(v),
  (v) => /[!@#$%^&*(),.?":{}|<>]/.test(v),
];

function passwordMeetsRules(value) {
  return typeof value === "string" && value.length >= 8 && value.length <= 128 && passwordRules.every((rule) => rule(value));
}

// Per-target buckets: hammering one email or one link must not block other
// users behind the same IP (office/mobile-network NAT). IP limits stay as a
// wide backstop only.
const requestLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 20,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (_req, res) => res.status(429).json({ error: throttled }),
});
const emailLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 3,
  standardHeaders: false,
  legacyHeaders: false,
  keyGenerator: (req) => createHash("sha256").update(req.body.email).digest("hex"),
  handler: (_req, res) => res.json({ ok: true, message: sentMessage }),
});
const actionLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 100,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (_req, res) => res.status(429).json({ error: throttled }),
});
const codeLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 15,
  standardHeaders: false,
  legacyHeaders: false,
  keyGenerator: (req) => createHash("sha256").update(String(req.body?.oobCode ?? "missing")).digest("hex"),
  handler: (_req, res) => res.status(429).json({ error: codeThrottled }),
});

function noStore(_req, res, next) {
  res.set({ "Cache-Control": "no-store", "Referrer-Policy": "no-referrer" });
  next();
}

function jsonOnly(req, res, next) {
  if (!req.is("application/json")) {
    return res.status(415).json({ error: "Send an application/json request." });
  }
  next();
}

function validateEmail(req, res, next) {
  const email = typeof req.body?.email === "string" ? req.body.email.trim().toLowerCase() : "";
  if (email.length > 254 || !emailPattern.test(email)) {
    return res.status(400).json({ error: "Enter a valid email address." });
  }
  req.body.email = email;
  next();
}

function validateCode(req, res, next) {
  const code = req.body?.oobCode;
  if (typeof code !== "string" || !/^[A-Za-z0-9_-]{20,2048}$/.test(code)) {
    return res.status(400).json({ error: invalidLink });
  }
  next();
}

async function firebaseReset(body, res) {
  const apiKey = process.env.FIREBASE_WEB_API_KEY;
  if (!apiKey) {
    res.status(503).json({ error: unavailable });
    return false;
  }
  try {
    const response = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=${encodeURIComponent(apiKey)}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
        signal: AbortSignal.timeout(15_000),
      },
    );
    const data = await response.json();
    if (response.ok) {
      if (data.requestType !== "PASSWORD_RESET") {
        res.status(400).json({ error: invalidLink });
        return false;
      }
      return true;
    }
    const code = (data.error?.message || "").split(" : ")[0];
    if (["INVALID_OOB_CODE", "EXPIRED_OOB_CODE", "USER_DISABLED", "EMAIL_NOT_FOUND"].includes(code)) {
      res.status(400).json({ error: invalidLink });
    } else if (["WEAK_PASSWORD", "PASSWORD_DOES_NOT_MEET_REQUIREMENTS"].includes(code)) {
      res.status(422).json({ error: weakPasswordMessage });
    } else if (code === "TOO_MANY_ATTEMPTS_TRY_LATER" || response.status === 429) {
      res.status(429).json({ error: throttled });
    } else {
      res.status(503).json({ error: unavailable });
    }
  } catch {
    res.status(503).json({ error: unavailable });
  }
  return false;
}

r.get("/reset-password", noStore, helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'"],
    styleSrc: ["'self'"],
    imgSrc: ["'self'", "data:"],
    connectSrc: ["'self'"],
    fontSrc: ["'self'"],
    formAction: ["'self'"],
    frameAncestors: ["'none'"],
    baseUri: ["'none'"],
    objectSrc: ["'none'"],
  },
}), (_req, res) => res.sendFile(path.join(publicDir, "password-reset.html")));
r.get("/password-reset.css", noStore, (_req, res) => res.sendFile(path.join(publicDir, "password-reset.css")));
r.get("/password-reset.js", noStore, (_req, res) => res.sendFile(path.join(publicDir, "password-reset.js")));

r.post("/forgot-password", noStore, requestLimiter, jsonOnly, validateEmail, emailLimiter, async (req, res) => {
  const user = process.env.GMAIL_USER;
  const pass = process.env.GMAIL_APP_PASSWORD;
  if (!user || !pass || !process.env.FIREBASE_WEB_API_KEY) {
    return res.status(503).json({ error: unavailable });
  }
  try {
    const generated = new URL(await getAdmin().auth().generatePasswordResetLink(req.body.email));
    const code = generated.searchParams.get("oobCode");
    if (!code) throw new Error("Missing reset code");
    // A fragment keeps the one-use code out of proxy and HTTP access logs.
    const resetUrl = `${origin}/auth/reset-password#oobCode=${encodeURIComponent(code)}`;
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: { user, pass },
      connectionTimeout: 10_000,
      greetingTimeout: 10_000,
      socketTimeout: 15_000,
    });
    await transporter.sendMail({
      from: { name: "AnbuCRM", address: user },
      to: req.body.email,
      subject: "Reset your AnbuCRM password",
      text: `Reset your AnbuCRM password\n\nOpen this secure link in your browser to choose a new password:\n${resetUrl}\n\nYour new password must have at least 8 characters and include uppercase and lowercase letters, a number, and a special character.\n\nThis link can only be used once and expires automatically. After changing your password, you can return to the AnbuCRM app.\n\nIf you did not request this, ignore this email. Your password will stay unchanged.\n\nAnbuCRM · Account security`,
      html: `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head><body style="margin:0;background:#f1f5f9;font-family:Arial,sans-serif;color:#0f172a"><table role="presentation" width="100%" cellpadding="0" cellspacing="0"><tr><td align="center" style="padding:32px 16px"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:520px;background:#fff;border:1px solid #e2e8f0;border-radius:20px"><tr><td style="padding:32px"><div style="font-size:22px;font-weight:700;color:#4f46e5">AnbuCRM</div><p style="font-size:12px;letter-spacing:2px;color:#64748b">ACCOUNT SECURITY</p><h1 style="font-size:28px;line-height:1.2;margin:28px 0 16px">A fresh start.<br>A secure password.</h1><p style="font-size:15px;line-height:1.7;color:#64748b">We received a request to reset your AnbuCRM password. Choose a new password securely in your browser.</p><table role="presentation" cellpadding="0" cellspacing="0" style="margin:28px 0"><tr><td bgcolor="#4f46e5" style="border-radius:12px"><a href="${resetUrl}" style="display:inline-block;padding:17px 28px;color:#fff;text-decoration:none;font-size:15px;font-weight:bold">Reset my password</a></td></tr></table><p style="font-size:13px;line-height:1.7;color:#64748b">This link works once and expires automatically. Your new password needs at least 8 characters with uppercase and lowercase letters, a number, and a special character. After updating your password, return to the app and sign in with your new password.</p><p style="font-size:12px;line-height:1.7;color:#64748b;border-top:1px solid #e2e8f0;padding-top:20px">Didn't request a reset? You can safely ignore this email. Your password will stay unchanged.</p></td></tr></table><p style="font-size:12px;color:#64748b">AnbuCRM · Account security</p></td></tr></table></body></html>`,
    });
    res.json({ ok: true, message: sentMessage });
  } catch (error) {
    if (["auth/user-not-found", "auth/user-disabled"].includes(error.code)) {
      return res.json({ ok: true, message: sentMessage });
    }
    // Keep delivery failures private so they cannot disclose account existence.
    console.error("[password-reset] Email service unavailable");
    res.json({ ok: true, message: sentMessage });
  }
});

r.post("/reset-password/verify", noStore, codeLimiter, actionLimiter, jsonOnly, validateCode, async (req, res) => {
  if (await firebaseReset({ oobCode: req.body.oobCode }, res)) res.json({ ok: true });
});

r.post("/reset-password/confirm", noStore, codeLimiter, actionLimiter, jsonOnly, validateCode, async (req, res) => {
  const password = req.body.newPassword;
  // Validate before touching the one-use code so a rejected password never burns it.
  if (!passwordMeetsRules(password)) {
    return res.status(422).json({ error: weakPasswordMessage });
  }
  if (!await firebaseReset({ oobCode: req.body.oobCode }, res)) return;
  if (await firebaseReset({ oobCode: req.body.oobCode, newPassword: password }, res)) res.json({ ok: true });
});

module.exports = r;
