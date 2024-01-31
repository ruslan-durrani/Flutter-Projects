import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Initialize Firebase and request permission for notifications
    await requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message received:\nTitle: ${message.notification!.title}\nBody: ${message.notification!.body}');
        // Handle the notification message here
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission for notifications");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
    // Store this token in your database for the specific user
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle the notification message here
}

