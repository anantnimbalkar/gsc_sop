import 'package:hive/hive.dart';
import 'package:hive_database/courseModel/my_course_model.dart';
import 'package:hive_database/models/nodes_model.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes_database');


  static Box<MyCourseModel> getCourseData()=>Hive.box<MyCourseModel>('my_course_database');
}
