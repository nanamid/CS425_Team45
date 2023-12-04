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
    return TaskList(
      listID: fields[0] as int,
    )..list = (fields[1] as List).cast<Task>();
  }

  @override
  void write(BinaryWriter writer, TaskList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.listID)
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
      taskID: fields[0] as int,
      taskName: fields[1] as String?,
      taskStatus: fields[2] as TaskStatus?,
      taskLabel: fields[3] as String?,
      taskDescription: fields[4] as String?,
    )
      ..taskDeadline = fields[5] as DateTime?
      .._clockList = (fields[6] as List)
          .map((dynamic e) => (e as List).cast<DateTime?>())
          .toList()
      ..totalTime_minutes = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.taskID)
      ..writeByte(1)
      ..write(obj.taskName)
      ..writeByte(2)
      ..write(obj.taskStatus)
      ..writeByte(3)
      ..write(obj.taskLabel)
      ..writeByte(4)
      ..write(obj.taskDescription)
      ..writeByte(5)
      ..write(obj.taskDeadline)
      ..writeByte(6)
      ..write(obj._clockList)
      ..writeByte(7)
      ..write(obj.totalTime_minutes);
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

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 1;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.TODO;
      case 1:
        return TaskStatus.DONE;
      default:
        return TaskStatus.TODO;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.TODO:
        writer.writeByte(0);
        break;
      case TaskStatus.DONE:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
