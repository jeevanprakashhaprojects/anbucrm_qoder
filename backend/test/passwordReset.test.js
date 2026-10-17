"use strict";

const assert = require("node:assert/strict");
const { describe, test } = require("node:test");
const http = require("node:http");
const { once } = require("node:events");
const { format } = require("node:util");
const { readFile } = require("node:fs/promises");
const path = require("node:path");
const express = require("express");
const nodemailer = require("nodemailer");
const { errorHandler } = require("../middleware/errorHandler");

// Never load server.js, dotenv, Firebase Admin, or any real credentials.
const TEST_ENV = {
  GMAIL_USER: "reset-sender@example.invalid",
  GMAIL_APP_PASSWORD: "synthetic-smtp-password-not-a-credential",
  FIREBASE_WEB_API_KEY: "synthetic-api-key/+?&=",
};
const EMAIL = "person@example.invalid";
const CODE = "synthetic_reset_code_1234567890";
const PASSWORD = "Synthetic-Test-Password9!";
const SENT = {
  ok: true,
  message: "If an account exists for this email, a password reset link has been sent.",
};
const INVALID = {
  error: "This reset link is invalid or has expired. Please request a new link.",
};
const UNAVAILABLE = {
  error: "Password reset is temporarily unavailable. Please try again shortly.",
};
const THROTTLED = {
  error: "Too many attempts. Please wait 15 minutes before trying again.",
};
const CODE_THROTTLED = {
  error: "Too many attempts with this reset link. Please request a new link.",
};
const STRONGER = {
  error: "Choose a stronger password with uppercase and lowercase letters, a number, and a symbol.",
};
const FORGOT = "/auth/forgot-password";
const VERIFY = "/auth/reset-password/verify";
const CONFIRM = "/auth/reset-password/confirm";
const ACTIONS = [
  { name: "verify", path: VERIFY, body: { oobCode: CODE } },
  { name: "confirm", path: CONFIRM, body: { oobCode: CODE, newPassword: PASSWORD } },
];

function providerResponse(data, status = 200) {
  return { ok: status >= 200 && status < 300, status, json: async () => data };
}

function providerError(message, status = 400) {
  return providerResponse({ error: { message } }, status);
}

async function createHarness(t) {
  const modulePaths = [
    require.resolve("../services/firebase"),
    require.resolve("../routes/passwordReset"),
    require.resolve("../routes/auth"),
  ];
  const savedModules = modulePaths.map((id) => [id, require.cache[id]]);
  const savedEnv = Object.keys(TEST_ENV).map((key) => [key, process.env[key]]);
  const calls = { admin: 0, emails: [], transports: [], mail: [], provider: [], logs: [] };
  const state = {
    generateLink: async () => `https://firebase.example.invalid/action?mode=resetPassword&oobCode=${CODE}`,
    sendMail: async () => ({ accepted: [EMAIL] }),
    // This is the application's assumed contract, not a live Firebase assertion.
    provider: async () => providerResponse({ requestType: "PASSWORD_RESET", email: EMAIL }),
  };
  let server;

  t.after(async () => {
    try {
      if (server?.listening) {
        await new Promise((resolve, reject) => {
          server.close((error) => error ? reject(error) : resolve());
          server.closeAllConnections();
        });
      }
    } finally {
      for (const [id, saved] of savedModules) {
        if (saved === undefined) delete require.cache[id];
        else require.cache[id] = saved;
      }
      for (const [key, saved] of savedEnv) {
        if (saved === undefined) delete process.env[key];
        else process.env[key] = saved;
      }
      t.mock.restoreAll();
    }
  });

  Object.assign(process.env, TEST_ENV);
  for (const method of ["error", "warn", "log"]) {
    t.mock.method(console, method, (...args) => calls.logs.push({ method, text: format(...args) }));
  }
  // getAdmin is destructured at module load: replace the service BEFORE loading
  // either router. A fresh router also gives every test fresh real rate limiters.
  for (const id of modulePaths) delete require.cache[id];
  require.cache[modulePaths[0]] = {
    id: modulePaths[0], filename: modulePaths[0], loaded: true,
    exports: {
      getAdmin() {
        calls.admin += 1;
        return {
          auth: () => ({
            async generatePasswordResetLink(email) {
              calls.emails.push(email);
              return state.generateLink(email);
            },
          }),
        };
      },
    },
  };
  t.mock.method(nodemailer, "createTransport", (options) => {
    calls.transports.push(options);
    return {
      async sendMail(message) {
        calls.mail.push(message);
        return state.sendMail(message);
      },
    };
  });
  t.mock.method(globalThis, "fetch", async (url, options) => {
    const call = { url, ...options, body: JSON.parse(options.body) };
    calls.provider.push(call);
    return state.provider(call);
  });

  const app = express();
  app.set("trust proxy", 1); // Same single nginx hop as server.js.
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use("/auth", require("../routes/auth"));
  app.use(errorHandler);
  server = http.createServer(app);
  server.listen(0, "127.0.0.1");
  await once(server, "listening");

  // HTTP intentionally does not use fetch: global fetch belongs to the provider
  // stub, and the only real connection in this suite is this loopback server.
  async function request(method, path, body, options = {}) {
    const payload = options.rawBody ?? (body === undefined ? "" : JSON.stringify(body));
    const headers = {
      "X-Forwarded-For": options.ip || "203.0.113.10",
      "Content-Length": Buffer.byteLength(payload),
      Connection: "close",
      ...options.headers,
    };
    const contentType = options.contentType === undefined ? "application/json" : options.contentType;
    if (contentType !== null) headers["Content-Type"] = contentType;
    return new Promise((resolve, reject) => {
      const req = http.request({
        hostname: "127.0.0.1", port: server.address().port,
        method, path, headers, agent: false,
      }, (res) => {
        let text = "";
        res.setEncoding("utf8");
        res.on("data", (chunk) => { text += chunk; });
        res.on("error", reject);
        res.on("end", () => {
          try {
            const body = /^application\/json\b/.test(res.headers["content-type"] || "") ? JSON.parse(text) : undefined;
            resolve({ status: res.statusCode, headers: res.headers, body, text });
          } catch (error) {
            reject(error);
          }
        });
      });
      req.on("error", reject);
      req.setTimeout(5000, () => req.destroy(new Error("Local test request timed out")));
      req.end(payload);
    });
  }
  return {
    post: (path, body, options) => request("POST", path, body, options),
    get: (path, options) => request("GET", path, undefined, { contentType: null, ...options }),
    calls, state,
  };
}

function expectJson(response, status, body, privacyHeaders = true) {
  assert.equal(response.status, status);
  assert.match(response.headers["content-type"], /^application\/json\b/);
  assert.deepEqual(response.body, body);
  if (privacyHeaders) {
    assert.equal(response.headers["cache-control"], "no-store");
    assert.equal(response.headers["referrer-policy"], "no-referrer");
  }
  assert.equal(response.headers.location, undefined);
}

function expectNoProviders(h) {
  assert.equal(h.calls.admin, 0);
  assert.equal(h.calls.transports.length, 0);
  assert.equal(h.calls.mail.length, 0);
  assert.equal(h.calls.provider.length, 0);
}

function expectRedacted(h, response, extra = []) {
  const output = [response.text, ...h.calls.logs.map((entry) => entry.text)].join("\n");
  for (const value of [CODE, PASSWORD, EMAIL, ...Object.values(TEST_ENV), ...extra]) {
    // Boolean assertion avoids dumping the captured log if a regression occurs.
    assert.equal(output.includes(value), false, "Response/log output must redact sensitive test data");
  }
}

function expectProviderCall(call, body) {
  const url = new URL(call.url);
  assert.equal(url.origin, "https://identitytoolkit.googleapis.com");
  assert.equal(url.pathname, "/v1/accounts:resetPassword");
  assert.deepEqual([...url.searchParams], [["key", TEST_ENV.FIREBASE_WEB_API_KEY]]);
  assert.equal(call.method, "POST");
  assert.deepEqual(call.headers, { "Content-Type": "application/json" });
  assert.deepEqual(call.body, body);
  assert.ok(call.signal instanceof AbortSignal);
  assert.equal(call.signal.aborted, false);
}

function routeTest(name, fn) {
  test(name, { timeout: 10000 }, async (t) => fn(await createHarness(t), t));
}

// Cache/environment/global patches must not overlap within this process.
describe("password reset HTTP routes", { concurrency: false }, () => {
  routeTest("reset page is served with no-store, no-referrer, and a restrictive self-only CSP", async (h) => {
    const response = await h.get("/auth/reset-password");
    assert.equal(response.status, 200);
    assert.match(response.headers["content-type"], /^text\/html\b/);
    assert.equal(response.headers["cache-control"], "no-store");
    assert.equal(response.headers["referrer-policy"], "no-referrer");
    const csp = response.headers["content-security-policy"];
    assert.equal(typeof csp, "string");
    const directives = Object.fromEntries(csp.split(";").filter(Boolean).map((directive) => {
      const [name, ...values] = directive.trim().split(/\s+/);
      return [name, values];
    }));
    for (const name of ["default-src", "script-src", "style-src", "connect-src", "font-src", "form-action"]) {
      assert.deepEqual(directives[name], ["'self'"]);
    }
    for (const name of ["frame-ancestors", "base-uri", "object-src"]) {
      assert.deepEqual(directives[name], ["'none'"]);
    }
    assert.deepEqual(directives["img-src"], ["'self'", "data:"]);
    assert.doesNotMatch(csp, /'unsafe-inline'|'unsafe-eval'/);
    const html = response.text;
    assert.deepEqual([...html.matchAll(/<script\b[^>]*src="([^"]+)"[^>]*>\s*<\/script>/g)].map((match) => match[1]), ["/auth/password-reset.js"]);
    assert.equal((html.match(/<script\b/g) || []).length, 1);
    assert.match(html, /<link\b[^>]*rel="stylesheet"[^>]*href="\/auth\/password-reset\.css"/);
    assert.doesNotMatch(html, /<style\b|\sstyle\s*=|\son[a-z]+\s*=/i);
    expectNoProviders(h);
  });

  for (const [filename, contentType] of [
    ["password-reset.html", /^text\/html\b/],
    ["password-reset.css", /^text\/css\b/],
    ["password-reset.js", /^(?:application|text)\/javascript\b/],
  ]) {
    routeTest(`serves the existing ${filename} asset unchanged without provider access`, async (h) => {
      const url = filename.endsWith(".html") ? "/auth/reset-password" : `/auth/${filename}`;
      const response = await h.get(url);
      assert.equal(response.status, 200);
      assert.match(response.headers["content-type"], contentType);
      assert.equal(response.headers["cache-control"], "no-store");
      assert.equal(response.headers["referrer-policy"], "no-referrer");
      assert.equal(response.text, await readFile(path.join(__dirname, "..", "public", filename), "utf8"));
      assert.ok(response.text.length > 0);
      expectNoProviders(h);
      expectRedacted(h, response);
    });
  }

  routeTest("reset page does not reflect or redirect to untrusted query parameters", async (h) => {
    const attacker = "https://attacker.example.invalid";
    const response = await h.get(`/auth/reset-password?oobCode=${CODE}&continueUrl=${encodeURIComponent(attacker)}`);
    assert.equal(response.status, 200);
    assert.equal(response.headers.location, undefined);
    expectNoProviders(h);
    expectRedacted(h, response, [attacker]);
  });

  const malformedEmails = [
    ["missing", {}], ["null", { email: null }], ["number", { email: 7 }],
    ["object", { email: {} }], ["array", { email: [EMAIL] }],
    ["empty", { email: "" }], ["whitespace", { email: " \t " }],
    ["missing @", { email: "example.invalid" }],
    ["missing domain", { email: "person@" }],
    ["missing domain dot", { email: "person@example" }],
    ["two @ signs", { email: "person@@example.invalid" }],
    ["embedded whitespace", { email: "per son@example.invalid" }],
    ["header injection", { email: `${EMAIL}\r\nBcc: other@example.invalid` }],
    ["255 characters", { email: `${"a".repeat(241)}@example.testx` }],
  ];
  for (const [name, body] of malformedEmails) {
    routeTest(`forgot rejects ${name} email without provider access`, async (h) => {
      expectJson(await h.post(FORGOT, body), 400, { error: "Enter a valid email address." });
      expectNoProviders(h);
    });
  }

  routeTest("forgot trims and lowercases the email before lookup and delivery", async (h) => {
    expectJson(await h.post(FORGOT, { email: " \tPerson@EXAMPLE.INVALID\r\n" }), 200, SENT);
    assert.deepEqual(h.calls.emails, [EMAIL]);
    assert.equal(h.calls.mail[0].to, EMAIL);
    assert.equal(h.calls.provider.length, 0);
  });

  routeTest("forgot accepts the current 254-character email boundary", async (h) => {
    const email = `${"a".repeat(240)}@example.testx`;
    assert.equal(email.length, 254);
    expectJson(await h.post(FORGOT, { email }), 200, SENT);
    assert.deepEqual(h.calls.emails, [email]);
  });

  routeTest("existing, nonexistent, and disabled accounts receive the same neutral response", async (h) => {
    const existing = await h.post(FORGOT, { email: EMAIL });
    expectJson(existing, 200, SENT);
    for (const code of ["auth/user-not-found", "auth/user-disabled"]) {
      h.state.generateLink = async () => { throw Object.assign(new Error("Synthetic private detail"), { code }); };
      const response = await h.post(FORGOT, { email: `${code.slice(5)}@example.invalid` });
      expectJson(response, existing.status, existing.body);
      expectRedacted(h, response);
    }
    assert.equal(h.calls.emails.length, 3);
    assert.equal(h.calls.mail.length, 1);
    assert.deepEqual(h.calls.logs, []);
  });

  routeTest("email limiter normalizes its key across IPs and silently stops after three attempts", async (h) => {
    for (let i = 0; i < 4; i += 1) {
      const email = i % 2 ? " Person@EXAMPLE.INVALID " : EMAIL;
      expectJson(await h.post(FORGOT, { email }, { ip: `203.0.113.${i + 1}` }), 200, SENT);
      assert.equal(h.calls.emails.length, Math.min(i + 1, 3));
      assert.equal(h.calls.mail.length, Math.min(i + 1, 3));
    }
    expectJson(await h.post(FORGOT, { email: "different@example.invalid" }, { ip: "203.0.113.4" }), 200, SENT);
    assert.equal(h.calls.mail.length, 4);
  });

  routeTest("nonexistent emails also consume the neutral per-email limit", async (h) => {
    h.state.generateLink = async () => { throw Object.assign(new Error("Synthetic missing user"), { code: "auth/user-not-found" }); };
    for (let i = 0; i < 4; i += 1) {
      expectJson(await h.post(FORGOT, { email: EMAIL }, { ip: `203.0.113.${i + 1}` }), 200, SENT);
    }
    assert.equal(h.calls.emails.length, 3);
    assert.equal(h.calls.transports.length, 0);
  });

  routeTest("IP limiter is a 20-request backstop; another proxy client is independent", async (h) => {
    for (let i = 0; i < 20; i += 1) {
      expectJson(await h.post(FORGOT, { email: `person${i}@example.invalid` }), 200, SENT);
    }
    const response = await h.post(FORGOT, { email: "twentyfirst@example.invalid" });
    expectJson(response, 429, THROTTLED);
    assert.equal(response.headers["ratelimit-limit"], "20");
    assert.equal(response.headers["ratelimit-remaining"], "0");
    assert.ok(Number(response.headers["retry-after"]) > 0);
    assert.ok(Number(response.headers["retry-after"]) <= 900);
    assert.equal(response.headers["x-ratelimit-limit"], undefined);
    assert.equal(h.calls.mail.length, 20);
    expectJson(await h.post(FORGOT, { email: "twentyfirst@example.invalid" }, { ip: "203.0.113.20" }), 200, SENT);
    assert.equal(h.calls.mail.length, 21);
  });

  routeTest("email limiter punishes only the repeated address, not the whole IP", async (h) => {
    for (let i = 0; i < 3; i += 1) {
      expectJson(await h.post(FORGOT, { email: EMAIL }), 200, SENT);
    }
    // Fourth send to the same address is silently skipped.
    expectJson(await h.post(FORGOT, { email: EMAIL }), 200, SENT);
    assert.equal(h.calls.mail.length, 3);
    // Other addresses from the same IP keep working.
    expectJson(await h.post(FORGOT, { email: "other@example.invalid" }), 200, SENT);
    assert.equal(h.calls.mail.length, 4);
  });

  routeTest("invalid emails still consume the IP limit", async (h) => {
    for (let i = 0; i < 20; i += 1) {
      expectJson(await h.post(FORGOT, { email: "invalid" }), 400, { error: "Enter a valid email address." });
    }
    expectJson(await h.post(FORGOT, { email: EMAIL }), 429, THROTTLED);
    expectNoProviders(h);
  });

  for (const endpoint of [{ name: "forgot", path: FORGOT, body: { email: EMAIL } }, ...ACTIONS]) {
    routeTest(`${endpoint.name} requires JSON rather than form, text, or a missing content type`, async (h) => {
      for (const contentType of ["text/plain", "application/x-www-form-urlencoded", "multipart/form-data", null]) {
        expectJson(await h.post(endpoint.path, endpoint.body, { contentType }), 415, {
          error: "Send an application/json request.",
        });
      }
      expectNoProviders(h);
    });
    routeTest(`${endpoint.name} accepts application/json with a charset`, async (h) => {
      expectJson(await h.post(endpoint.path, endpoint.body, { contentType: "application/json; charset=utf-8" }),
        200, endpoint.path === FORGOT ? SENT : { ok: true });
    });
    routeTest(`${endpoint.name} rejects malformed JSON before contacting providers`, async (h) => {
      const response = await h.post(endpoint.path, undefined, { rawBody: '{"broken":' });
      assert.equal(response.status, 400);
      assert.match(response.headers["content-type"], /^application\/json\b/);
      assert.equal(typeof response.body.error, "string");
      expectNoProviders(h);
    });
  }

  routeTest("email uses the configured sender and only the trusted HTTPS fragment link", async (h) => {
    const attacker = "https://attacker.example.invalid";
    h.state.generateLink = async () => `https://firebase.example.invalid/action?oobCode=${CODE}&continueUrl=${encodeURIComponent(attacker)}`;
    expectJson(await h.post(`${FORGOT}?redirect=${encodeURIComponent(attacker)}`, {
      email: EMAIL, origin: attacker, redirect: attacker, redirectUrl: attacker, continueUrl: attacker,
    }, {
      headers: { Origin: attacker, Referer: `${attacker}/page`, Host: "attacker.example.invalid", "X-Forwarded-Host": "attacker.example.invalid" },
    }), 200, SENT);
    assert.deepEqual(h.calls.transports, [{
      service: "gmail", auth: { user: TEST_ENV.GMAIL_USER, pass: TEST_ENV.GMAIL_APP_PASSWORD },
      connectionTimeout: 10000, greetingTimeout: 10000, socketTimeout: 15000,
    }]);
    assert.equal(h.calls.mail.length, 1);
    const mail = h.calls.mail[0];
    assert.deepEqual(mail.from, { name: "AnbuCRM", address: TEST_ENV.GMAIL_USER });
    assert.equal(mail.to, EMAIL);
    assert.equal(mail.subject, "Reset your AnbuCRM password");
    const expectedLink = `https://api.anbucrm.com/auth/reset-password#oobCode=${CODE}`;
    assert.deepEqual(mail.text.match(/https?:\/\/\S+/g), [expectedLink]);
    assert.deepEqual([...mail.html.matchAll(/href="([^"]+)"/g)].map((match) => match[1]), [expectedLink]);
    const parsed = new URL(expectedLink);
    assert.equal(parsed.search, "");
    assert.equal(new URLSearchParams(parsed.hash.slice(1)).get("oobCode"), CODE);
    for (const value of [attacker, "firebase.example.invalid", TEST_ENV.FIREBASE_WEB_API_KEY, TEST_ENV.GMAIL_APP_PASSWORD]) {
      assert.equal(`${mail.text}${mail.html}`.includes(value), false);
    }
    assert.deepEqual(h.calls.logs, []);
  });

  routeTest("generated code is encoded before interpolation into text or HTML", async (h) => {
    const code = `${CODE}+/=&\"'<>`;
    h.state.generateLink = async () => `https://firebase.example.invalid/action?oobCode=${encodeURIComponent(code)}`;
    expectJson(await h.post(FORGOT, { email: EMAIL }), 200, SENT);
    const expected = `https://api.anbucrm.com/auth/reset-password#oobCode=${encodeURIComponent(code)}`;
    assert.ok(h.calls.mail[0].text.includes(expected));
    assert.ok(h.calls.mail[0].html.includes(`href="${expected}"`));
    assert.equal(h.calls.mail[0].html.includes(code), false);
    assert.equal(new URLSearchParams(new URL(expected).hash.slice(1)).get("oobCode"), code);
  });

  for (const key of Object.keys(TEST_ENV)) {
    routeTest(`forgot returns redacted 503 when ${key} is missing`, async (h) => {
      delete process.env[key];
      const response = await h.post(FORGOT, { email: EMAIL });
      expectJson(response, 503, UNAVAILABLE);
      expectNoProviders(h);
      expectRedacted(h, response);
    });
  }

  for (const failure of ["SMTP send", "transport creation", "Firebase link generation"]) {
    routeTest(`${failure} failures return neutral 200 and redact credentials, reset codes, and provider details`, async (h, t) => {
      const detail = "synthetic-private-provider-detail";
      const fail = () => { throw new Error(`${detail} ${CODE} ${EMAIL} ${PASSWORD} ${Object.values(TEST_ENV).join(" ")}`); };
      if (failure === "SMTP send") h.state.sendMail = fail;
      else if (failure === "transport creation") t.mock.method(nodemailer, "createTransport", fail);
      else h.state.generateLink = fail;
      const response = await h.post(FORGOT, { email: EMAIL });
      expectJson(response, 200, SENT);
      expectRedacted(h, response, [detail]);
      assert.deepEqual(h.calls.logs, [{ method: "error", text: "[password-reset] Email service unavailable" }]);
      assert.equal(h.calls.provider.length, 0);
    });
  }

  routeTest("SMTP outages return the same neutral response for existing and nonexistent accounts", async (h) => {
    h.state.sendMail = async () => { throw new Error("Synthetic SMTP outage"); };
    const existing = await h.post(FORGOT, { email: EMAIL });
    h.state.generateLink = async () => { throw Object.assign(new Error("Synthetic absent account"), { code: "auth/user-not-found" }); };
    const absent = await h.post(FORGOT, { email: "absent@example.invalid" });
    expectJson(existing, 200, SENT);
    expectJson(absent, existing.status, existing.body);
    expectRedacted(h, existing, ["Synthetic SMTP outage"]);
    expectRedacted(h, absent, ["Synthetic absent account"]);
    assert.equal(h.calls.emails.length, 2);
    assert.equal(h.calls.mail.length, 1);
    assert.deepEqual(h.calls.logs, [{ method: "error", text: "[password-reset] Email service unavailable" }]);
  });

  for (const [name, link] of [
    ["malformed URL", "not a URL"],
    ["missing code", "https://firebase.example.invalid/action?mode=resetPassword"],
    ["empty code", "https://firebase.example.invalid/action?oobCode="],
  ]) {
    routeTest(`generated link with ${name} returns neutral 200 without email delivery`, async (h) => {
      h.state.generateLink = async () => link;
      const response = await h.post(FORGOT, { email: EMAIL });
      expectJson(response, 200, SENT);
      assert.equal(h.calls.transports.length, 0);
      assert.equal(h.calls.mail.length, 0);
      assert.deepEqual(h.calls.logs, [{ method: "error", text: "[password-reset] Email service unavailable" }]);
      expectRedacted(h, response);
    });
  }

  for (const action of ACTIONS) {
    routeTest(`${action.name} rejects malformed, missing, and oversized codes locally`, async (h) => {
      const codes = [undefined, null, 42, {}, [CODE], "", "a".repeat(19), "a".repeat(2049), ` ${CODE}`, `${CODE}\n`, `${CODE}+`, `${CODE}/`, `${CODE}=`];
      for (const oobCode of codes) {
        expectJson(await h.post(action.path, { ...action.body, oobCode }), 400, INVALID);
      }
      expectNoProviders(h);
    });

    routeTest(`${action.name} accepts 20- and 2048-character URL-safe codes`, async (h) => {
      for (const code of [`A_-${"b".repeat(17)}`, `A_-${"b".repeat(2045)}`]) {
        expectJson(await h.post(action.path, { ...action.body, oobCode: code }), 200, { ok: true });
        expectProviderCall(h.calls.provider.at(-1), { ...action.body, oobCode: code });
      }
    });

    routeTest(`${action.name} fails before provider access if the web API key is missing`, async (h) => {
      delete process.env.FIREBASE_WEB_API_KEY;
      const response = await h.post(action.path, action.body);
      expectJson(response, 503, UNAVAILABLE);
      expectNoProviders(h);
      expectRedacted(h, response);
    });

    routeTest(`${action.name} does not require SMTP configuration`, async (h) => {
      delete process.env.GMAIL_USER;
      delete process.env.GMAIL_APP_PASSWORD;
      expectJson(await h.post(action.path, action.body), 200, { ok: true });
      assert.equal(h.calls.provider.length, action.path === CONFIRM ? 2 : 1);
      expectProviderCall(h.calls.provider[0], { oobCode: CODE });
      expectProviderCall(h.calls.provider.at(-1), action.body);
      assert.equal(h.calls.admin, 0);
      assert.equal(h.calls.transports.length, 0);
    });

    for (const code of ["INVALID_OOB_CODE", "EXPIRED_OOB_CODE", "USER_DISABLED", "EMAIL_NOT_FOUND"]) {
      routeTest(`${action.name} maps ${code} to the same invalid-link error`, async (h) => {
        h.state.provider = async () => providerError(`${code} : ${EMAIL} ${CODE}`);
        const response = await h.post(action.path, action.body);
        expectJson(response, 400, INVALID);
        assert.equal(h.calls.provider.length, 1);
        expectProviderCall(h.calls.provider[0], { oobCode: CODE });
        expectRedacted(h, response);
      });
    }

    for (const requestType of ["VERIFY_EMAIL", "EMAIL_SIGNIN", undefined]) {
      routeTest(`${action.name} rejects successful provider responses with ${requestType ?? "missing"} requestType`, async (h) => {
        h.state.provider = async () => providerResponse({ requestType, email: EMAIL });
        const response = await h.post(action.path, action.body);
        expectJson(response, 400, INVALID);
        assert.equal(h.calls.provider.length, 1);
        expectProviderCall(h.calls.provider[0], { oobCode: CODE });
        expectRedacted(h, response);
      });
    }

    for (const [name, status, message] of [
      ["provider quota code", 400, "TOO_MANY_ATTEMPTS_TRY_LATER"],
      ["HTTP 429", 429, "SYNTHETIC_QUOTA_DETAIL"],
    ]) {
      routeTest(`${action.name} maps ${name} to a redacted 429`, async (h) => {
        h.state.provider = async () => providerError(message, status);
        const response = await h.post(action.path, action.body);
        expectJson(response, 429, THROTTLED);
        assert.equal(h.calls.provider.length, 1);
        expectProviderCall(h.calls.provider[0], { oobCode: CODE });
        expectRedacted(h, response, [message]);
      });
    }

    for (const failure of ["network", "abort", "timeout", "unreadable JSON", "unknown provider error"]) {
      routeTest(`${action.name} returns redacted 503 for ${failure}`, async (h) => {
        const detail = `${CODE} ${PASSWORD} ${TEST_ENV.FIREBASE_WEB_API_KEY}`;
        h.state.provider = async () => {
          if (failure === "network") throw new Error(detail);
          if (failure === "abort") throw new DOMException(detail, "AbortError");
          if (failure === "timeout") throw new DOMException(detail, "TimeoutError");
          if (failure === "unreadable JSON") return { ok: true, status: 200, json: async () => { throw new SyntaxError(detail); } };
          return providerError(`INTERNAL_ERROR : ${detail}`, 500);
        };
        const response = await h.post(action.path, action.body);
        expectJson(response, 503, UNAVAILABLE);
        expectRedacted(h, response);
        assert.equal(h.calls.provider.length, 1);
        expectProviderCall(h.calls.provider[0], { oobCode: CODE });
        assert.deepEqual(h.calls.logs, []);
      });
    }
  }

  routeTest("verify sends only the code and never exposes the provider email", async (h) => {
    const response = await h.post(VERIFY, { oobCode: CODE, newPassword: PASSWORD, email: EMAIL, requestType: "VERIFY_EMAIL" });
    expectJson(response, 200, { ok: true });
    assert.equal(h.calls.provider.length, 1);
    expectProviderCall(h.calls.provider[0], { oobCode: CODE });
    expectRedacted(h, response);
    assert.equal(h.calls.admin, 0);
    assert.equal(h.calls.transports.length, 0);
  });

  routeTest("confirm verifies the code before forwarding a valid password exactly once and succeeds", async (h) => {
    const response = await h.post(CONFIRM, {
      oobCode: CODE, newPassword: PASSWORD, email: EMAIL,
      continueUrl: "https://attacker.example.invalid", requestType: "VERIFY_EMAIL",
    });
    expectJson(response, 200, { ok: true });
    assert.equal(h.calls.provider.length, 2);
    expectProviderCall(h.calls.provider[0], { oobCode: CODE });
    expectProviderCall(h.calls.provider[1], { oobCode: CODE, newPassword: PASSWORD });
    expectRedacted(h, response);
    assert.equal(h.calls.admin, 0);
    assert.equal(h.calls.mail.length, 0);
  });

  routeTest("confirm never sends newPassword for a non-password action code even if mutation would succeed", async (h) => {
    h.state.provider = async ({ body }) => providerResponse({
      requestType: Object.hasOwn(body, "newPassword") ? "PASSWORD_RESET" : "VERIFY_EMAIL",
      email: EMAIL,
    });
    const response = await h.post(CONFIRM, { oobCode: CODE, newPassword: PASSWORD, requestType: "PASSWORD_RESET" });
    expectJson(response, 400, INVALID);
    assert.equal(h.calls.provider.length, 1);
    expectProviderCall(h.calls.provider[0], { oobCode: CODE });
    assert.equal(h.calls.provider.some(({ body }) => Object.hasOwn(body, "newPassword")), false);
    expectRedacted(h, response);
  });

  routeTest("confirm rejects missing, non-string, and rule-failing passwords locally with 422", async (h) => {
    for (const newPassword of [undefined, null, 12345678, {}, [PASSWORD], "", "Aa1!abc", "aaaaaaaa", "ABCDEFGH1!", "12345678a!", "A".repeat(129), "A".repeat(4096)]) {
      expectJson(await h.post(CONFIRM, { oobCode: CODE, newPassword }), 422, STRONGER);
    }
    expectNoProviders(h);
  });

  routeTest("confirm accepts 8/128-character boundaries and preserves password whitespace", async (h) => {
    for (const newPassword of ["Aa1!bcde", `Aa1!${"x".repeat(124)}`, ` ${PASSWORD} `]) {
      expectJson(await h.post(CONFIRM, { oobCode: CODE, newPassword }), 200, { ok: true });
      expectProviderCall(h.calls.provider.at(-1), { oobCode: CODE, newPassword });
    }
  });

  for (const code of ["WEAK_PASSWORD", "PASSWORD_DOES_NOT_MEET_REQUIREMENTS"]) {
    routeTest(`confirm still maps provider ${code} on a rule-valid password to 422`, async (h) => {
      h.state.provider = async ({ body }) => Object.hasOwn(body, "newPassword")
        ? providerError(`${code} : ${CODE}`)
        : providerResponse({ requestType: "PASSWORD_RESET", email: EMAIL });
      const response = await h.post(CONFIRM, { oobCode: CODE, newPassword: PASSWORD });
      expectJson(response, 422, STRONGER);
      assert.equal(h.calls.provider.length, 2);
      expectProviderCall(h.calls.provider[0], { oobCode: CODE });
      expectProviderCall(h.calls.provider.at(-1), { oobCode: CODE, newPassword: PASSWORD });
      expectRedacted(h, response, [PASSWORD]);
    });
  }

  routeTest("verify does not consume a code; confirm consumes it and repeated use is invalid", async (h) => {
    let consumed = false;
    h.state.provider = async ({ body }) => {
      if (consumed) return providerError("INVALID_OOB_CODE");
      if (Object.hasOwn(body, "newPassword")) consumed = true;
      return providerResponse({ requestType: "PASSWORD_RESET", email: EMAIL });
    };
    expectJson(await h.post(VERIFY, { oobCode: CODE }), 200, { ok: true });
    expectJson(await h.post(VERIFY, { oobCode: CODE }), 200, { ok: true });
    assert.equal(consumed, false);
    expectJson(await h.post(CONFIRM, { oobCode: CODE, newPassword: PASSWORD }), 200, { ok: true });
    assert.equal(consumed, true);
    expectJson(await h.post(CONFIRM, { oobCode: CODE, newPassword: PASSWORD }), 400, INVALID);
    expectJson(await h.post(VERIFY, { oobCode: CODE }), 400, INVALID);
    assert.equal(h.calls.provider.length, 6);
    assert.deepEqual(h.calls.provider.map(({ body }) => body), [
      { oobCode: CODE },
      { oobCode: CODE },
      { oobCode: CODE },
      { oobCode: CODE, newPassword: PASSWORD },
      { oobCode: CODE },
      { oobCode: CODE },
    ]);
  });

  routeTest("one exhausted code bucket never blocks another link from the same IP", async (h) => {
    for (let i = 0; i < 15; i += 1) {
      const action = ACTIONS[i % ACTIONS.length];
      expectJson(await h.post(action.path, action.body), 200, { ok: true });
    }
    for (const action of ACTIONS) {
      const response = await h.post(action.path, action.body);
      expectJson(response, 429, CODE_THROTTLED);
      assert.equal(response.headers["ratelimit-limit"], undefined);
    }
    const other = `${CODE}other`;
    expectJson(await h.post(VERIFY, { oobCode: other }), 200, { ok: true });
    expectJson(await h.post(CONFIRM, { oobCode: other, newPassword: PASSWORD }), 200, { ok: true });
    expectJson(await h.post(VERIFY, { oobCode: CODE }, { ip: "203.0.113.20" }), 429, CODE_THROTTLED);
    expectJson(await h.post(FORGOT, { email: EMAIL }), 200, SENT);
  });

  routeTest("verify and confirm share a 100-attempt IP limit independent of forgot", async (h) => {
    for (let i = 0; i < 100; i += 1) {
      const action = ACTIONS[i % ACTIONS.length];
      expectJson(await h.post(action.path, { ...action.body, oobCode: `${CODE}${i}` }), 200, { ok: true });
    }
    const response = await h.post(VERIFY, { oobCode: `${CODE}blocked` });
    expectJson(response, 429, THROTTLED);
    assert.equal(response.headers["ratelimit-limit"], "100");
    assert.equal(response.headers["ratelimit-remaining"], "0");
    assert.ok(Number(response.headers["retry-after"]) > 0);
    assert.equal(h.calls.provider.length, 150);
    expectJson(await h.post(VERIFY, { oobCode: CODE }, { ip: "203.0.113.20" }), 200, { ok: true });
    assert.equal(h.calls.provider.length, 151);
    expectJson(await h.post(FORGOT, { email: EMAIL }), 200, SENT);
  });
});
