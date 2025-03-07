import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
class NotificationProvider {
  final FirebaseMessaging _firebaseMsg;

  NotificationProvider(this._firebaseMsg);

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {}
}
