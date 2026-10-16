const express = require('express');
const { requireAuth } = require('../middleware/auth');
const PDFDocument = require('pdfkit');

const router = express.Router();

function mailerConfig() {
  const user = process.env.GMAIL_USER;
  const pass = process.env.GMAIL_APP_PASSWORD;
  if (!user || !pass) return null;
  const nodemailer = require('nodemailer');
  return {
    transporter: nodemailer.createTransport({
      service: 'gmail',
      auth: { user, pass },
    }),
    user,
  };
}

const BASE_PRICE = 500;
const GST_RATE = 0.18;
const PLAN_TERMS = ['Monthly', 'Yearly', '2 Years'];

function inr(n) {
  return '\u20B9' + Number(n).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function fmtDate(d) {
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return `${d.getDate()} ${months[d.getMonth()]} ${d.getFullYear()}`;
}

function nextPeriodEnd(start, planTerm) {
  const end = new Date(start);
  if (planTerm === 'Yearly') end.setFullYear(end.getFullYear() + 1);
  else if (planTerm === '2 Years') end.setFullYear(end.getFullYear() + 2);
  else end.setMonth(end.getMonth() + 1);
  return end;
}

function generateInvoicePdf(d) {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ margin: 50, size: 'A4' });
    const chunks = [];
    doc.on('data', chunk => chunks.push(chunk));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    // Header
    doc.rect(0, 0, doc.page.width, 120).fill('#4f46e5');
    doc.fillColor('white').fontSize(28).font('Helvetica-Bold').text('AnbuCRM', 50, 30);
    doc.fontSize(12).font('Helvetica').text('Payment Invoice', 50, 65);
    doc.fontSize(10).text(`Invoice Date: ${fmtDate(new Date())}`, 50, 90);

    // Customer info
    doc.fillColor('#0f172a').fontSize(10).font('Helvetica-Bold').text('BILLED TO', 50, 150);
    doc.font('Helvetica').fontSize(12).text(d.name, 50, 165);
    doc.fontSize(10).fillColor('#475569').text(d.email, 50, 182);
    if (d.phone) doc.text(d.phone, 50, 197);

    // Invoice details
    doc.fillColor('#0f172a').fontSize(10).font('Helvetica-Bold').text('INVOICE DETAILS', 320, 150);
    doc.font('Helvetica').fontSize(10).fillColor('#475569');
    doc.text(`Plan: ${d.planTerm}`, 320, 165);
    doc.text(`Period: ${d.periodStart}`, 320, 180);
    doc.text(`To: ${d.periodEnd}`, 320, 195);

    // Line items
    let y = 240;
    doc.fillColor('#0f172a').fontSize(11).font('Helvetica-Bold').text('Description', 50, y);
    doc.text('Amount', 450, y, { align: 'right' });
    y += 5;
    doc.rect(50, y, doc.page.width - 100, 1).fill('#e2e8f0');
    y += 15;

    doc.font('Helvetica').fontSize(10).fillColor('#334155');
    doc.text(`AnbuCRM subscription - ${d.planTerm} plan`, 50, y);
    doc.text(inr(d.basePrice), 450, y, { align: 'right' });
    y += 20;

    if (d.discountPercent > 0) {
      doc.fillColor('#059669').text(`Discount (${d.discountPercent}% off${d.couponCode ? ' - ' + d.couponCode : ''})`, 50, y);
      doc.text('-' + inr(d.basePrice - d.subtotal), 450, y, { align: 'right' });
      y += 20;
    }

    doc.fillColor('#475569').text('Subtotal', 50, y);
    doc.text(inr(d.subtotal), 450, y, { align: 'right' });
    y += 20;

    doc.text('GST @ 18%', 50, y);
    doc.text(inr(d.tax), 450, y, { align: 'right' });
    y += 10;
    doc.rect(50, y, doc.page.width - 100, 1).fill('#0f172a');
    y += 15;

    doc.fillColor('#0f172a').fontSize(14).font('Helvetica-Bold').text('TOTAL PAID', 50, y);
    doc.fillColor('#4f46e5').text(inr(d.totalAmount), 450, y, { align: 'right' });

    // Footer
    y = doc.page.height - 80;
    doc.rect(50, y, doc.page.width - 100, 60).fill('#f8fafc').stroke('#e2e8f0');
    doc.fillColor('#059669').fontSize(11).font('Helvetica-Bold').text('STATUS: ACTIVE', 70, y + 15);
    doc.fillColor('#64748b').fontSize(9).font('Helvetica').text('This is an automated invoice from AnbuCRM.', 70, y + 35);

    doc.end();
  });
}

function invoiceHtml(d) {
  const discountRow = d.discountPercent > 0
    ? `<tr><td style="padding:10px 0;color:#475569;">Discount (${d.discountPercent}% off${d.couponCode ? ' · ' + d.couponCode : ''})</td><td style="padding:10px 0;text-align:right;color:#059669;">-${inr(d.basePrice - d.subtotal)}</td></tr>`
    : '';
  return `<div style="margin:0;padding:0;background:#f1f5f9;">
  <div style="max-width:560px;margin:0 auto;padding:24px 16px;font-family:Arial,Helvetica,sans-serif;">
    <div style="background:#ffffff;border-radius:12px;overflow:hidden;border:1px solid #e2e8f0;">
      <div style="background:linear-gradient(135deg,#4f46e5,#7c3aed);padding:28px 32px;">
        <div style="color:#ffffff;font-size:22px;font-weight:bold;">AnbuCRM</div>
        <div style="color:rgba(255,255,255,0.85);font-size:13px;margin-top:4px;">Payment Invoice</div>
      </div>
      <div style="padding:32px;">
        <p style="margin:0 0 20px;font-size:14px;color:#334155;">Hi ${d.name},</p>
        <p style="margin:0 0 24px;font-size:14px;color:#475569;line-height:1.6;">Thank you for subscribing to AnbuCRM. Your account has been created successfully and your plan is now active. Here is your invoice.</p>
        <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;padding:16px 20px;margin-bottom:24px;">
          <div style="font-size:12px;color:#64748b;text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;">Billed To</div>
          <div style="font-size:14px;color:#0f172a;font-weight:bold;">${d.name}</div>
          <div style="font-size:13px;color:#475569;">${d.email}${d.phone ? ' · ' + d.phone : ''}</div>
        </div>
        <table style="width:100%;border-collapse:collapse;font-size:14px;">
          <tr><td style="padding:10px 0;border-bottom:1px solid #e2e8f0;color:#0f172a;">AnbuCRM subscription — ${d.planTerm} plan</td><td style="padding:10px 0;border-bottom:1px solid #e2e8f0;text-align:right;color:#0f172a;">${inr(d.basePrice)}</td></tr>
          ${discountRow}
          <tr><td style="padding:10px 0;color:#475569;">Subtotal</td><td style="padding:10px 0;text-align:right;color:#334155;">${inr(d.subtotal)}</td></tr>
          <tr><td style="padding:10px 0;color:#475569;">GST @ 18%</td><td style="padding:10px 0;text-align:right;color:#334155;">${inr(d.tax)}</td></tr>
          <tr><td style="padding:14px 0;border-top:2px solid #0f172a;font-size:16px;font-weight:bold;color:#0f172a;">Amount Paid</td><td style="padding:14px 0;border-top:2px solid #0f172a;text-align:right;font-size:16px;font-weight:bold;color:#4f46e5;">${inr(d.totalAmount)}</td></tr>
        </table>
        <table style="width:100%;border-collapse:collapse;font-size:13px;margin-top:24px;background:#f8fafc;border-radius:8px;">
          <tr><td style="padding:12px 20px;color:#64748b;">Billing period</td><td style="padding:12px 20px;text-align:right;color:#334155;">${d.periodStart} → ${d.periodEnd}</td></tr>
          <tr><td style="padding:0 20px 12px;color:#64748b;">Status</td><td style="padding:0 20px 12px;text-align:right;color:#059669;font-weight:bold;">Active</td></tr>
        </table>
        <p style="margin:28px 0 0;font-size:12px;color:#94a3b8;line-height:1.6;">This is an automated invoice from AnbuCRM. If you did not create this account, please ignore this email.</p>
      </div>
    </div>
  </div>
</div>`;
}

function invoiceText(d) {
  const lines = [
    `Hi ${d.name},`, '',
    'Thank you for subscribing to AnbuCRM. Your plan is now active.', '',
    `Plan: ${d.planTerm}`, `Base price: ${inr(d.basePrice)}`,
  ];
  if (d.discountPercent > 0) {
    lines.push(`Discount: -${inr(d.basePrice - d.subtotal)} (${d.discountPercent}% off${d.couponCode ? ', code ' + d.couponCode : ''})`);
  }
  lines.push(`Subtotal: ${inr(d.subtotal)}`, `GST @ 18%: ${inr(d.tax)}`, `Amount paid: ${inr(d.totalAmount)}`, `Billing period: ${d.periodStart} to ${d.periodEnd}`, '', 'This is an automated invoice from AnbuCRM.');
  return lines.join('\n');
}

router.post('/invoice', requireAuth, async (req, res, next) => {
  try {
    const cfg = mailerConfig();
    if (!cfg) {
      return res.status(503).json({ error: 'Email service not configured. Add GMAIL_USER and GMAIL_APP_PASSWORD to the server .env.' });
    }

    const b = req.body || {};
    const planTerm = PLAN_TERMS.includes(b.planTerm) ? b.planTerm : 'Monthly';
    const discountPercent = Math.min(Math.max(Number(b.discountPercent) || 0, 0), 100);
    const couponCode = String(b.couponCode || '').trim();

    const subtotal = BASE_PRICE * (1 - discountPercent / 100);
    const tax = subtotal * GST_RATE;
    const totalAmount = subtotal + tax;

    const to = String(b.email || req.user.email || '').trim();
    if (!to) {
      return res.status(400).json({ error: 'No recipient email available' });
    }

    const d = {
      name: String(b.name || '').trim() || 'Customer',
      email: to,
      phone: String(b.phone || '').trim(),
      planTerm,
      basePrice: BASE_PRICE,
      discountPercent,
      couponCode,
      subtotal,
      tax,
      totalAmount,
      periodStart: fmtDate(new Date()),
      periodEnd: fmtDate(nextPeriodEnd(new Date(), planTerm)),
    };

    // Generate PDF
    const pdfBuffer = await generateInvoicePdf(d);

    await cfg.transporter.sendMail({
      from: `"AnbuCRM" <${cfg.user}>`,
      to,
      subject: `Welcome to AnbuCRM! Your invoice — ${planTerm} plan`,
      html: invoiceHtml(d),
      text: invoiceText(d),
      attachments: [{
        filename: `AnbuCRM-Invoice-${Date.now()}.pdf`,
        content: pdfBuffer,
        contentType: 'application/pdf',
      }],
    });

    res.json({ sent: true, to, totalAmount });
  } catch (e) {
    next(e);
  }
});

module.exports = router;
