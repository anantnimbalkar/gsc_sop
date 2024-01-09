import 'package:hive/hive.dart';
part "nodes_model.g.dart"; //g means genrator

@HiveType(typeId: 0)
class NotesModel extends HiveObject{
  @HiveField(0) //for understanding HiveField means like column name
   String? title;

  @HiveField(1)
   String? description;

  NotesModel({this.title, this.description});
}
