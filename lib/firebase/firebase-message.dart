import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Message {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

  setNotiLocalInstance() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print("onDidReceiveLocalNotification called.");
      },
    );
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      print("onSelectNotification called.");
    });
  }

  sendNotification(String? title, String? body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '10000',
      'FLUTTER_NOTIFICATION_CHANNEL',
      'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111, title, body, platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  onmessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      return sendNotification(
          message.notification?.title, message.notification?.body);
    });
  }
}
