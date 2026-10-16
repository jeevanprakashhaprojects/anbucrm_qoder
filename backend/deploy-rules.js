#!/usr/bin/env node
/**
 * Deploy Firebase Realtime Database rules using Firebase Admin SDK.
 * 
 * Usage:
 *   node deploy-rules.js [path-to-service-account.json]
 * 
 * If no service account path is provided, it looks for:
 *   - FIREBASE_SERVICE_ACCOUNT_PATH env var
 *   - ./serviceAccount.json
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const RULES_FILE = path.join(__dirname, 'database.rules.json');

async function deployRules(serviceAccountPath) {
  // Load service account
  let serviceAccount;
  if (serviceAccountPath) {
    serviceAccount = require(serviceAccountPath);
  } else if (process.env.FIREBASE_SERVICE_ACCOUNT_PATH) {
    serviceAccount = require(process.env.FIREBASE_SERVICE_ACCOUNT_PATH);
  } else if (fs.existsSync(path.join(__dirname, 'serviceAccount.json'))) {
    serviceAccount = require(path.join(__dirname, 'serviceAccount.json'));
  } else {
    console.error('Error: No service account found.');
    console.error('Provide path as argument, set FIREBASE_SERVICE_ACCOUNT_PATH, or place serviceAccount.json in this directory.');
    process.exit(1);
  }

  // Load rules
  if (!fs.existsSync(RULES_FILE)) {
    console.error('Error: database.rules.json not found');
    process.exit(1);
  }
  const rules = JSON.parse(fs.readFileSync(RULES_FILE, 'utf8'));

  // Initialize Firebase Admin
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: process.env.FIREBASE_DATABASE_URL || 'https://anbucrm-2026-default-rtdb.asia-southeast1.firebasedatabase.app'
  });

  console.log('Deploying Firebase Realtime Database rules...');
  console.log('Rules:', JSON.stringify(rules, null, 2));

  try {
    // Use the REST API to update rules
    const databaseURL = process.env.FIREBASE_DATABASE_URL || 'https://anbucrm-2026-default-rtdb.asia-southeast1.firebasedatabase.app';
    const projectId = serviceAccount.project_id;
    
    // Get access token
    const credential = admin.credential.cert(serviceAccount);
    const accessToken = await credential.getAccessToken();
    
    // Update rules via REST API
    const response = await fetch(
      `https://firebasedatabase.googleapis.com/v1beta/projects/${projectId}/locations/-/instances/anbucrm-2026-default-rtdb/rules`,
      {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${accessToken.access_token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ rules: JSON.stringify(rules) })
      }
    );

    if (response.ok) {
      console.log('✓ Rules deployed successfully!');
    } else {
      const error = await response.text();
      console.error('Error deploying rules:', error);
      process.exit(1);
    }
  } catch (err) {
    console.error('Error:', err.message);
    process.exit(1);
  } finally {
    process.exit(0);
  }
}

const serviceAccountPath = process.argv[2];
deployRules(serviceAccountPath);
