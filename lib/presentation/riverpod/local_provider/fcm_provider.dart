import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final fcmProvider = Provider((ref) {
  _setupPushNotifications();
});

Future<void> _setupPushNotifications() async {
  final fcm = FirebaseMessaging.instance;
  final token = await fcm.getToken();
}