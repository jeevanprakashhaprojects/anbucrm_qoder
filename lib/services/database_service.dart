import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

/// Realtime Database writes for a signed-in user.
///
/// The project's `google-services.json` ships without a `firebase_url`, so the
/// database URL has to be supplied explicitly here.
class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const String databaseUrl =
      'https://anbucrm-2026-default-rtdb.asia-southeast1.firebasedatabase.app';

  FirebaseDatabase get _database => FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: databaseUrl,
  );

  DatabaseReference personalInformationRef(String uid) =>
      _database.ref('admin/Users/$uid/personal_information');

  /// Stores everything collected on the create-account screen.
  ///
  /// The password itself is never written — Firebase Auth already owns it, and
  /// a copy in the database would be a plaintext credential leak.
  Future<void> savePersonalInformation({
    required String uid,
    required String name,
    required String email,
    required String phoneDigits,
    required String phoneFormatted,
    required String dialCode,
    required String country,
    required bool termsAccepted,
  }) async {
    final emailLower = email.trim().toLowerCase();
    await personalInformationRef(uid).set({
      'name': name.trim(),
      'email': emailLower,
      'phone': phoneDigits,
      'phone_formatted': phoneFormatted.trim(),
      'full_phone': '$dialCode$phoneDigits',
      'dial_code': dialCode,
      'country': country,
      'terms_accepted': termsAccepted,
      'password_set': true,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
    // Store email in a flat lookup table for fast existence checks.
    // Dots are not allowed in Firebase keys, so replace them with underscores.
    final emailKey = emailLower.replaceAll('.', '_');
    await _database.ref('admin/email_index/$emailKey').set(uid);
  }

  DatabaseReference subscriptionsRef(String uid) =>
      _database.ref('admin/Users/$uid/subscriptions');

  /// Stores a subscription record under a unique push key so a user can have
  /// multiple subscription entries (renewals, plan changes, etc.).
  ///
  /// Each record includes the billing period (start/end), tax breakdown, and
  /// status — the same shape modern billing systems like Stripe use.
  Future<void> saveSubscription({
    required String uid,
    required String planTerm,
    required double basePrice,
    required double discountPercent,
    required double totalAmount,
    required String couponCode,
  }) {
    final now = DateTime.now().toUtc();
    final periodEnd = _nextPeriodEnd(now, planTerm);
    final subtotal = basePrice * (1 - discountPercent / 100);
    final tax = subtotal * 0.18;

    return subscriptionsRef(uid).push().set({
      'plan_term': planTerm,
      'billing_cycle': planTerm.toLowerCase(),
      'base_price': basePrice,
      'discount_percent': discountPercent,
      'subtotal': subtotal,
      'tax': tax,
      'tax_rate': 0.18,
      'total_amount': totalAmount,
      'currency': 'INR',
      'coupon_code': couponCode,
      'status': 'active',
      'payment_method': couponCode.isNotEmpty ? 'coupon' : 'direct',
      'period': {
        'start': now.toIso8601String(),
        'end': periodEnd.toIso8601String(),
      },
      'created_at': now.toIso8601String(),
    });
  }

  DateTime _nextPeriodEnd(DateTime start, String planTerm) {
    switch (planTerm) {
      case 'Monthly':
        return DateTime.utc(start.year, start.month + 1, start.day);
      case 'Yearly':
        return DateTime.utc(start.year + 1, start.month, start.day);
      case '2 Years':
        return DateTime.utc(start.year + 2, start.month, start.day);
      default:
        return DateTime.utc(start.year, start.month + 1, start.day);
    }
  }

  Future<bool> hasPaid(String uid) async {
    final snapshot =
        await _database.ref('admin/Users/$uid/payment/paid').get();
    return snapshot.value == true;
  }
}
