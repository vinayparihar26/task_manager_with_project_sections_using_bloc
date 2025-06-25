// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasksAdapter extends TypeAdapter<Tasks> {
  @override
  final int typeId = 0;

  @override
  Tasks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tasks(
      title: fields[0] as String,
      category: fields[1] as String,
      priority: fields[2] as String?,
      description: fields[3] as String?,
      peoples: fields[4] as String?,
      status: fields[5] as bool?,
      dateTime: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Tasks obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.priority)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.peoples)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
