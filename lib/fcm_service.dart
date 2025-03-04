import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("FCM Permission granted!");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("New notification: ${message.notification?.title}");
    });
  }
}
