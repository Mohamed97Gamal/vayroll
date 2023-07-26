import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/navigation/notification_navigator.dart';
import 'package:vayroll/providers/employee_provider.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';

Future<BaseResponse<dynamic>> updateFCMTokenIfNeeded() async {
  final savedFCMToken = await DiskRepo().getFcmToken();
  final fcmToken = await FirebaseMessaging.instance.getToken();

  if (savedFCMToken == fcmToken) return Future.value(BaseResponse(status: true));

  if (fcmToken == null || fcmToken.isEmpty)
    return Future.value(
      BaseResponse(status: false, message: "FCM Token couldn\'t be retrieved from firebase."),
    );

  var response = await ApiRepo().updateFCMToken(fcmToken);
  if (response.status!) DiskRepo().saveFcmToken(fcmToken);

  return response;
}

Future<BaseResponse<dynamic>> removeFCMToken() async {
  var response = await ApiRepo().updateFCMToken("");
  if (response.status!) DiskRepo().saveFcmToken("");
  return response;
}

class LocalNotification {
  static final LocalNotification _instance = LocalNotification._internal();

  factory LocalNotification() {
    return _instance;
  }

  LocalNotification._internal();

  bool initialized = false;
  RemoteMessage? initialMessage;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void handleForegroundMessage(RemoteMessage message) async {
    if (message == null) return;

    final notification = message.notification;

    if (notification != null && Platform.isAndroid) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'vayroll_notifications_channel',
        'VAYROLL Notifications',
        channelDescription: 'VAYROLL notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: androidPlatformChannelSpecifics,
        ),
        payload: json.encode({
          "data": message.data,
          "notification": {
            "title": notification.title,
            "body": notification.body,
          },
        }),
      );
    }
  }

  Future init(BuildContext context) async {
    if (initialized) {
      return;
    }
    initialized = true;
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      'notification_icon',
    );
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        final loggedIn = context.read<EmployeeProvider>().employee != null;
        var map = json.decode(payload.payload!);
        var message = RemoteMessage.fromMap(map);
        if (loggedIn) {
          deepLink(context, message);
        } else {
          initialMessage = message;
        }
      },
    );

    var fcmMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (fcmMessage != null) {
      initialMessage ??= fcmMessage;
    }

    final notificationAppLaunchDetails = (await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails())!;
    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      if (notificationAppLaunchDetails.notificationResponse!.payload?.isNotEmpty ?? false) {
        var map = json.decode(notificationAppLaunchDetails.notificationResponse!.payload!);
        var message = RemoteMessage.fromMap(map);
        initialMessage ??= message;
      }
    }

    // Handle the notification when app is in foreground
    FirebaseMessaging.onMessage.listen(handleForegroundMessage);
    // Handle the notification when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null) deepLink(context, message);
    });
  }

  Future<bool> handleInitialMessage(BuildContext context) async {
    if (initialMessage != null) {
      await deepLink(context, initialMessage);

      initialMessage = null;
      return true;
    }
    return false;
  }
}
