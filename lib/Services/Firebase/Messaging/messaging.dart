import 'package:firebase_messaging/firebase_messaging.dart';

//
Future<void> onBackgroungNotificationHandler(RemoteMessage message) async {}

class Messaging {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> initMessaging() async {
    await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(onBackgroungNotificationHandler);
  }
}
