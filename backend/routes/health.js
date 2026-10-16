const { Router } = require("express");
const { getAdmin } = require("../services/firebase");
const r = Router();

r.get("/", async (_req, res) => {
  let firebase = "not initialized";
  try {
    const admin = getAdmin();
    const list = await admin.auth().listUsers(1);
    firebase = "connected";
  } catch (e) {
    firebase = e.message || "error";
  }
  res.json({
    ok: true,
    service: "anbucrm-api",
    firebase,
    uptime: process.uptime(),
    ts: new Date().toISOString(),
  });
});

module.exports = r;
