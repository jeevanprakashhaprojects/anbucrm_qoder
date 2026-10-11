import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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
  }) {
    return personalInformationRef(uid).set({
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'phone': phoneDigits,
      'phone_formatted': phoneFormatted.trim(),
      'full_phone': '$dialCode$phoneDigits',
      'dial_code': dialCode,
      'country': country,
      'terms_accepted': termsAccepted,
      'password_set': true,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<bool> hasPaid(String uid) async {
    final snapshot =
        await _database.ref('admin/Users/$uid/payment/paid').get();
    return snapshot.value == true;
  }
}
