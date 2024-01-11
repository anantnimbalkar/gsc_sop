import 'package:flutter/material.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
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
  Color color = Colors.transparent;
  var box;
  List<Widget> widgetOptions = <Widget>[
    const Text('Home '),
    const MyCourseList(),
    const Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box = Boxes.getCourseData();
    if (box.values.isNotEmpty) {
      if (myCourseModel != null) {
        color = Color.fromARGB(255, 236, 210, 219);
      } else {
        color = Colors.transparent;
      }
      final list = box.values.toList().cast<MyCourseModel>();

      if (list.isNotEmpty) {
        list.forEach((element) {
          if (element.playBackValue != element.videoTotalDuration) {
            myCourseModel = element;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      floatingActionButton: SizedBox(
        height: 80,
        child: FloatingActionButton.extended(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: (myCourseModel != null) ? 1 : 0,
            onPressed: () {},
            label: ValueListenableBuilder(
                valueListenable: Boxes.getCourseData().listenable(),
                builder: (context, box, child) {
                  if (box.values.isNotEmpty) {
                    if (myCourseModel != null) {
                      color = Color.fromARGB(255, 236, 210, 219);
                    } else {
                      color = Colors.transparent;
                    }

                    final list = box.values.toList().cast<MyCourseModel>();

                    if (list.isNotEmpty) {
                      /*  myCourseModel = list.firstWhere((element) =>
                        element.playBackValue != element.videoTotalDuration); */
                      list.reversed.forEach((element) {
                        if (element.playBackValue !=
                            element.videoTotalDuration) {
                          myCourseModel = element;
                        }
                      });
                    }
                  }
                  if (myCourseModel != null) {
                    if (myCourseModel!.playBackValue !=
                        myCourseModel!.videoTotalDuration) {
                      NotificationServices().initialiseNotification(context);
                      NotificationServices().showNotification(
                          title: myCourseModel!.id.toString(),
                          body: myCourseModel!.videoName.toString(),
                          payload: myCourseModel!.videoName.toString(),
                          id: myCourseModel!.id!,
                          text: 'view',
                          context: context);
                    }
                  }
                  return (myCourseModel != null)
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.83,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 5.0),
                                    child: Text("${myCourseModel!.videoName} "),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    child: const Icon(Icons.play_circle_fill),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerVimeo(
                                            currentSelectedVideo:
                                                myCourseModel!.videoName,
                                            courseId:
                                                myCourseModel!.id!.toString(),
                                            myCourseModel: myCourseModel,
                                          ),
                                        ),
                                      );
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
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        );
                }),
            backgroundColor: color),
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
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
