import 'package:flutter/material.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayerVimeo extends StatefulWidget {
  final String? currentSelectedVideo;
  final String? courseId;
  final MyCourseModel? myCourseModel;
  const VideoPlayerVimeo(
      {Key? key, this.currentSelectedVideo, this.courseId, this.myCourseModel})
      : super(key: key);

  @override
  _VideoPlayerVimeoState createState() => _VideoPlayerVimeoState();
}

class _VideoPlayerVimeoState extends State<VideoPlayerVimeo> {
  PodPlayerController? controller;
  MyCourseModel? myCourseModelData;
  @override
  void initState() {
    initiaseController();

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    saveData();
    controller!.pause();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MediaQuery.of(context).orientation == Orientation.landscape
            ? null
            : AppBar(
                title: Text(widget.currentSelectedVideo ?? ""),
              ),
        body: ListView(
          children: [
            PodVideoPlayer(
              controller: controller!,
              onVideoError: () {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text("Error in playing video"),
                  ),
                );
              },
              alwaysShowProgressBar: true,
              videoTitle: Text(
                widget.currentSelectedVideo ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.currentSelectedVideo ?? "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  saveData() async {
    Duration timeString = controller!.currentVideoPosition;

    Duration totalDuration = controller!.totalVideoLength;

    var percent =
        (timeString.inMilliseconds / totalDuration.inMilliseconds) * 100;
    myCourseModelData!.controllerValue = (percent / 100.0);
    myCourseModelData!.playBackValue = timeString.inSeconds;
    myCourseModelData!.videoTotalDuration = totalDuration.inSeconds;
    myCourseModelData!.save();
  }

  void initiaseController() {
    myCourseModelData = widget.myCourseModel;

    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(widget.currentSelectedVideo!),
        podPlayerConfig: const PodPlayerConfig(
            wakelockEnabled: true,
            autoPlay: true,
            isLooping: false,
            videoQualityPriority: [240, 360]))
      ..initialise().then((value) {});
    Future.delayed(const Duration(milliseconds: 100));
    // int seconds = myCourseModelData!
    //     .playBackValue!; // Replace this with your double value

    // Duration duration = Duration(seconds: seconds);
    // controller!.videoSeekTo(duration);
  }
}
