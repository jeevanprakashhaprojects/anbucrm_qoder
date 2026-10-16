const { Router } = require("express");
const { getAdmin } = require("../services/firebase");
const { HttpError } = require("../middleware/errorHandler");
const r = Router();

// POST /auth/check-email — public. Tells the signup UI whether a Firebase
// Auth account already exists for the email, so step 1 can block before
// asking for a password. Uses the admin SDK because client-side lookups
// are blocked when Firebase email enumeration protection is enabled.
r.post("/check-email", async (req, res, next) => {
  try {
    const email =
      typeof req.body?.email === "string" ? req.body.email.trim().toLowerCase() : "";
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      throw new HttpError(400, "Valid email required");
    }
    const admin = getAdmin();
    try {
      await admin.auth().getUserByEmail(email);
      res.json({ exists: true });
    } catch (e) {
      if (e && e.code === "auth/user-not-found") {
        res.json({ exists: false });
      } else {
        throw e;
      }
    }
  } catch (e) {
    next(e);
  }
});

module.exports = r;
