// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasklist_classes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskListAdapter extends TypeAdapter<TaskList> {
  @override
  final int typeId = 0;

  @override
  TaskList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskList()
      .._listUUID = fields[0] as String
      ..list = (fields[1] as List).cast<Task>();
  }

  @override
  void write(BinaryWriter writer, TaskList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._listUUID)
      ..writeByte(1)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 2;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      taskName: fields[1] == null ? 'none' : fields[1] as String?,
      taskStatus: fields[2] as String,
      taskLabel: fields[3] == null ? 'none' : fields[3] as String?,
      taskDescription: fields[4] == null ? 'none' : fields[4] as String?,
    )
      .._taskUUID = fields[0] == null ? '-1' : fields[0] as String
      ..clockList = (fields[6] as List)
          .map((dynamic e) => (e as List).cast<DateTime?>())
          .toList()
      ..totalTime_minutes = fields[7] as int
      .._clockRunning = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._taskUUID)
      ..writeByte(1)
      ..write(obj.taskName)
      ..writeByte(2)
      ..write(obj.taskStatus)
      ..writeByte(3)
      ..write(obj.taskLabel)
      ..writeByte(4)
      ..write(obj.taskDescription)
      ..writeByte(6)
      ..write(obj.clockList)
      ..writeByte(7)
      ..write(obj.totalTime_minutes)
      ..writeByte(8)
      ..write(obj._clockRunning);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
