import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
class NotificationProvider {
  final FirebaseMessaging _firebaseMsg;
  final FlutterLocalNotificationsPlugin _localNotifPlugin;

  NotificationProvider(this._firebaseMsg, this._localNotifPlugin);

  Future<void> setupNotification(BuildContext ctx) async {
    NotificationSettings permission = await _firebaseMsg.requestPermission();
    if (permission.authorizationStatus != AuthorizationStatus.authorized &&
        permission.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }
    final token = await _firebaseMsg.getToken();
    await ctx.read<ProfileProvider>().updateFCMToken(token);

    _firebaseMsg.onTokenRefresh.listen((newToken) async {
      await ctx.read<ProfileProvider>().updateFCMToken(newToken);
    });

    var androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidSettings);
    await _localNotifPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    String title = message.notification?.title ?? 'Hello';
    String body = message.notification?.body ?? "Hello";

    var androidDetails = AndroidNotificationDetails(
      "inApp1",
      "InAppNotification",
      importance: Importance.high,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {}
}
