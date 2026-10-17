require("dotenv").config();
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const rateLimit = require("express-rate-limit");

const healthRoutes = require("./routes/health");
const paymentRoutes = require("./routes/payments");
const leadRoutes = require("./routes/leads");
const authRoutes = require("./routes/auth");
const emailRoutes = require("./routes/email");
const { errorHandler } = require("./middleware/errorHandler");
const { initFirebase } = require("./services/firebase");

const app = express();
const PORT = process.env.PORT || 3000;

// Trust the nginx proxy in front of us
app.set("trust proxy", 1);

// Security
app.use(helmet());
const origins = (process.env.ALLOWED_ORIGINS || "").split(",").map(s => s.trim()).filter(Boolean);
app.use(cors({ origin: origins, credentials: true }));

// Rate limit — generous for authenticated traffic, tight on auth-less routes
const globalLimiter = rateLimit({
  windowMs: 60_000,
  limit: 200,
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(globalLimiter);

// Body parsing — raw body preserved for payment webhook verification
app.use(express.json({
  verify: (req, _res, buf) => { req.rawBody = buf; },
}));
app.use(express.urlencoded({ extended: true }));
app.use(morgan("combined", {
  skip: (req) => req.path.startsWith("/auth/reset-password"),
}));

// Initialize Firebase Admin (non-fatal if not yet configured)
try { initFirebase(); } catch (e) { console.warn("Firebase init skipped:", e.message); }

// Routes
app.use("/health", healthRoutes);
app.use("/payments", paymentRoutes);
app.use("/leads", leadRoutes);
app.use("/auth", authRoutes);
app.use("/email", emailRoutes);

app.use(errorHandler);

app.listen(PORT, "127.0.0.1", () => {
  console.log(`[anbucrm-api] listening on 127.0.0.1:${PORT}`);
});
