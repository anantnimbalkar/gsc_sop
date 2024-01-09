import 'package:flutter/material.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
import 'package:hive_database/screens/notifications/local_notification.dart';
import 'package:hive_database/screens/video_screen/my_course_list.dart';
import 'package:hive_database/screens/video_screen/video_player_screen.dart';
import 'package:hive_database/services/notification_services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../boxes/boxes.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int selectedIndex = 0;
  MyCourseModel? myCourseModel;
  List<Widget> widgetOptions = <Widget>[
    const Text('Home '),
    const MyCourseList(),
    const Text('Profile Page'),
    const LocalNotification()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: ValueListenableBuilder(
            valueListenable: Boxes.getCourseData().listenable(),
            builder: (context, box, child) {
              final list = box.values.toList().cast<MyCourseModel>();
              myCourseModel = list.firstWhere((element) {
                return element.playBackValue != element.videoTotalDuration;
              });
              if (myCourseModel!.playBackValue !=
                  myCourseModel!.videoTotalDuration) {
                NotificationServices().showNotification(
                    title: myCourseModel!.videoName.toString(),
                    body: myCourseModel!.id.toString(),
                    playload: myCourseModel!.videoName.toString(),
                    text: 'view');
              }
              return SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 5.0),
                          child: Text("${myCourseModel!.videoName} "),
                        ),
                        const Spacer(),
                        InkWell(
                          child: const Icon(Icons.play_circle_fill),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VideoPlayerVimeo(
                                      currentSelectedVideo:
                                          myCourseModel!.videoName,
                                      courseId: myCourseModel!.id!.toString(),
                                      myCourseModel: myCourseModel,
                                    )));
                          },
                        ),
                      ],
                    ),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * 0.7,
                      lineHeight: 5.0,
                      percent: myCourseModel!.controllerValue!,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blue,
                    ),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Notification',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
