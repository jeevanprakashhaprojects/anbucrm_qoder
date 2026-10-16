require("dotenv").config();
const nodemailer = require("nodemailer");
const user = process.env.GMAIL_USER;
const pass = process.env.GMAIL_APP_PASSWORD;
const transport = nodemailer.createTransport({
  host: "smtp-relay.gmail.com",
  port: 587,
  secure: false,
  auth: { user, pass },
  tls: { ciphers: "SSLv3" },
});
(async () => {
  const info = await transport.sendMail({
    from: { name: "AnbuCRM", address: user },
    to: "anbarasaninsuranceacademywork@gmail.com",
    subject: "AnbuCRM test - DKIM fix",
    text: "This is a test email to verify DKIM is working.",
    html: "<div style=\"font-family:Arial,sans-serif;padding:16px\"><h2>AnbuCRM test</h2><p>Testing DKIM with smtp-relay.gmail.com</p></div>",
  });
  console.log("sent id:", info.messageId);
})().catch(e => { console.error("ERR", e); process.exit(1); });
