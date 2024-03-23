import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<String?> getDeviceToken() async {
    String? token = await _fcm.getToken();
    print('Token: $token');
    return token;
  }

  void setupFirebaseMessagingListeners() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        storeTokenInFirestore(userId, newToken);
      }
    });
  }

  void storeTokenInFirestore(String? userId, String token) async {
    if (userId == null) return;
    FirebaseFirestore.instance.collection('fcm_token').doc(userId).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }

  void requestPermissions() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
