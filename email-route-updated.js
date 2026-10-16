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
    const doc = new PDFDocument({ margin: 0, size: 'A4' });
    const chunks = [];
    doc.on('data', chunk => chunks.push(chunk));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    const pageWidth = doc.page.width;
    const pageHeight = doc.page.height;

    // Header with gradient background
    doc.rect(0, 0, pageWidth, 140).fill('#4f46e5');
    
    // Logo area (text-based logo)
    doc.fillColor('white').fontSize(32).font('Helvetica-Bold').text('AnbuCRM', 50, 35);
    doc.fontSize(11).font('Helvetica').text('Customer Relationship Management', 50, 72);
    
    // Invoice title on right
    doc.fontSize(24).font('Helvetica-Bold').text('INVOICE', pageWidth - 200, 40, { align: 'right' });
    doc.fontSize(10).font('Helvetica').text(`#${Date.now().toString().slice(-8)}`, pageWidth - 200, 68, { align: 'right' });
    doc.text(`Date: ${fmtDate(new Date())}`, pageWidth - 200, 86, { align: 'right' });

    // Bill To section
    doc.fillColor('#0f172a').fontSize(11).font('Helvetica-Bold').text('BILLED TO', 50, 170);
    doc.rect(50, 185, 250, 90).fill('#f8fafc').stroke('#e2e8f0');
    doc.fillColor('#0f172a').fontSize(14).font('Helvetica-Bold').text(d.name, 65, 195);
    doc.fontSize(10).font('Helvetica').fillColor('#475569').text(d.email, 65, 215);
    if (d.phone) doc.text(d.phone, 65, 232);
    doc.text(d.country || 'India', 65, 249);

    // Payment Details section
    doc.fillColor('#0f172a').fontSize(11).font('Helvetica-Bold').text('PAYMENT DETAILS', 340, 170);
    doc.rect(340, 185, 210, 90).fill('#f8fafc').stroke('#e2e8f0');
    doc.fontSize(10).font('Helvetica').fillColor('#475569');
    doc.text(`Plan: ${d.planTerm}`, 355, 195);
    doc.text(`Period: ${d.periodStart}`, 355, 212);
    doc.text(`To: ${d.periodEnd}`, 355, 229);
    doc.fillColor('#059669').font('Helvetica-Bold').text('Status: Active', 355, 249);

    // Items table header
    let y = 310;
    doc.rect(50, y, pageWidth - 100, 35).fill('#4f46e5');
    doc.fillColor('white').fontSize(10).font('Helvetica-Bold');
    doc.text('Description', 65, y + 12);
    doc.text('Qty', 320, y + 12);
    doc.text('Rate', 400, y + 12);
    doc.text('Amount', pageWidth - 130, y + 12, { align: 'right' });

    // Items
    y += 45;
    doc.fillColor('#0f172a').fontSize(10).font('Helvetica');
    doc.text(`AnbuCRM ${d.planTerm} Subscription`, 65, y);
    doc.text('1', 320, y);
    doc.text(inr(d.basePrice), 400, y);
    doc.text(inr(d.basePrice), pageWidth - 130, y, { align: 'right' });
    y += 25;

    if (d.discountPercent > 0) {
      doc.fillColor('#059669');
      doc.text(`Discount (${d.discountPercent}% off${d.couponCode ? ' - ' + d.couponCode : ''})`, 65, y);
      doc.text('-', 320, y);
      doc.text('-', 400, y);
      doc.text('-' + inr(d.basePrice - d.subtotal), pageWidth - 130, y, { align: 'right' });
      y += 25;
    }

    // Divider
    doc.rect(50, y, pageWidth - 100, 1).fill('#e2e8f0');
    y += 15;

    // Subtotal
    doc.fillColor('#475569').font('Helvetica');
    doc.text('Subtotal', 65, y);
    doc.text(inr(d.subtotal), pageWidth - 130, y, { align: 'right' });
    y += 22;

    // GST
    doc.text('GST @ 18%', 65, y);
    doc.text(inr(d.tax), pageWidth - 130, y, { align: 'right' });
    y += 10;

    // Total divider
    doc.rect(50, y, pageWidth - 100, 2).fill('#4f46e5');
    y += 15;

    // Total
    doc.fillColor('#0f172a').fontSize(14).font('Helvetica-Bold');
    doc.text('TOTAL PAID', 65, y);
    doc.fillColor('#4f46e5').text(inr(d.totalAmount), pageWidth - 130, y, { align: 'right' });

    // Footer with thank you message
    y = pageHeight - 120;
    doc.rect(50, y, pageWidth - 100, 80).fill('#f8fafc').stroke('#e2e8f0');
    doc.fillColor('#4f46e5').fontSize(14).font('Helvetica-Bold').text('Thank you for choosing AnbuCRM!', 70, y + 15);
    doc.fillColor('#64748b').fontSize(9).font('Helvetica');
    doc.text('Your account is now active. Access your dashboard to start managing leads and growing your business.', 70, y + 35);
    doc.text('For support: support@anbucrm.com | https://anbucrm.com', 70, y + 52);

    // Bottom branding
    doc.fillColor('#94a3b8').fontSize(8).text('© 2026 AnbuCRM. All rights reserved.', 50, pageHeight - 30, { align: 'center' });

    doc.end();
  });
}

function invoiceHtml(d) {
  const discountRow = d.discountPercent > 0
    ? `<tr><td style="padding:12px 16px;color:#475569;border-bottom:1px solid #f1f5f9;">Discount (${d.discountPercent}% off${d.couponCode ? ' · ' + d.couponCode : ''})</td><td style="padding:12px 16px;text-align:right;color:#059669;font-weight:600;border-bottom:1px solid #f1f5f9;">-${inr(d.basePrice - d.subtotal)}</td></tr>`
    : '';
  return `<!DOCTYPE html><html><head><meta charset="utf-8"></head><body style="margin:0;padding:0;background:#f1f5f9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
  <div style="max-width:600px;margin:0 auto;padding:24px 16px;">
    <div style="background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);">
      <div style="background:linear-gradient(135deg,#4f46e5 0%,#7c3aed 100%);padding:32px;">
        <div style="color:#ffffff;font-size:28px;font-weight:800;letter-spacing:-0.5px;">AnbuCRM</div>
        <div style="color:rgba(255,255,255,0.85);font-size:13px;margin-top:4px;">Customer Relationship Management</div>
        <div style="margin-top:20px;padding-top:20px;border-top:1px solid rgba(255,255,255,0.2);">
          <div style="color:#ffffff;font-size:20px;font-weight:700;">INVOICE</div>
          <div style="color:rgba(255,255,255,0.8);font-size:12px;margin-top:4px;">#${Date.now().toString().slice(-8)} · ${fmtDate(new Date())}</div>
        </div>
      </div>
      <div style="padding:32px;">
        <p style="margin:0 0 20px;font-size:15px;color:#0f172a;font-weight:600;">Hi ${d.name},</p>
        <p style="margin:0 0 28px;font-size:14px;color:#475569;line-height:1.6;">Thank you for subscribing to AnbuCRM. Your account is now active and ready to help you grow your business. Here's your invoice.</p>
        
        <div style="display:flex;gap:16px;margin-bottom:28px;">
          <div style="flex:1;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:16px;">
            <div style="font-size:11px;color:#64748b;text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;font-weight:600;">Billed To</div>
            <div style="font-size:15px;color:#0f172a;font-weight:700;">${d.name}</div>
            <div style="font-size:13px;color:#475569;margin-top:4px;">${d.email}</div>
            ${d.phone ? `<div style="font-size:13px;color:#475569;">${d.phone}</div>` : ''}
            ${d.country ? `<div style="font-size:13px;color:#475569;">${d.country}</div>` : ''}
          </div>
          <div style="flex:1;background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:16px;">
            <div style="font-size:11px;color:#64748b;text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;font-weight:600;">Plan Details</div>
            <div style="font-size:14px;color:#0f172a;font-weight:600;">${d.planTerm} Plan</div>
            <div style="font-size:13px;color:#475569;margin-top:4px;">${d.periodStart} → ${d.periodEnd}</div>
            <div style="margin-top:8px;display:inline-block;padding:4px 10px;background:#d1fae5;color:#059669;border-radius:6px;font-size:11px;font-weight:600;">ACTIVE</div>
          </div>
        </div>

        <table style="width:100%;border-collapse:collapse;font-size:14px;">
          <tr style="background:#4f46e5;color:white;">
            <th style="padding:12px 16px;text-align:left;font-weight:600;">Description</th>
            <th style="padding:12px 16px;text-align:right;font-weight:600;">Amount</th>
          </tr>
          <tr>
            <td style="padding:14px 16px;color:#0f172a;border-bottom:1px solid #f1f5f9;">AnbuCRM ${d.planTerm} Subscription</td>
            <td style="padding:14px 16px;text-align:right;color:#0f172a;font-weight:600;border-bottom:1px solid #f1f5f9;">${inr(d.basePrice)}</td>
          </tr>
          ${discountRow}
          <tr>
            <td style="padding:12px 16px;color:#475569;border-bottom:1px solid #f1f5f9;">Subtotal</td>
            <td style="padding:12px 16px;text-align:right;color:#334155;border-bottom:1px solid #f1f5f9;">${inr(d.subtotal)}</td>
          </tr>
          <tr>
            <td style="padding:12px 16px;color:#475569;border-bottom:1px solid #f1f5f9;">GST @ 18%</td>
            <td style="padding:12px 16px;text-align:right;color:#334155;border-bottom:1px solid #f1f5f9;">${inr(d.tax)}</td>
          </tr>
          <tr style="background:#f8fafc;">
            <td style="padding:16px;font-size:16px;font-weight:700;color:#0f172a;">TOTAL PAID</td>
            <td style="padding:16px;text-align:right;font-size:18px;font-weight:700;color:#4f46e5;">${inr(d.totalAmount)}</td>
          </tr>
        </table>

        <div style="margin-top:28px;padding:20px;background:linear-gradient(135deg,#f0f9ff 0%,#e0f2fe 100%);border-radius:12px;border:1px solid #bae6fd;">
          <div style="font-size:14px;color:#0369a1;font-weight:600;margin-bottom:6px;">🎉 Welcome to AnbuCRM!</div>
          <div style="font-size:13px;color:#0c4a6e;line-height:1.5;">Your account is active. Start managing leads, tracking calls, and growing your business today.</div>
        </div>

        <p style="margin:24px 0 0;font-size:12px;color:#94a3b8;line-height:1.6;text-align:center;">
          This is an automated invoice from AnbuCRM.<br/>
          Need help? Contact <a href="mailto:support@anbucrm.com" style="color:#4f46e5;text-decoration:none;">support@anbucrm.com</a>
        </p>
      </div>
    </div>
    <div style="text-align:center;padding:16px;font-size:11px;color:#94a3b8;">© 2026 AnbuCRM. All rights reserved.</div>
  </div>
</body></html>`;
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
      country: String(b.country || 'India').trim(),
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
      from: `"AnbuCRM Billing" <billing@anbucrm.com>`,
      to,
      subject: `Welcome to AnbuCRM! Your invoice — ${planTerm} plan`,
      html: invoiceHtml(d),
      text: invoiceText(d),
      attachments: [{
        filename: `AnbuCRM-Invoice-${Date.now()}.pdf`,
        content: pdfBuffer,
        contentType: 'application/pdf',
      }],
      headers: {
        'X-Mailer': 'AnbuCRM',
        'List-Unsubscribe': '<mailto:unsubscribe@anbucrm.com>',
      },
    });

    res.json({ sent: true, to, totalAmount });
  } catch (e) {
    next(e);
  }
});

module.exports = router;
