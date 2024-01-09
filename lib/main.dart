import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
import 'package:hive_database/screens/start_screens/start_screen.dart';
import 'package:hive_database/services/notification_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

bool _secureMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkNotificationPermission();
  NotificationServices().initialiseNotification();
  if (_secureMode == true) {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  } else {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  var directory = await getApplicationDocumentsDirectory();

  Hive.init(directory.path); //initialise the hive
  Hive.registerAdapter(MyCourseModelAdapter());
  await Hive.openBox<MyCourseModel>("my_course_database");
  var box = Boxes.getCourseData();
  if (box.values.isEmpty) {
    addDataToHive();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const AddNodeScreen(),
      //  home: const LocalNotification(),
      home: const StartScreen(),
    );
  }
}

void checkNotificationPermission() async {
  var status = await Permission.notification.status;
  Permission.notification.request();

  if (status.isDenied) {
    Permission.notification.request();
  }
}

void addDataToHive() {
  dynamic myCourseModel;
  final Box box = Boxes.getCourseData();
  myCourseModel = MyCourseModel(
      videoName: '46363855',
      id: 1,
      controllerValue: 0,
      playBackValue: 0,
      storePath: '');
  box.add(myCourseModel);
  myCourseModel = MyCourseModel(
      videoName: '99623221',
      id: 2,
      controllerValue: 0,
      playBackValue: 0,
      storePath: '');
  box.add(myCourseModel);
  myCourseModel = MyCourseModel(
      videoName: '680501456',
      id: 3,
      controllerValue: 0,
      playBackValue: 0,
      storePath: '');
  box.add(myCourseModel);
  myCourseModel = MyCourseModel(
      videoName: '767609008',
      id: 4,
      controllerValue: 0,
      playBackValue: 0,
      storePath: '');
  box.add(myCourseModel);
  myCourseModel = MyCourseModel(
      videoName: '899561604',
      id: 5,
      controllerValue: 0,
      playBackValue: 0,
      storePath: '');
  box.add(myCourseModel);
  myCourseModel = MyCourseModel(
      videoName:
          'https://commondatastorage.googleapis.com/codeskulptor-assets/Epoq-Lepidoptera.ogg',
      id: 6,
      controllerValue: 0,
      playBackValue: 0,
      storePath: '');
  box.add(myCourseModel);
}
