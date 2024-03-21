import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';

class CloudMessaging {
  static Future<String?> getMessagingToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  static Future<void> initializeMessaging() async {
    await _requestPermissions();
    await _setForegroundNotification();
  }

  static Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<void> _setForegroundNotification() async {
    // Update the iOS foreground notification presentation options to allow
    // heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void startListeningMessages(
    Future<void> Function(RemoteMessage) backgroundMessageHandler,
    void Function(RemoteMessage) remoteMessageHandler,
    void Function(RemoteMessage) foregroundRemoteMessageHandler,
  ) {
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    _handleAppTerminatedState(remoteMessageHandler);
    _handleAppBackgroundState(remoteMessageHandler);
    _handleAppForegroundState(
      backgroundMessageHandler,
      foregroundRemoteMessageHandler,
    );
  }

  static void _handleAppTerminatedState(
    void Function(RemoteMessage) remoteMessageHandler,
  ) {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        remoteMessageHandler(message);
      }
    });
  }

  static void _handleAppBackgroundState(
    void Function(RemoteMessage) remoteMessageHandler,
  ) {
    FirebaseMessaging.onMessageOpenedApp.listen(remoteMessageHandler);
  }

  static void _handleAppForegroundState(
    Future<void> Function(RemoteMessage) backgroundMessageHandler,
    void Function(RemoteMessage) foregroundRemoteMessageHandler,
  ) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Do background work
      backgroundMessageHandler(message);
      // Show the in app foreground notification.
      /* InAppNotifications.show(
          title: message.notification!.title,
          description: message.notification!.body,
          leading: Image.asset('images/app_icon.png'),
          onTap: () {
            // perform foreground activity on tap.
            foregroundRemoteMessageHandler(message);
          });*/
    });
  }
}
