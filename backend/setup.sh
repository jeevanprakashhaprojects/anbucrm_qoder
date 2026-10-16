#!/bin/bash
# Deploy Firebase Realtime Database rules and configure backend
# Run this from the backend directory

set -e

echo "=== AnbuCRM Setup Script ==="
echo ""

# Check if we're in the right directory
if [ ! -f "server.js" ]; then
  echo "Error: Please run this from the backend/ directory"
  exit 1
fi

# Step 1: Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
  echo "Creating .env file from template..."
  cp .env.example .env
  echo ""
  echo "️  IMPORTANT: Edit .env and fill in your actual values:"
  echo "  - RAZORPAY_KEY_ID"
  echo "  - RAZORPAY_KEY_SECRET"
  echo "  - RAZORPAY_WEBHOOK_SECRET"
  echo "  - FIREBASE_SERVICE_ACCOUNT_JSON or FIREBASE_SERVICE_ACCOUNT_PATH"
  echo ""
  echo "Then run: nano .env"
  echo ""
fi

# Step 2: Deploy Firebase rules
echo "Deploying Firebase Realtime Database rules..."
if command -v firebase &> /dev/null; then
  if firebase projects:list &> /dev/null; then
    firebase database:update_rules database.rules.json --project anbucrm-2026
    echo "✓ Firebase rules deployed"
  else
    echo "️  Firebase CLI not logged in. Run: firebase login"
    echo "Then re-run this script."
  fi
else
  echo "⚠️  Firebase CLI not installed. Run: npm install -g firebase-tools"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Edit .env with your actual credentials"
echo "2. Deploy to VPS: scp -r ./* root@50.6.44.56:/root/anbucrm-backend/"
echo "3. On VPS: cd /root/anbucrm-backend && npm install && pm2 restart server"
echo ""
