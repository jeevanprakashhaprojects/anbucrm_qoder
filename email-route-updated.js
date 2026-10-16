const express = require('express');
const { requireAuth } = require('../middleware/auth');
const PDFDocument = require('pdfkit');
const path = require('path');
const fs = require('fs');

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

function inrPdf(n) {
  return 'Rs. ' + Number(n).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function inrHtml(n) {
  return '\u20B9' + Number(n).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function fmtDate(d) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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

    // HEADER - Royal Navy with Gold accent bar
    doc.rect(0, 0, pageWidth, 135).fill('#09152b');
    doc.rect(0, 132, pageWidth, 3).fill('#f59e0b');

    // Logo
    const logoPath = path.join(__dirname, 'logo.jpg');
    if (fs.existsSync(logoPath)) {
      doc.save();
      doc.roundedRect(45, 32, 50, 50, 10).clip();
      doc.image(logoPath, 45, 32, { width: 50, height: 50 });
      doc.restore();
      doc.roundedRect(45, 32, 50, 50, 10).stroke('#f59e0b');
    } else {
      doc.roundedRect(45, 32, 50, 50, 10).fill('#0f2347').stroke('#f59e0b');
      doc.fillColor('#fbbf24').fontSize(28).font('Helvetica-Bold').text('A', 45, 42, { width: 50, align: 'center' });
    }

    // Company info
    doc.fillColor('#ffffff').fontSize(24).font('Helvetica-Bold').text('AnbuCRM', 110, 36);
    doc.fontSize(10).font('Helvetica').fillColor('#fbbf24').text('Cloud CRM & Insurance Automation Suite', 110, 64);
    doc.fontSize(8.5).fillColor('#94a3b8').text('GSTIN: 33AAACA9812K1Z8 \u00B7 SAC: 998313 \u00B7 billing@anbucrm.com', 110, 80);

    // Invoice meta right side
    doc.fillColor('#fbbf24').fontSize(16).font('Helvetica-Bold').text('TAX INVOICE', pageWidth - 220, 36, { align: 'right' });
    doc.fontSize(10).font('Helvetica-Bold').fillColor('#ffffff').text(`#${d.invoiceNumber}`, pageWidth - 220, 58, { align: 'right' });
    doc.fontSize(9).font('Helvetica').fillColor('#cbd5e1').text(`Date: ${d.periodStart}`, pageWidth - 220, 74, { align: 'right' });
    doc.text(`Due Date: ${d.periodStart}`, pageWidth - 220, 88, { align: 'right' });

    // BILLED TO & SUBSCRIPTION CARDS
    const cardY = 160;
    const cardHeight = 95;
    const cardWidth = 240;

    doc.roundedRect(45, cardY, cardWidth, cardHeight, 8).fill('#f8fafc').stroke('#e2e8f0');
    doc.fillColor('#64748b').fontSize(8.5).font('Helvetica-Bold').text('BILLED TO CUSTOMER', 60, cardY + 12);
    doc.fillColor('#0f172a').fontSize(13).font('Helvetica-Bold').text(d.name, 60, cardY + 28);
    doc.fontSize(9.5).font('Helvetica').fillColor('#334155').text(d.email, 60, cardY + 46);
    if (d.phone) doc.text(`Phone: ${d.phone}`, 60, cardY + 60);
    doc.text(d.country || 'Tamil Nadu, India', 60, cardY + 74);

    const rightCardX = pageWidth - 45 - cardWidth;
    doc.roundedRect(rightCardX, cardY, cardWidth, cardHeight, 8).fill('#f8fafc').stroke('#e2e8f0');
    doc.fillColor('#64748b').fontSize(8.5).font('Helvetica-Bold').text('SUBSCRIPTION SPECIFICS', rightCardX + 15, cardY + 12);
    doc.fillColor('#0f172a').fontSize(11).font('Helvetica-Bold').text(`Plan: ${d.planTerm} Plan`, rightCardX + 15, cardY + 28);
    doc.fontSize(9.5).font('Helvetica').fillColor('#334155').text(`Coverage: ${d.periodStart} to ${d.periodEnd}`, rightCardX + 15, cardY + 46);
    doc.roundedRect(rightCardX + 15, cardY + 64, 75, 18, 4).fill('#dcfce7').stroke('#86efac');
    doc.fillColor('#15803d').fontSize(8.5).font('Helvetica-Bold').text('PAID IN FULL', rightCardX + 15, cardY + 68, { width: 75, align: 'center' });

    // ITEMS TABLE
    let tableY = 280;
    doc.roundedRect(45, tableY, pageWidth - 90, 28, 4).fill('#09152b');
    doc.fillColor('#fbbf24').fontSize(9.5).font('Helvetica-Bold');
    doc.text('DESCRIPTION & SERVICE', 60, tableY + 9);
    doc.text('SAC CODE', 290, tableY + 9);
    doc.text('QTY', 365, tableY + 9);
    doc.text('RATE', 420, tableY + 9);
    doc.text('AMOUNT', pageWidth - 140, tableY + 9, { align: 'right' });

    tableY += 38;
    doc.fillColor('#0f172a').fontSize(9.5).font('Helvetica-Bold');
    doc.text(`AnbuCRM Subscription - ${d.planTerm} Plan`, 60, tableY);
    doc.fillColor('#64748b').fontSize(8).font('Helvetica').text('Cloud CRM Access, Leads Pipeline, Automated Follow-ups & Analytics', 60, tableY + 14);
    doc.fillColor('#475569').fontSize(9).font('Helvetica');
    doc.text('998313', 290, tableY);
    doc.text('1', 365, tableY);
    doc.text(inrPdf(d.basePrice), 420, tableY);
    doc.fillColor('#0f172a').font('Helvetica-Bold').text(inrPdf(d.basePrice), pageWidth - 140, tableY, { align: 'right' });

    tableY += 34;

    if (d.discountPercent > 0) {
      doc.fillColor('#059669').fontSize(9).font('Helvetica-Bold');
      doc.text(`Promotional Discount (${d.discountPercent}% off${d.couponCode ? ' - ' + d.couponCode : ''})`, 60, tableY);
      doc.text('-', 290, tableY);
      doc.text('-', 365, tableY);
      doc.text('-', 420, tableY);
      doc.text('-' + inrPdf(d.basePrice - d.subtotal), pageWidth - 140, tableY, { align: 'right' });
      tableY += 26;
    }

    doc.rect(45, tableY, pageWidth - 90, 1).fill('#e2e8f0');
    tableY += 15;

    // SUMMARY & TOTALS
    doc.fillColor('#64748b').fontSize(8.5).font('Helvetica-Bold').text('PAYMENT SETTLEMENT & NOTES', 45, tableY);
    doc.font('Helvetica').fontSize(8).fillColor('#475569');
    doc.text('Payment Mode: Online / Verified Promo Code', 45, tableY + 14);
    doc.text(`Transaction Reference: TXN-${d.invoiceNumber.replace('INV-', '')}`, 45, tableY + 26);
    doc.text('This invoice is generated in compliance with GST Rule 46.', 45, tableY + 38);

    const totalsX = 350;
    const totalsWidth = pageWidth - 45 - totalsX;

    doc.fontSize(9).font('Helvetica').fillColor('#475569');
    doc.text('Subtotal:', totalsX, tableY);
    doc.text(inrPdf(d.subtotal), pageWidth - 140, tableY, { align: 'right' });
    doc.text('CGST (9%):', totalsX, tableY + 16);
    doc.text(inrPdf(d.tax / 2), pageWidth - 140, tableY + 16, { align: 'right' });
    doc.text('SGST (9%):', totalsX, tableY + 32);
    doc.text(inrPdf(d.tax / 2), pageWidth - 140, tableY + 32, { align: 'right' });

    const totalBoxY = tableY + 54;
    doc.roundedRect(totalsX - 10, totalBoxY, totalsWidth + 10, 42, 6).fill('#09152b');
    doc.fillColor('#ffffff').fontSize(9).font('Helvetica-Bold').text('TOTAL PAID', totalsX, totalBoxY + 15);
    doc.fillColor('#fbbf24').fontSize(14).font('Helvetica-Bold').text(inrPdf(d.totalAmount), pageWidth - 140, totalBoxY + 13, { align: 'right' });

    // FOOTER & SIGNATORY
    const footerY = pageHeight - 110;
    doc.rect(45, footerY, pageWidth - 90, 1).fill('#e2e8f0');

    doc.fillColor('#64748b').fontSize(8).font('Helvetica');
    doc.text('Thank you for subscribing to AnbuCRM! Access your dashboard at https://anbucrm.com', 45, footerY + 15, { width: 320 });
    doc.text('Support: support@anbucrm.com | Master Service Agreement applies', 45, footerY + 38);

    const sigX = pageWidth - 190;
    doc.fillColor('#0f172a').fontSize(8.5).font('Helvetica-Bold').text('Authorized Signatory', sigX, footerY + 38, { width: 145, align: 'center' });
    doc.fillColor('#f59e0b').fontSize(8).font('Helvetica-Bold').text('AnbuCRM Technologies Pvt Ltd', sigX, footerY + 50, { width: 145, align: 'center' });

    doc.fillColor('#94a3b8').fontSize(7.5).font('Helvetica').text('\u00A9 2026 AnbuCRM. All rights reserved. GST Rule 46 Compliant.', 45, pageHeight - 24, { align: 'center', width: pageWidth - 90 });

    doc.end();
  });
}

function invoiceHtml(d) {
  const discountRow = d.discountPercent > 0
    ? `<tr><td style="padding:12px 16px;color:#059669;font-weight:600;border-bottom:1px solid #f1f5f9;">Discount (${d.discountPercent}% off${d.couponCode ? ' \u00B7 ' + d.couponCode : ''})</td><td style="padding:12px 16px;text-align:right;color:#059669;font-weight:700;border-bottom:1px solid #f1f5f9;">-${inrHtml(d.basePrice - d.subtotal)}</td></tr>`
    : '';

  return `<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Your AnbuCRM Invoice</title></head>
<body style="margin:0;padding:0;background-color:#f1f5f9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;">
<div style="max-width:620px;margin:0 auto;padding:32px 16px;">
<div style="background-color:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 10px 25px -5px rgba(0,0,0,0.08);border:1px solid #e2e8f0;">

<div style="background-color:#09152b;padding:36px 32px;border-bottom:3px solid #f59e0b;">
<table style="width:100%;border-collapse:collapse;"><tr>
<td style="vertical-align:middle;">
<table style="border-collapse:collapse;"><tr>
<td style="width:46px;height:46px;background-color:#0f2347;border:2px solid #f59e0b;border-radius:10px;text-align:center;vertical-align:middle;overflow:hidden;">
<img src="cid:logo_inline" alt="AnbuCRM" style="width:42px;height:42px;object-fit:cover;display:block;border-radius:8px;" />
</td>
<td style="padding-left:14px;">
<div style="color:#ffffff;font-size:24px;font-weight:800;letter-spacing:-0.5px;">AnbuCRM</div>
<div style="color:#fbbf24;font-size:12px;font-weight:500;margin-top:2px;">Cloud CRM &amp; Insurance Suite</div>
</td></tr></table>
</td>
<td style="vertical-align:middle;text-align:right;">
<div style="display:inline-block;padding:4px 10px;background-color:rgba(251,191,36,0.15);border:1px solid rgba(251,191,36,0.4);border-radius:6px;color:#fbbf24;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.5px;">TAX INVOICE</div>
<div style="color:#ffffff;font-size:15px;font-weight:700;margin-top:6px;font-family:monospace;">#${d.invoiceNumber}</div>
<div style="color:#94a3b8;font-size:11px;margin-top:2px;">Date: ${d.periodStart}</div>
</td>
</tr></table>
</div>

<div style="padding:32px;">
<h2 style="margin:0 0 8px;font-size:18px;color:#0f172a;font-weight:700;">Hi ${d.name},</h2>
<p style="margin:0 0 24px;font-size:14px;color:#475569;line-height:1.6;">Thank you for choosing <strong>AnbuCRM</strong>. Your subscription has been activated successfully. Your official tax invoice PDF is attached to this email.</p>

<table style="width:100%;border-collapse:collapse;margin-bottom:28px;"><tr>
<td style="width:50%;vertical-align:top;padding-right:8px;">
<div style="background-color:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
<div style="font-size:10px;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:0.5px;margin-bottom:6px;">Billed To</div>
<div style="font-size:14px;font-weight:700;color:#0f172a;">${d.name}</div>
<div style="font-size:12px;color:#475569;margin-top:3px;">${d.email}</div>
${d.phone ? `<div style="font-size:12px;color:#475569;margin-top:2px;">${d.phone}</div>` : ''}
<div style="font-size:12px;color:#64748b;margin-top:2px;">${d.country || 'Tamil Nadu, India'}</div>
</div></td>
<td style="width:50%;vertical-align:top;padding-left:8px;">
<div style="background-color:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
<div style="font-size:10px;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:0.5px;margin-bottom:6px;">Plan Details</div>
<div style="font-size:14px;font-weight:700;color:#0f172a;">${d.planTerm} Plan</div>
<div style="font-size:12px;color:#475569;margin-top:3px;">${d.periodStart} &rarr; ${d.periodEnd}</div>
<div style="margin-top:6px;"><span style="display:inline-block;padding:2px 8px;background-color:#dcfce7;border:1px solid #86efac;border-radius:4px;color:#15803d;font-size:10px;font-weight:700;">PAID &amp; ACTIVE</span></div>
</div></td>
</tr></table>

<table style="width:100%;border-collapse:collapse;font-size:13px;margin-bottom:24px;">
<thead><tr style="background-color:#09152b;color:#fbbf24;">
<th style="padding:12px 16px;text-align:left;font-weight:700;border-top-left-radius:8px;">Description</th>
<th style="padding:12px 16px;text-align:right;font-weight:700;border-top-right-radius:8px;">Amount</th>
</tr></thead>
<tbody>
<tr><td style="padding:14px 16px;color:#0f172a;border-bottom:1px solid #f1f5f9;"><strong>AnbuCRM subscription &mdash; ${d.planTerm} plan</strong><div style="font-size:11px;color:#64748b;margin-top:2px;">SAC Code: 998313 (IT Software &amp; Cloud CRM Services)</div></td>
<td style="padding:14px 16px;text-align:right;color:#0f172a;font-weight:600;border-bottom:1px solid #f1f5f9;font-family:monospace;">${inrHtml(d.basePrice)}</td></tr>
${discountRow}
<tr><td style="padding:10px 16px;color:#64748b;border-bottom:1px solid #f1f5f9;">Subtotal</td><td style="padding:10px 16px;text-align:right;color:#334155;border-bottom:1px solid #f1f5f9;font-family:monospace;">${inrHtml(d.subtotal)}</td></tr>
<tr><td style="padding:10px 16px;color:#64748b;border-bottom:1px solid #f1f5f9;">GST @ 18% (CGST 9% + SGST 9%)</td><td style="padding:10px 16px;text-align:right;color:#334155;border-bottom:1px solid #f1f5f9;font-family:monospace;">${inrHtml(d.tax)}</td></tr>
<tr style="background-color:#09152b;color:#ffffff;">
<td style="padding:16px;font-size:14px;font-weight:700;border-bottom-left-radius:8px;">TOTAL AMOUNT PAID</td>
<td style="padding:16px;text-align:right;font-size:18px;font-weight:800;color:#fbbf24;border-bottom-right-radius:8px;font-family:monospace;">${inrHtml(d.totalAmount)}</td>
</tr>
</tbody></table>

<div style="margin-top:28px;padding:20px;background:linear-gradient(135deg,#f0fdf4 0%,#ecfdf5 100%);border-radius:12px;border:1px solid #a7f3d0;">
<div style="font-size:14px;color:#065f46;font-weight:700;margin-bottom:6px;">Welcome to AnbuCRM Suite!</div>
<div style="font-size:13px;color:#047857;line-height:1.5;">Your account is ready. Log in to your CRM dashboard to manage client portfolios, automate follow-up workflows, and accelerate growth.</div>
<div style="margin-top:14px;"><a href="https://anbucrm.com" style="display:inline-block;padding:10px 20px;background-color:#09152b;color:#fbbf24;text-decoration:none;border-radius:8px;font-size:12px;font-weight:700;letter-spacing:0.3px;">Launch AnbuCRM Dashboard &rarr;</a></div>
</div>

<div style="margin-top:28px;padding-top:20px;border-top:1px solid #e2e8f0;font-size:12px;color:#94a3b8;line-height:1.6;text-align:center;">
This is an official computer-generated invoice issued by AnbuCRM Technologies Pvt. Ltd.<br>
Need assistance? Contact <a href="mailto:support@anbucrm.com" style="color:#f59e0b;text-decoration:none;font-weight:600;">support@anbucrm.com</a>
</div>
</div></div>
<div style="text-align:center;padding:16px;font-size:11px;color:#94a3b8;">&copy; 2026 AnbuCRM. All rights reserved. GST Rule 46 Compliant.</div>
</div></body></html>`;
}

function invoiceText(d) {
  const lines = [
    `Hi ${d.name},`, '',
    'Thank you for subscribing to AnbuCRM. Your plan is now active.', '',
    `Plan: ${d.planTerm}`, `Base Price: ${inrHtml(d.basePrice)}`,
  ];
  if (d.discountPercent > 0) {
    lines.push(`Discount: -${inrHtml(d.basePrice - d.subtotal)} (${d.discountPercent}% off${d.couponCode ? ', code ' + d.couponCode : ''})`);
  }
  lines.push(`Subtotal: ${inrHtml(d.subtotal)}`, `GST @ 18%: ${inrHtml(d.tax)}`, `Total Amount Paid: ${inrHtml(d.totalAmount)}`, `Billing Period: ${d.periodStart} to ${d.periodEnd}`, '', 'Your official PDF invoice is attached with this email.', 'Thank you for choosing AnbuCRM!');
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

    const invoiceNum = 'INV-' + Date.now().toString().slice(-8);

    const d = {
      name: String(b.name || '').trim() || 'Customer',
      email: to,
      phone: String(b.phone || '').trim(),
      country: String(b.country || 'Tamil Nadu, India').trim(),
      planTerm,
      basePrice: BASE_PRICE,
      discountPercent,
      couponCode,
      subtotal,
      tax,
      totalAmount,
      invoiceNumber: invoiceNum,
      periodStart: fmtDate(new Date()),
      periodEnd: fmtDate(nextPeriodEnd(new Date(), planTerm)),
    };

    const pdfBuffer = await generateInvoicePdf(d);

    const logoPath = path.join(__dirname, 'logo.jpg');
    const attachments = [
      { filename: `AnbuCRM-Invoice-${invoiceNum}.pdf`, content: pdfBuffer, contentType: 'application/pdf' },
    ];
    if (fs.existsSync(logoPath)) {
      attachments.push({ filename: 'logo.jpg', path: logoPath, cid: 'logo_inline' });
    }

    await cfg.transporter.sendMail({
      from: `"AnbuCRM Billing" <${cfg.user}>`,
      to,
      subject: `Welcome to AnbuCRM! Your Invoice #${invoiceNum} \u2014 ${planTerm} Plan`,
      html: invoiceHtml(d),
      text: invoiceText(d),
      attachments,
      headers: {
        'X-Mailer': 'AnbuCRM',
        'List-Unsubscribe': '<mailto:support@anbucrm.com>',
      },
    });

    res.json({ sent: true, to, invoiceNumber: invoiceNum, totalAmount });
  } catch (e) {
    next(e);
  }
});

module.exports = router;
