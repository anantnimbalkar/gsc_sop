import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialiseNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notiticationResponse) async {});
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? playload,
      String? text}) async {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails(text!));
  }

  notificationDetails(String text) {
    return NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max,
            icon: "notification",
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('baby'),
            actions: [
              AndroidNotificationAction('Test', text,
                  showsUserInterface: true,
                  inputs: [AndroidNotificationActionInput()])
            ]),
        iOS: DarwinNotificationDetails());
  }

  // Future onSelectNotification(String? payload, BuildContext context) async {
  //   if (payload != null) {
  //     // Navigate to your specific screen
  //     Navigator.of(context).push(
  //         MaterialPageRoute(builder: (_) => VideoScreen(videoUrl: payload)));
  //   }
  // }
}
