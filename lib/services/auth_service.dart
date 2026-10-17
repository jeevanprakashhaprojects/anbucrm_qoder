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

  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post<dynamic>(
        'https://api.anbucrm.com/auth/forgot-password',
        data: {'email': email.trim()},
        options: Options(
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 45),
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          followRedirects: false,
        ),
      );
      final data = response.data;
      if (response.statusCode != 200 || data is! Map || data['ok'] != true) {
        throw const PasswordResetException();
      }
    } on DioException catch (error) {
      switch (error.response?.statusCode) {
        case 400:
          throw const PasswordResetException('Enter a valid email address.');
        case 429:
          throw const PasswordResetException(
            'Too many reset requests. Wait 15 minutes and try again.',
          );
        case 503:
          throw const PasswordResetException(
            'Password reset is temporarily unavailable. Please try again later.',
          );
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw const PasswordResetException(
            'The request timed out. Check your connection and try again.',
          );
        case DioExceptionType.connectionError:
          throw const PasswordResetException(
            'Unable to connect. Check your internet connection and try again.',
          );
        default:
          throw const PasswordResetException();
      }
    }
  }

  Future<bool> checkEmailExists(String email) async {
    final response = await _dio.post(
      'https://api.anbucrm.com/auth/check-email',
      data: {'email': email.trim()},
    );
    return response.data['exists'] == true;
  }
}

class PasswordResetException implements Exception {
  const PasswordResetException([
    this.message = 'Unable to request a password reset. Please try again.',
  ]);

  final String message;

  @override
  String toString() => message;
}
