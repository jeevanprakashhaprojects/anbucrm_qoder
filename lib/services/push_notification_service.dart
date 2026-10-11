import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await messaging.getToken();
    debugPrint('FCM token: $token');

    FirebaseMessaging.onMessage.listen(_showForegroundToast);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notification tapped: ${message.notification?.title}');
    });

    await messaging.subscribeToTopic('all-users');
  }

  void _showForegroundToast(RemoteMessage message) {
    final title = message.notification?.title ?? 'New notification';
    final body = message.notification?.body ?? '';
    Fluttertoast.showToast(
      msg: body.isNotEmpty ? '$title\n$body' : title,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
