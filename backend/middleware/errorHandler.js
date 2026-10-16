function errorHandler(err, req, res, _next) {
  console.error("[error]", err && err.stack ? err.stack : err);
  const status = err.status || 500;
  res.status(status).json({
    error: err.expose ? err.message : "Internal server error",
  });
}

class HttpError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
    this.expose = true;
  }
}

module.exports = { errorHandler, HttpError };
