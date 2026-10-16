const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

let initialized = false;

function initFirebase() {
  if (initialized) return admin;
  const saPath = path.join(__dirname, "..", "service-account.json");
  if (!fs.existsSync(saPath)) {
    throw new Error("service-account.json not found");
  }
  const sa = JSON.parse(fs.readFileSync(saPath, "utf8"));
  admin.initializeApp({
    credential: admin.credential.cert(sa),
    databaseURL: "https://anbucrm-2026-default-rtdb.asia-southeast1.firebasedatabase.app",
  });
  initialized = true;
  console.log("[firebase] admin initialized for project", sa.project_id);
  return admin;
}

function getAdmin() {
  if (!initialized) throw new Error("Firebase not initialized");
  return admin;
}

module.exports = { initFirebase, getAdmin };
