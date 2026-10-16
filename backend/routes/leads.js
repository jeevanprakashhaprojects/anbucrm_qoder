const { Router } = require("express");
const { requireAuth } = require("../middleware/auth");
const r = Router();

// Placeholder — CRM leads storage will land here.
r.get("/", requireAuth, (_req, res) => {
  res.json({ leads: [] });
});

module.exports = r;
