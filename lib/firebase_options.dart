// File: lib/firebase_options.dart
// Generated from google-services.json (Firebase project anbucrm-2026).
//-ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'run "flutterfire configure" or add a web client in the Firebase console.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS - '
          'run "flutterfire configure" or add a macOS client in the Firebase console.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows - '
          'run "flutterfire configure" or add a Windows client in the Firebase console.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux - '
          'run "flutterfire configure" or add a Linux client in the Firebase console.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyihQ_3ztakKgF6qwAx108frDaWtQU0o8',
    appId: '1:192082441122:android:8fec8421d71c38377138fb',
    messagingSenderId: '192082441122',
    projectId: 'anbucrm-2026',
    storageBucket: 'anbucrm-2026.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyihQ_3ztakKgF6qwAx108frDaWtQU0o8',
    appId: '1:192082441122:ios:8fec8421d71c38377138fb',
    messagingSenderId: '192082441122',
    projectId: 'anbucrm-2026',
    storageBucket: 'anbucrm-2026.firebasestorage.app',
    iosBundleId: 'com.example.anbucrm',
  );
}
