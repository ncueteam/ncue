import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ncue.aiot_app/src/app.dart';
import 'package:ncue.aiot_app/src/features/notify_system/notify_view.dart';

class NotifyApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    debugPrint('Token: $fCMToken');

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState
        ?.pushNamed(const NotifyView().routeName, arguments: message);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
