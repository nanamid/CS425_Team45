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
      listName: fields[1] as String?,
    )
      .._listUUID = fields[0] as String
      .._list = (fields[2] as List).cast<Task>();
  }

  @override
  void write(BinaryWriter writer, TaskList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._listUUID)
      ..writeByte(1)
      ..write(obj.listName)
      ..writeByte(2)
      ..write(obj._list);
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
      taskName: fields[1] == null ? 'none' : fields[1] as String,
      taskStatus: fields[2] == null ? TaskStatus.TODO : fields[2] as TaskStatus,
      taskLabel: fields[3] == null ? 'none' : fields[3] as String?,
      taskDescription: fields[4] == null ? 'none' : fields[4] as String?,
    )
      .._taskUUID = fields[0] as String?
      .._taskDeadline = fields[5] as DateTime?
      .._taskReminders = (fields[6] as List).cast<DateTime>()
      ..clockList = (fields[7] as List)
          .map((dynamic e) => (e as List).cast<DateTime?>())
          .toList()
      ..totalTime_minutes = fields[8] as int
      .._clockRunning = fields[9] as bool
      ..taskSubtasks = (fields[10] as List).cast<Task>()
      ..taskParentTask = fields[11] as Task?;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(12)
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
      ..writeByte(5)
      ..write(obj._taskDeadline)
      ..writeByte(6)
      ..write(obj._taskReminders)
      ..writeByte(7)
      ..write(obj.clockList)
      ..writeByte(8)
      ..write(obj.totalTime_minutes)
      ..writeByte(9)
      ..write(obj._clockRunning)
      ..writeByte(10)
      ..write(obj.taskSubtasks)
      ..writeByte(11)
      ..write(obj.taskParentTask);
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
      case 2:
        return TaskStatus.WAIT;
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
      case TaskStatus.WAIT:
        writer.writeByte(2);
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
