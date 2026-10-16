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

const LOGO_PATH = path.join(__dirname, '..', 'assets', 'anbucrm_logo.png');
const FONT_REGULAR = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf';
const FONT_BOLD = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf';
const HAS_RUPEE_FONT = fs.existsSync(FONT_REGULAR) && fs.existsSync(FONT_BOLD);

const C = {
  navy: '#09152b',
  navy2: '#0e2140',
  amber: '#fbbf24',
  amber3: '#fcd34d',
  s900: '#0f172a',
  s800: '#1e293b',
  s700: '#334155',
  s600: '#475569',
  s500: '#64748b',
  s400: '#94a3b8',
  s300: '#cbd5e1',
  s200: '#e2e8f0',
  s100: '#f1f5f9',
  s50: '#f8fafc',
  e50: '#ecfdf5',
  e200: '#a7f3d0',
  e300: '#6ee7b7',
  e600: '#059669',
  e700: '#047857',
  e800: '#065f46',
};

function amount(n) {
  return Number(n).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function inrPdf(n) {
  return (HAS_RUPEE_FONT ? '\u20B9' : 'Rs. ') + amount(n);
}

function inrHtml(n) {
  return '\u20B9' + amount(n);
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
    const doc = new PDFDocument({ margin: 0, size: 'A4', info: { Title: `AnbuCRM Invoice ${d.invoiceNumber}`, Author: 'AnbuCRM' } });
    const chunks = [];
    doc.on('data', chunk => chunks.push(chunk));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    if (HAS_RUPEE_FONT) {
      doc.registerFont('Money', FONT_REGULAR);
      doc.registerFont('MoneyBold', FONT_BOLD);
    }
    const MONEY = HAS_RUPEE_FONT ? 'Money' : 'Helvetica';
    const MONEY_BOLD = HAS_RUPEE_FONT ? 'MoneyBold' : 'Helvetica-Bold';

    const pw = doc.page.width;
    const ph = doc.page.height;
    const M = 40;
    const W = pw - M * 2;
    const R = pw - M;

    // Single-line text clipped to its box so long values never spill past the margins.
    const put = (str, x, y, o = {}) => {
      const size = o.size || 9;
      doc.font(o.font || 'Helvetica').fontSize(size).fillColor(o.color || C.s700).fillOpacity(o.opacity == null ? 1 : o.opacity);
      doc.text(String(str), x, y, {
        width: o.width,
        align: o.align || 'left',
        height: o.multi ? undefined : size * 1.35,
        ellipsis: !o.multi,
        lineGap: o.lineGap || 0,
        characterSpacing: o.spacing || 0,
      });
      doc.fillOpacity(1);
    };
    const label = (str, x, y, width, color = C.s500, align = 'left') => put(str.toUpperCase(), x, y, { width, align, size: 7.5, font: 'Helvetica-Bold', color, spacing: 0.6 });
    const hline = (x, y, w, color = C.s200, h = 0.75) => doc.rect(x, y, w, h).fill(color);

    // ---------- HEADER ----------
    const headerH = 150;
    doc.rect(0, 0, pw, headerH).fill(C.navy);
    doc.save();
    doc.rect(0, 0, pw, headerH).clip();
    doc.circle(pw - 30, 0, 150).fillOpacity(0.05).fill('#ffffff');
    doc.restore();
    doc.fillOpacity(1);
    doc.rect(0, headerH, pw, 3).fill(C.amber);

    const logoSize = 70;
    const logoY = 40;
    if (fs.existsSync(LOGO_PATH)) {
      doc.image(LOGO_PATH, M, logoY, { width: logoSize, height: logoSize });
    } else {
      doc.roundedRect(M, logoY, logoSize, logoSize, 12).fill(C.navy2);
      put('A', M, logoY + 18, { width: logoSize, align: 'center', size: 30, font: 'Helvetica-Bold', color: C.amber });
    }
    doc.roundedRect(M, logoY, logoSize, logoSize, 12).lineWidth(1).strokeOpacity(0.4).stroke(C.amber);
    doc.strokeOpacity(1);

    const bx = M + logoSize + 16;
    const metaW = 170;
    const metaX = R - metaW;
    const brandW = metaX - bx - 12;

    put('AnbuCRM', bx, 44, { size: 24, font: 'Helvetica-Bold', color: '#ffffff', width: 150 });
    doc.font('Helvetica-Bold').fontSize(24);
    const badgeX = bx + doc.widthOfString('AnbuCRM') + 10;
    doc.font('Helvetica-Bold').fontSize(7);
    const badgeW = doc.widthOfString('TAX INVOICE') + 7 + 14;
    doc.roundedRect(badgeX, 50, badgeW, 15, 3).fillOpacity(0.1).fill('#ffffff');
    doc.roundedRect(badgeX, 50, badgeW, 15, 3).lineWidth(0.75).strokeOpacity(0.25).stroke('#ffffff');
    doc.fillOpacity(1).strokeOpacity(1);
    put('TAX INVOICE', badgeX, 54.5, { width: badgeW, align: 'center', size: 7, font: 'Helvetica-Bold', color: '#ffffff', opacity: 0.92, spacing: 0.6 });

    put('Cloud CRM & Insurance Automation Suite', bx, 77, { size: 9.5, color: C.s300, width: brandW });
    put('GSTIN: 33AAACA9812K1Z8  \u00B7  SAC: 998313', bx, 94, { size: 8, color: '#ffffff', opacity: 0.72, width: brandW });
    put('billing@anbucrm.com  \u00B7  www.anbucrm.com', bx, 106, { size: 8, color: '#ffffff', opacity: 0.72, width: brandW });

    label('Invoice Reference', metaX, 46, metaW, C.s300, 'right');
    put(d.invoiceNumber, metaX, 58, { width: metaW, align: 'right', size: 17, font: 'Helvetica-Bold', color: '#ffffff' });
    put(`Date:  ${d.periodStart}`, metaX, 84, { width: metaW, align: 'right', size: 8.5, color: '#ffffff', opacity: 0.85 });
    put(`Due Date:  ${d.periodStart}`, metaX, 98, { width: metaW, align: 'right', size: 8.5, color: '#ffffff', opacity: 0.85 });

    // ---------- BILLED TO CUSTOMER ----------
    const pad = 16;
    let y = headerH + 20;
    const billH = 94;
    doc.roundedRect(M, y, W, billH, 8).lineWidth(0.75).fillAndStroke(C.s50, C.s200);
    label('Billed To Customer', M + pad, y + 14, W - pad * 2);
    put(d.name, M + pad, y + 30, { size: 14, font: 'Helvetica-Bold', color: C.s900, width: W - pad * 2 });
    const infoRow = (k, v, ry) => {
      put(k, M + pad, ry + 1, { size: 7.5, color: C.s400, width: 52 });
      put(v, M + pad + 54, ry, { size: 9, font: 'Helvetica-Bold', color: C.s800, width: W - pad * 2 - 54 });
    };
    infoRow('Email:', d.email, y + 50);
    infoRow('Phone:', d.phone || '-', y + 64);
    infoRow('Location:', d.country || 'India', y + 78);

    // ---------- SUBSCRIPTION SPECIFICS ----------
    y += billH + 10;
    const subH = 96;
    doc.roundedRect(M, y, W, subH, 8).lineWidth(0.75).fillAndStroke(C.s50, C.s200);
    label('Subscription Specifics', M + pad, y + 14, W - pad * 2);
    const innerW = W - pad * 2;
    const specRow = (k, v, ry, last) => {
      put(k, M + pad, ry, { size: 9, color: C.s500, width: innerW / 2 });
      if (v) put(v, M + pad + innerW / 2, ry, { size: 9, font: 'Helvetica-Bold', color: C.s900, width: innerW / 2, align: 'right' });
      if (!last) hline(M + pad, ry + 15, innerW, C.s200, 0.5);
    };
    specRow('Service Plan', `${d.planTerm} Plan`, y + 31);
    specRow('Coverage Period', `${d.periodStart}  to  ${d.periodEnd}`, y + 51);
    specRow('Payment Status', '', y + 72, true);
    const pbW = 84;
    const pbX = R - pad - pbW;
    doc.roundedRect(pbX, y + 68, pbW, 17, 3).lineWidth(0.75).fillAndStroke(C.e50, C.e300);
    put('PAID IN FULL', pbX, y + 73, { width: pbW, align: 'center', size: 7.5, font: 'Helvetica-Bold', color: C.e700, spacing: 0.5 });

    // ---------- LINE ITEMS ----------
    y += subH + 18;
    const col = {
      desc: { x: M + 12, w: 240 },
      sac: { x: M + 262, w: 58 },
      qty: { x: M + 320, w: 40 },
      rate: { x: M + 360, w: 72 },
      amt: { x: M + 432, w: W - 432 - 12 },
    };
    doc.roundedRect(M, y, W, 26, 5).fill(C.navy2);
    const th = (t, c, align) => put(t, c.x, y + 9.5, { width: c.w, align, size: 7.5, font: 'Helvetica-Bold', color: C.amber3, spacing: 0.6 });
    th('DESCRIPTION & SERVICE', col.desc, 'left');
    th('SAC CODE', col.sac, 'center');
    th('QTY', col.qty, 'center');
    th('RATE', col.rate, 'right');
    th('AMOUNT', col.amt, 'right');

    y += 26 + 12;
    put(`AnbuCRM Subscription - ${d.planTerm} Plan`, col.desc.x, y, { size: 9.5, font: 'Helvetica-Bold', color: C.s900, width: col.desc.w });
    put('Cloud CRM Access, Leads Pipeline, Automated Follow-ups & Analytics', col.desc.x, y + 15, { size: 7.8, color: C.s500, width: col.desc.w, multi: true, lineGap: 1.5 });
    put('998313', col.sac.x, y + 1, { size: 8.5, color: C.s500, width: col.sac.w, align: 'center' });
    put('1', col.qty.x, y + 1, { size: 9, color: C.s700, width: col.qty.w, align: 'center' });
    put(inrPdf(d.basePrice), col.rate.x, y, { size: 9, font: MONEY, color: C.s700, width: col.rate.w, align: 'right' });
    put(inrPdf(d.basePrice), col.amt.x, y, { size: 9, font: MONEY_BOLD, color: C.s900, width: col.amt.w, align: 'right' });
    y += 40;

    if (d.discountPercent > 0) {
      hline(M, y - 8, W, C.s100);
      const disc = `Promotional Discount (${d.discountPercent}% off${d.couponCode ? ' - ' + d.couponCode : ''})`;
      put(disc, col.desc.x, y, { size: 9, font: 'Helvetica-Bold', color: C.e600, width: col.desc.w + col.sac.w });
      put('-', col.qty.x, y, { size: 9, color: C.e600, width: col.qty.w, align: 'center' });
      put('-' + inrPdf(d.basePrice - d.subtotal), col.amt.x, y, { size: 9, font: MONEY_BOLD, color: C.e600, width: col.amt.w, align: 'right' });
      y += 20;
    }
    hline(M, y, W, C.s900, 1);
    y += 16;

    // ---------- NOTES (left) & TOTALS (right) ----------
    const totW = 228;
    const totX = R - totW;
    const leftW = totX - M - 20;
    let ly = y;

    if (d.discountPercent > 0 && d.couponCode) {
      doc.roundedRect(M, ly, leftW, 42, 6).lineWidth(0.75).fillAndStroke(C.e50, C.e200);
      put(`Promotional Coupon Applied: ${d.couponCode}`, M + 12, ly + 9, { size: 8.5, font: 'Helvetica-Bold', color: C.e800, width: leftW - 24 });
      put(`${d.discountPercent}% promotional waiver granted for this billing cycle.`, M + 12, ly + 24, { size: 7.8, color: C.e700, width: leftW - 24 });
      ly += 54;
    }

    label('Payment Settlement & Notes', M, ly, leftW);
    ly += 13;
    doc.roundedRect(M, ly, leftW, 54, 6).lineWidth(0.75).fillAndStroke(C.s50, C.s100);
    put('Payment Mode: Online / Verified Promo Code', M + 12, ly + 9, { size: 8, color: C.s600, width: leftW - 24 });
    put(`Transaction Reference: TXN-${d.invoiceNumber.replace('INV-', '')}`, M + 12, ly + 23, { size: 8, color: C.s600, width: leftW - 24 });
    put('This invoice is generated in compliance with GST Rule 46.', M + 12, ly + 37, { size: 8, color: C.s600, width: leftW - 24 });

    const rows = [['Gross Subtotal:', inrPdf(d.basePrice), C.s600, C.s800, MONEY]];
    if (d.discountPercent > 0) {
      rows.push([`Discount (${d.discountPercent}% off):`, '-' + inrPdf(d.basePrice - d.subtotal), C.e700, C.e700, MONEY_BOLD]);
    }
    const tp = 14;
    const rowH = 16;
    const boxH = tp + rows.length * rowH + 8 + rowH * 3 + 8 + 46 + tp;
    doc.roundedRect(totX, y, totW, boxH, 8).lineWidth(0.75).fillAndStroke(C.s50, C.s200);
    const tIn = totW - tp * 2;
    let ty = y + tp;
    const trow = (k, v, kc, vc, vf, kf) => {
      put(k, totX + tp, ty, { size: 8.5, color: kc, font: kf || 'Helvetica', width: tIn * 0.58 });
      put(v, totX + tp + tIn * 0.4, ty - 0.5, { size: 8.5, color: vc, font: vf, width: tIn * 0.6, align: 'right' });
      ty += rowH;
    };
    rows.forEach(r => trow(r[0], r[1], r[2], r[3], r[4]));
    hline(totX + tp, ty - 3, tIn, C.s200, 0.75);
    ty += 5;
    trow('Taxable Value:', inrPdf(d.subtotal), C.s700, C.s900, MONEY_BOLD, 'Helvetica-Bold');
    trow('CGST @ 9%:', inrPdf(d.tax / 2), C.s500, C.s600, MONEY);
    trow('SGST @ 9%:', inrPdf(d.tax / 2), C.s500, C.s600, MONEY);
    ty += 8;
    doc.roundedRect(totX + tp, ty, tIn, 46, 6).fill(C.navy);
    label('Total Amount Paid', totX + tp + 12, ty + 11, tIn / 2, C.s300);
    put('Fully Settled', totX + tp + 12, ty + 25, { size: 8.5, color: '#ffffff', opacity: 0.9, width: tIn / 2 });
    put(inrPdf(d.totalAmount), totX + tp + tIn * 0.35, ty + 14, { size: 15, font: MONEY_BOLD, color: '#ffffff', width: tIn * 0.65 - 12, align: 'right' });

    // ---------- FOOTER ----------
    const footY = ph - 136;
    doc.rect(0, footY, pw, ph - footY).fill(C.s50);
    hline(0, footY, pw, C.s200, 0.75);

    const fLeftW = W - 200;
    label('Terms & Compliance', M, footY + 16, fLeftW);
    const terms = [
      '1. Services rendered are non-transferable.',
      '2. Invoice issued in accordance with GST Rule 46.',
      '3. Cloud services are governed by the AnbuCRM Master Service Agreement.',
    ];
    terms.forEach((t, i) => put(t, M, footY + 30 + i * 12, { size: 7.8, color: C.s500, width: fLeftW }));
    put('Thank you for subscribing to AnbuCRM! Access your dashboard at https://anbucrm.com', M, footY + 70, { size: 7.8, color: C.s600, width: fLeftW });
    put('Support: support@anbucrm.com  |  Master Service Agreement applies', M, footY + 83, { size: 7.5, color: C.s400, width: fLeftW });

    const sigW = 160;
    const sigX = R - sigW;
    hline(sigX + 10, footY + 62, sigW - 20, C.s300, 0.75);
    put('Authorized Signatory', sigX, footY + 69, { size: 8.5, font: 'Helvetica-Bold', color: C.s800, width: sigW, align: 'center' });
    put('AnbuCRM Technologies Pvt Ltd', sigX, footY + 82, { size: 7.8, color: C.s500, width: sigW, align: 'center' });

    hline(M, ph - 36, W, C.s200, 0.5);
    put('\u00A9 2026 AnbuCRM. All rights reserved.  \u00B7  GST Rule 46 Compliant', M, ph - 24, { size: 7.5, color: C.s400, width: W, align: 'center' });

    doc.end();
  });
}

function invoiceHtml(d) {
  const td = 'padding:11px 16px;border-bottom:1px solid #f1f5f9;';
  const discountRow = d.discountPercent > 0
    ? `<tr><td style="${td}color:#059669;font-weight:700;">Promotional Discount (${d.discountPercent}% off${d.couponCode ? ' &middot; ' + d.couponCode : ''})</td><td style="${td}text-align:right;white-space:nowrap;color:#059669;font-weight:700;">-${inrHtml(d.basePrice - d.subtotal)}</td></tr>`
    : '';
  const couponBox = d.discountPercent > 0 && d.couponCode
    ? `<div style="margin:0 0 20px;padding:12px 16px;background-color:#ecfdf5;border:1px solid #a7f3d0;border-radius:8px;"><div style="font-size:13px;font-weight:700;color:#065f46;">Promotional Coupon Applied: ${d.couponCode}</div><div style="font-size:12px;color:#047857;margin-top:2px;">${d.discountPercent}% promotional waiver granted for this billing cycle.</div></div>`
    : '';
  const spec = (k, v, last) => `<tr><td style="padding:8px 0;font-size:13px;color:#64748b;${last ? '' : 'border-bottom:1px solid #e2e8f0;'}">${k}</td><td style="padding:8px 0;font-size:13px;color:#0f172a;font-weight:700;text-align:right;${last ? '' : 'border-bottom:1px solid #e2e8f0;'}">${v}</td></tr>`;
  const info = (k, v) => `<tr><td style="padding:2px 0;width:70px;font-size:11px;color:#94a3b8;">${k}</td><td style="padding:2px 0;font-size:13px;color:#1e293b;font-weight:600;">${v}</td></tr>`;

  return `<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Your AnbuCRM Invoice</title></head>
<body style="margin:0;padding:0;background-color:#f1f5f9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;">
<div style="max-width:620px;margin:0 auto;padding:32px 16px;">
<div style="background-color:#ffffff;border-radius:14px;overflow:hidden;border:1px solid #e2e8f0;">

<div style="background-color:#09152b;padding:30px 28px;border-bottom:3px solid #fbbf24;">
<table style="width:100%;border-collapse:collapse;"><tr>
<td style="vertical-align:middle;">
<table style="border-collapse:collapse;"><tr>
<td style="width:60px;vertical-align:middle;"><img src="cid:logo_inline" alt="AnbuCRM" width="60" height="60" style="width:60px;height:60px;display:block;border-radius:12px;" /></td>
<td style="padding-left:14px;vertical-align:middle;">
<div><span style="color:#ffffff;font-size:24px;font-weight:800;letter-spacing:-0.5px;vertical-align:middle;">AnbuCRM</span>
<span style="display:inline-block;margin-left:6px;padding:2px 7px;border:1px solid rgba(255,255,255,0.25);background-color:rgba(255,255,255,0.1);border-radius:4px;color:#ffffff;font-size:9px;font-weight:700;letter-spacing:0.6px;vertical-align:middle;">TAX INVOICE</span></div>
<div style="color:#cbd5e1;font-size:12px;margin-top:3px;">Cloud CRM &amp; Insurance Automation Suite</div>
<div style="color:rgba(255,255,255,0.7);font-size:10px;margin-top:4px;">GSTIN: 33AAACA9812K1Z8 &middot; SAC: 998313</div>
</td></tr></table>
</td>
<td style="vertical-align:middle;text-align:right;white-space:nowrap;">
<div style="color:#cbd5e1;font-size:10px;font-weight:700;letter-spacing:0.8px;">INVOICE REFERENCE</div>
<div style="color:#ffffff;font-size:17px;font-weight:800;margin-top:3px;">${d.invoiceNumber}</div>
<div style="color:rgba(255,255,255,0.85);font-size:11px;margin-top:4px;">Date: ${d.periodStart}</div>
<div style="color:rgba(255,255,255,0.85);font-size:11px;">Due Date: ${d.periodStart}</div>
</td>
</tr></table>
</div>

<div style="padding:28px;">
<h2 style="margin:0 0 8px;font-size:18px;color:#0f172a;font-weight:700;">Hi ${d.name},</h2>
<p style="margin:0 0 22px;font-size:14px;color:#475569;line-height:1.6;">Thank you for choosing <strong>AnbuCRM</strong>. Your subscription has been activated successfully. Your official tax invoice PDF is attached to this email.</p>

<div style="background-color:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px 18px;margin-bottom:12px;">
<div style="font-size:10px;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:0.6px;margin-bottom:6px;">Billed To Customer</div>
<div style="font-size:16px;font-weight:700;color:#0f172a;margin-bottom:6px;">${d.name}</div>
<table style="border-collapse:collapse;">${info('Email:', d.email)}${info('Phone:', d.phone || '-')}${info('Location:', d.country || 'India')}</table>
</div>

<div style="background-color:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px 18px;margin-bottom:24px;">
<div style="font-size:10px;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:0.6px;margin-bottom:4px;">Subscription Specifics</div>
<table style="width:100%;border-collapse:collapse;">
${spec('Service Plan', `${d.planTerm} Plan`)}
${spec('Coverage Period', `${d.periodStart} to ${d.periodEnd}`)}
${spec('Payment Status', '<span style="display:inline-block;padding:3px 9px;background-color:#ecfdf5;border:1px solid #6ee7b7;border-radius:4px;color:#047857;font-size:10px;font-weight:700;letter-spacing:0.5px;">PAID IN FULL</span>', true)}
</table>
</div>

<table style="width:100%;border-collapse:collapse;font-size:13px;margin-bottom:22px;">
<thead><tr style="background-color:#0e2140;">
<th style="padding:11px 16px;text-align:left;font-size:11px;font-weight:700;color:#fcd34d;letter-spacing:0.5px;">DESCRIPTION &amp; SERVICE</th>
<th style="padding:11px 16px;text-align:right;font-size:11px;font-weight:700;color:#fcd34d;letter-spacing:0.5px;">AMOUNT</th>
</tr></thead>
<tbody>
<tr><td style="${td}color:#0f172a;"><strong>AnbuCRM Subscription &mdash; ${d.planTerm} Plan</strong><div style="font-size:11px;color:#64748b;margin-top:2px;">SAC 998313 &middot; Cloud CRM Access, Leads Pipeline, Automated Follow-ups &amp; Analytics</div></td>
<td style="${td}text-align:right;white-space:nowrap;color:#0f172a;font-weight:700;vertical-align:top;">${inrHtml(d.basePrice)}</td></tr>
${discountRow}
<tr><td style="${td}color:#334155;font-weight:700;">Taxable Value</td><td style="${td}text-align:right;white-space:nowrap;color:#0f172a;font-weight:700;">${inrHtml(d.subtotal)}</td></tr>
<tr><td style="${td}color:#64748b;">CGST @ 9%</td><td style="${td}text-align:right;white-space:nowrap;color:#475569;">${inrHtml(d.tax / 2)}</td></tr>
<tr><td style="${td}color:#64748b;">SGST @ 9%</td><td style="${td}text-align:right;white-space:nowrap;color:#475569;">${inrHtml(d.tax / 2)}</td></tr>
<tr style="background-color:#09152b;">
<td style="padding:14px 16px;"><div style="font-size:10px;font-weight:700;color:#cbd5e1;letter-spacing:0.6px;">TOTAL AMOUNT PAID</div><div style="font-size:12px;color:rgba(255,255,255,0.9);">Fully Settled</div></td>
<td style="padding:14px 16px;text-align:right;white-space:nowrap;font-size:20px;font-weight:800;color:#ffffff;">${inrHtml(d.totalAmount)}</td>
</tr>
</tbody></table>

${couponBox}

<div style="text-align:center;margin:6px 0 4px;"><a href="https://anbucrm.com" style="display:inline-block;padding:11px 22px;background-color:#09152b;color:#fbbf24;text-decoration:none;border-radius:8px;font-size:13px;font-weight:700;">Open AnbuCRM Dashboard</a></div>

<div style="margin-top:24px;padding-top:18px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;line-height:1.6;text-align:center;">
This is a computer-generated tax invoice issued by AnbuCRM Technologies Pvt Ltd under the GST framework of India.<br>
Need assistance? Contact <a href="mailto:support@anbucrm.com" style="color:#0e2140;text-decoration:none;font-weight:700;">support@anbucrm.com</a>
</div>
</div></div>
<div style="text-align:center;padding:16px;font-size:11px;color:#94a3b8;">&copy; 2026 AnbuCRM. All rights reserved. &middot; GST Rule 46 Compliant</div>
</div></body></html>`;
}

function invoiceText(d) {
  const lines = [
    `Hi ${d.name},`, '',
    'Thank you for subscribing to AnbuCRM. Your plan is now active.', '',
    `Invoice: ${d.invoiceNumber}`,
    `Plan: ${d.planTerm}`, `Base Price: ${inrHtml(d.basePrice)}`,
  ];
  if (d.discountPercent > 0) {
    lines.push(`Discount: -${inrHtml(d.basePrice - d.subtotal)} (${d.discountPercent}% off${d.couponCode ? ', code ' + d.couponCode : ''})`);
  }
  lines.push(`Taxable Value: ${inrHtml(d.subtotal)}`, `GST @ 18% (CGST 9% + SGST 9%): ${inrHtml(d.tax)}`, `Total Amount Paid: ${inrHtml(d.totalAmount)}`, `Billing Period: ${d.periodStart} to ${d.periodEnd}`, '', 'Your official PDF invoice is attached with this email.', 'Thank you for choosing AnbuCRM!');
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
      country: String(b.country || 'India').trim(),
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

    const attachments = [
      { filename: `AnbuCRM-Invoice-${invoiceNum}.pdf`, content: pdfBuffer, contentType: 'application/pdf' },
    ];
    if (fs.existsSync(LOGO_PATH)) {
      attachments.push({ filename: 'anbucrm-logo.png', path: LOGO_PATH, cid: 'logo_inline', contentType: 'image/png' });
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
