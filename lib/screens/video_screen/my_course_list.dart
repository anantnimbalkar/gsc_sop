import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
import 'package:hive_database/screens/audio/audio_player.dart';
import 'package:hive_database/screens/video_screen/video_player_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyCourseList extends StatefulWidget {
  const MyCourseList({super.key});

  @override
  State<MyCourseList> createState() => _MyCourseListState();
}

class _MyCourseListState extends State<MyCourseList> {
  List<MyCourseModel> myCourseModelList = [];
  MyCourseModel? myCourseModel;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Courses"),
        ),
        body: ValueListenableBuilder(
          valueListenable: Boxes.getCourseData().listenable(),
          builder: (context, box, ch) {
            final list = box.values.toList().cast<MyCourseModel>();

            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  myCourseModel = list[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                          onTap: () {
                            if (list[index].id == 6) {
                              if (list[index].storePath!.isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AudioPlayerScreen(
                                          currentSelectedVideo:
                                              list[index].storePath,
                                          courseId: list[index].id!.toString(),
                                          myCourseModel: list[index],
                                        )));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AudioPlayerScreen(
                                          currentSelectedVideo:
                                              list[index].videoName,
                                          courseId: list[index].id!.toString(),
                                          myCourseModel: list[index],
                                        )));
                              }
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VideoPlayerVimeo(
                                        currentSelectedVideo:
                                            list[index].videoName,
                                        courseId: list[index].id!.toString(),
                                        myCourseModel: list[index],
                                      )));
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Video ${list[index].id}"),
                                  const Spacer(),
                                  const Icon(Icons.play_circle_fill),
                                  (list[index].id == 6 &&
                                          list[index].storePath!.isEmpty)
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            FileDownloader.downloadFile(
                                                downloadDestination:
                                                    DownloadDestinations
                                                        .appFiles,
                                                url: (list[index].id == 6)
                                                    ? list[index]
                                                        .videoName!
                                                        .trim()
                                                    : 'https://vimeo.com/680501456',
                                                onProgress: (name, progress) {
                                                  setState(() {
                                                    progress = progress;
                                                  });
                                                },
                                                onDownloadCompleted: (value) {
                                                  print('path  $value ');
                                                  myCourseModel!.storePath =
                                                      value.toString();

                                                  myCourseModel!.save();
                                                  setState(() {
                                                    progress = 0;
                                                  });
                                                });
                                          },
                                          child: const Icon(Icons.download))
                                      : Container()
                                ],
                              ),
                              LinearPercentIndicator(
                                width: 140.0,
                                lineHeight: 5.0,
                                percent: list[index].controllerValue!,
                                backgroundColor: Colors.grey,
                                progressColor: Colors.blue,
                              ),
                            ],
                          )),
                    ),
                  );
                });
          },
        ));
  }

  downloadAudioFile(String name) {}
}
