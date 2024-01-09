import 'package:hive/hive.dart';
part 'my_course_model.g.dart';

@HiveType(typeId: 1)
class MyCourseModel extends HiveObject {
  @HiveField(0)
  String? videoName;

  @HiveField(1)
  int? id;

  @HiveField(2)
  double? controllerValue;

  @HiveField(3)
  int? playBackValue;

  @HiveField(4)
  String? storePath;

  @HiveField(5)
  int? videoTotalDuration;
  MyCourseModel(
      {this.id,
      this.videoName,
      this.controllerValue,
      this.playBackValue,
      this.storePath,
      this.videoTotalDuration});
}
