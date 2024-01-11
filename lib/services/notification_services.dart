import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
import 'package:hive_database/screens/video_screen/video_player_screen.dart';

class NotificationServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  MyCourseModel? myCourseModel;
  Future<void> initialiseNotification(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print(payload);
        log("+++++++++++++++++++++++");
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notiticationResponse) async {
        if (notiticationResponse.payload != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VideoPlayerVimeo(
                        currentSelectedVideo:
                            notiticationResponse.payload.toString(),
                        courseId: notiticationResponse.id.toString(),
                        myCourseModel: myCourseModel,
                      )));
        }
      },
    );
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      String? text,
      required BuildContext context}) async {
    // log(payload.toString());
    // log(text.toString());
    // if (payload!.isNotEmpty) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (_) => VideoPlayerVimeo(currentSelectedVideo: payload.toString(),)));
    // }
    return flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(text!),
      payload: payload,
    );
  }

  notificationDetails(String text) {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.max,
          icon: "notification",
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
          colorized: true,
          category: AndroidNotificationCategory.promo,
          // chronometerCountDown: true,
          enableLights: true,
          showProgress: true,
          sound: RawResourceAndroidNotificationSound('baby'),
        ),
        iOS: DarwinNotificationDetails());
  }

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future onSelectNotification(String? payload, BuildContext context) async {
  //   if (payload != null) {
  //     // Navigate to your specific screen
  //     Navigator.of(context).push(
  //         MaterialPageRoute(builder: (_) => VideoScreen(videoUrl: payload)));
  //   }
  // }
}
