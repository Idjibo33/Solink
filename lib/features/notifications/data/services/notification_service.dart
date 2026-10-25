import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundNotification(RemoteMessage message) async {}

class NotificationService {
  NotificationService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<void> initialize() async {
    await _messaging.requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(onBackgroundNotification);
  }
}
