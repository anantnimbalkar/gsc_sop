import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
import 'package:hive_database/screens/audio/common.dart';
import 'package:hive_database/screens/audio/components/control_button.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String? currentSelectedVideo;
  final String? courseId;
  final MyCourseModel? myCourseModel;
  const AudioPlayerScreen(
      {super.key,
      this.currentSelectedVideo,
      this.courseId,
      this.myCourseModel});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late AudioPlayer player;
  late JustAudioBackground _audioBackground;
  MyCourseModel? myCourseModelData;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    ambiguate(WidgetsBinding.instance).addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init(widget.myCourseModel);
    myCourseModelData = widget.myCourseModel;
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.landscape
          ? null
          : AppBar(
              title: Text(widget.currentSelectedVideo ?? ""),
            ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display play/pause button and volume/speed sliders.
            ControlButtons(player),
            // Display seek bar. Using StreamBuilder, this widget rebuilds
            // each time the position, buffered position or duration changes.
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: player.seek,
                );
              },
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _init(myCourseModel) async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    /*    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech()); */
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      if (Platform.isIOS) {
        //?  <-------- Without Caching --------------->

        if (await File(myCourseModelData!.videoName.toString()).exists()) {
          String Path = myCourseModelData!.storePath!;
          if (myCourseModelData != null) {
            await player.setAudioSource(AudioSource.file(Path),
                initialPosition:
                    Duration(seconds: myCourseModelData!.playBackValue!));
          } else {
            await player.setAudioSource(AudioSource.file(Path));
          }
        } else {
          await player.setAudioSource(
            AudioSource.uri(
              Uri.parse("${myCourseModelData!.videoName}"),
              /*  headers: {
                'Authorization': Config.fcmToken,
              }, */
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: '${myCourseModelData!.id.toString()}',
                album: myCourseModelData!.videoName ?? "",
                title: myCourseModelData!.videoName ?? "",
              ),
            ),
          );
        }
      } else {
        print('${myCourseModelData!.storePath}===================video name');
        //?  <-------- With Caching --------------->
        // Download and cache audio while playing it (experimental)
        if (await File(myCourseModelData!.storePath!).exists()) {
          print("exits the current nfsrsgorngoi--------------------------");
          String Path = myCourseModelData!.storePath!;
          if (myCourseModelData != null) {
            await player.setAudioSource(AudioSource.file(Path),
                initialPosition:
                    Duration(seconds: myCourseModelData!.playBackValue!));
          } else {
            await player.setAudioSource(AudioSource.file(Path));
          }
          //await player.setAudioSource(AudioSource.file(Path));
        } else {
          final _audioSource = LockCachingAudioSource(
            Uri.parse("${myCourseModelData!.videoName}"),
            /* headers: {
              'Authorization': Config.fcmToken,
            }, */
            tag: MediaItem(
              // Specify a unique ID for each media item:
              id: '${myCourseModelData!.id.toString()}',
              album: myCourseModelData!.videoName ?? "",
              title: myCourseModelData!.videoName ?? "",
            ),
          );
          if (myCourseModelData != null) {
            await player.setAudioSource(_audioSource,
                initialPosition:
                    Duration(seconds: myCourseModelData!.playBackValue!));
          } else {
            await player.setAudioSource(_audioSource);
          }
          //  await player.setAudioSource(_audioSource);
        }
      }
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    saveData();
    // player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.play();
    }
      if (state == AppLifecycleState.hidden) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.play();
    }
     if (state == AppLifecycleState.inactive) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.play();
    }
    if (state == AppLifecycleState.resumed) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
    //  player.dispose();
    
      if (myCourseModelData != null) {
            await player.setAudioSource(AudioSource.file(myCourseModelData!.storePath!),
                initialPosition:
                    Duration(seconds: myCourseModelData!.playBackValue!));
          } else {
            await player.setAudioSource(AudioSource.file(myCourseModelData!.storePath!));
          }
    }
    print(state);
    print("================object");
  }

  void saveData() {
    Duration timeString = player.position;

    Duration totalDuration = player.duration!;

    var percent =
        (timeString.inMilliseconds / totalDuration.inMilliseconds) * 100;
    myCourseModelData!.controllerValue = (percent / 100.0);
    myCourseModelData!.playBackValue = timeString.inSeconds;
    myCourseModelData!.playBackValue = timeString.inSeconds;
    myCourseModelData!.save();
  }
}
