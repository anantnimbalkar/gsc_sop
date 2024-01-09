import 'package:flutter/material.dart';
import 'package:hive_database/services/notification_services.dart';

class LocalNotification extends StatefulWidget {
  const LocalNotification({super.key});

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Notification"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              print("object0000000000000000");
            },
            child: const Text("Show Notification")),
      ),
    );
  }
}
