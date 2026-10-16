import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio();

  Future<UserCredential> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null && name.trim().isNotEmpty) {
      await user.updateDisplayName(name.trim());
    }
    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static String friendlyError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered. Try signing in instead.';
        case 'invalid-email':
          return 'That email address looks invalid.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'operation-not-allowed':
          return 'Email/Password sign-in is not enabled in the Firebase console.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password. Check your details and try again.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Wait a minute and try again.';
        case 'network-request-failed':
          return 'No internet connection. Check your network and try again.';
        default:
          return 'Something went wrong (${error.code}). Please try again.';
      }
    }
    return 'Something went wrong. Check your internet and try again.';
  }

  Future<bool> checkEmailExists(String email) async {
    final response = await _dio.post(
      'https://api.anbucrm.com/auth/check-email',
      data: {'email': email.trim()},
    );
    return response.data['exists'] == true;
  }
}
