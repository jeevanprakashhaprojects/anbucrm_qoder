# AnbuCRM Payment Backend (Razorpay)

Node.js + Express server that owns **all** Razorpay trust decisions. The Flutter app
never decides whether a payment succeeded — it asks this server, and only shows
"Paid Successful" when this server replies `paid: true`.

## Folder contents

| File | Purpose |
|---|---|
| `server.js` | The whole backend |
| `package.json` | Dependencies (`express`, `razorpay`, `firebase-admin`, `dotenv`) |
| `.env.example` | Template for your secrets — copy to `.env` |
| `database.rules.json` | Paste into Firebase → Realtime Database → Rules |
| `.gitignore` | Keeps `.env` and the service-account key out of git |

## Endpoints

| Method | Path | Auth | What it does |
|---|---|---|---|
| GET | `/health` | none | Liveness + current plan amount |
| POST | `/create-order` | Firebase ID token | Creates a Razorpay order for the signed-in uid |
| POST | `/verify-payment` | Firebase ID token | Checks checkout signature **and** re-fetches the payment from Razorpay |
| GET | `/payment-status` | Firebase ID token | Returns `paid` from the Realtime Database |
| POST | `/razorpay/webhook` | Razorpay signature | Server-to-server confirmation; writes `paid` to the database |

---

## What you need to add

### 1. Razorpay keys (2 values)
Razorpay Dashboard → **Settings → API Keys → Generate Test Key**.
- `RAZORPAY_KEY_ID` — starts with `rzp_test_` (or `rzp_live_`)
- `RAZORPAY_KEY_SECRET` — shown once, copy it immediately

### 2. Razorpay webhook (1 value + 1 setting)
Razorpay Dashboard → **Settings → Webhooks → Add New Webhook**
- **URL**: `https://YOUR-DOMAIN/razorpay/webhook`
- **Secret**: any long random string you invent → put the same string in
  `RAZORPAY_WEBHOOK_SECRET`
- **Events to subscribe**: tick `payment.captured`, `payment.failed`, `order.paid`
- Set it **Active**

> The webhook secret is **not** your API key secret. They are two different values.

### 3. Firebase service account (1 file → 1 env var)
Firebase Console → your project → **Project settings → Service accounts →
Generate new private key** (downloads a JSON file).

Open that JSON and turn it into a single line:
```bash
node -e "const fs=require('fs');const j=JSON.parse(fs.readFileSync('anbucrm-2026-firebase-adminsdk.json'));console.log(JSON.stringify(JSON.stringify(j)))"
```
Copy the printed string (quotes included) into `FIREBASE_SERVICE_ACCOUNT_JSON`.

*Easier alternative:* upload the JSON next to `server.js` as `serviceAccount.json`
and set `FIREBASE_SERVICE_ACCOUNT_PATH=./serviceAccount.json` instead.
`.gitignore` already blocks that filename.

### 4. Realtime Database URL (already filled in for you)
```
FIREBASE_DATABASE_URL=https://anbucrm-2026-default-rtdb.asia-southeast1.firebasedatabase.app
```
Your `google-services.json` has no `firebase_url`, so both the app and this
server pass the URL explicitly. If you ever re-create the database, update it here
**and** in `lib/services/payment_service.dart`.

### 5. Realtime Database rules
Firebase Console → **Realtime Database → Rules** → paste `database.rules.json` → Publish.

The important line: `"payment": { ".write": false }`. That blocks the app from
writing its own `paid` flag — only this server (using the Admin SDK, which
bypasses rules) can set it.

### 6. The backend URL in the app
Set `PAYMENT_BACKEND_URL` in `lib/services/payment_service.dart` to your
deployed URL, e.g. `https://payments.yourdomain.com`.

---

## Deploying on Hostinger

**Option A — VPS (recommended for Node.js)**
1. Hostinger → VPS → pick a **Node.js** template (or Ubuntu + `apt install nodejs npm`).
2. Upload this whole `backend/` folder (File Manager or `scp`).
3. In the VPS terminal:
   ```bash
   cd backend
   npm install --production
   cp .env.example .env      # then edit .env with your real values
   npm start
   ```
4. Keep it alive across restarts:
   ```bash
   npm install -g pm2
   pm2 start server.js --name anbucrm-payments
   pm2 save && pm2 startup
   ```
5. Point your domain at the VPS and add free SSL (Hostinger → SSL), or put nginx
   in front proxying to `http://127.0.0.1:3000`. Razorpay webhooks **require HTTPS**.

**Option B — Hostinger Web Hosting / Node.js hosting panel**
1. hPanel → **Advanced → Node.js** → Create application.
2. Node version **18 or newer**, Application root = the uploaded `backend` folder,
   Startup file = `server.js`.
3. In the **Environment variables** section add every key from `.env.example`
   (no `.env` file needed there — hPanel injects them).
4. Save, then **Run NPM Install**, then **Restart**.

Either way, confirm it works:
```bash
curl https://YOUR-DOMAIN/health
# {"ok":true,"amount_inr":500,"currency":"INR"}
```

---

## How payment is verified (the security chain)

1. App signs the user up with Firebase Auth, then sends the **Firebase ID token**
   to `/create-order`. The server takes the uid from the verified token — never
   from the request body — and stores it in the order's `notes`.
2. Razorpay Checkout runs in the app and returns
   `order_id`, `payment_id`, `signature`.
3. App posts those to `/verify-payment`. The server:
   - recomputes `HMAC-SHA256(order_id + "|" + payment_id, KEY_SECRET)` and
     compares in constant time;
   - **re-fetches the payment from Razorpay's API** and requires
     `status == "captured"`, full `amount_paid`, matching currency and amount;
   - checks the order's `notes.uid` equals the token's uid;
   - only then writes `admin/Users/{uid}/payment/paid = true`.
4. Independently, the webhook confirms the same thing with
   `HMAC-SHA256(raw_body, WEBHOOK_SECRET)`. Two channels, same result — so a
   closed app or a dropped response can't lose a real payment.
5. The app polls `/payment-status` and shows success **only** on `paid: true`.

## Local test run

```bash
cd backend
npm install
cp .env.example .env     # fill in real values
npm start
```

Test the webhook signature path without Razorpay:
```bash
BODY='{"event":"payment.captured","payload":{"payment":{"entity":{"id":"pay_X","order_id":"order_X"}}}}'
SIG=$(echo -n "$BODY" | openssl dgst -sha256 -hmac "your_webhook_secret" | awk '{print $2}')
curl -X POST http://localhost:3000/razorpay/webhook \
  -H "Content-Type: application/json" \
  -H "X-Razorpay-Signature: $SIG" \
  --data-binary "$BODY"
```
A wrong signature must return `400 {"error":"signature_invalid"}`.
