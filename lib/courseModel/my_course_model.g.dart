// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_course_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyCourseModelAdapter extends TypeAdapter<MyCourseModel> {
  @override
  final int typeId = 1;

  @override
  MyCourseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyCourseModel(
      id: fields[1] as int?,
      videoName: fields[0] as String?,
      controllerValue: fields[2] as double?,
      playBackValue: fields[3] as int?,
      storePath: fields[4] as String?,
      videoTotalDuration: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MyCourseModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.videoName)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.controllerValue)
      ..writeByte(3)
      ..write(obj.playBackValue)
      ..writeByte(4)
      ..write(obj.storePath)
      ..writeByte(5)
      ..write(obj.videoTotalDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyCourseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
