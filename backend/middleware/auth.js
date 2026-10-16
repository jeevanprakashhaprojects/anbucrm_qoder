const { getAdmin } = require("../services/firebase");

// Verifies Firebase ID token from Authorization: Bearer <token>
// and attaches req.user = { uid, email, phone }.
async function requireAuth(req, res, next) {
  try {
    const header = req.headers.authorization || "";
    if (!header.startsWith("Bearer ")) {
      return res.status(401).json({ error: "Missing bearer token" });
    }
    const token = header.slice(7);
    const admin = getAdmin();
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = {
      uid: decoded.uid,
      email: decoded.email || null,
      phone: decoded.phone_number || null,
    };
    next();
  } catch (e) {
    return res.status(401).json({ error: "Invalid or expired token" });
  }
}

module.exports = { requireAuth };
