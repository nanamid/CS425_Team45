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
      .._listUUID = fields[0] as String?
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
      taskName: fields[1] == null ? 'Default Task' : fields[1] as String,
      taskLabel: fields[3] == null ? TaskLabel.Default : fields[3] as TaskLabel,
      taskDescription:
          fields[4] == null ? 'Default Description' : fields[4] as String?,
      taskDeadline: fields[5] as DateTime?,
    )
      .._taskUUID = fields[0] as String?
      .._taskStatus =
          fields[2] == null ? TaskStatus.TODO : fields[2] as TaskStatus
      ..clockList = (fields[7] as List)
          .map((dynamic e) => (e as List).cast<DateTime?>())
          .toList()
      ..totalTime_minutes = fields[8] as int
      .._clockRunning = fields[9] as bool
      ..taskParentTask = fields[11] as Task?;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj._taskUUID)
      ..writeByte(1)
      ..write(obj.taskName)
      ..writeByte(2)
      ..write(obj._taskStatus)
      ..writeByte(3)
      ..write(obj.taskLabel)
      ..writeByte(4)
      ..write(obj.taskDescription)
      ..writeByte(5)
      ..write(obj.taskDeadline)
      ..writeByte(7)
      ..write(obj.clockList)
      ..writeByte(8)
      ..write(obj.totalTime_minutes)
      ..writeByte(9)
      ..write(obj._clockRunning)
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

class TaskLabelAdapter extends TypeAdapter<TaskLabel> {
  @override
  final int typeId = 3;

  @override
  TaskLabel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskLabel.Study;
      case 1:
        return TaskLabel.Homework;
      case 2:
        return TaskLabel.Project;
      case 3:
        return TaskLabel.Programming;
      case 4:
        return TaskLabel.Default;
      default:
        return TaskLabel.Study;
    }
  }

  @override
  void write(BinaryWriter writer, TaskLabel obj) {
    switch (obj) {
      case TaskLabel.Study:
        writer.writeByte(0);
        break;
      case TaskLabel.Homework:
        writer.writeByte(1);
        break;
      case TaskLabel.Project:
        writer.writeByte(2);
        break;
      case TaskLabel.Programming:
        writer.writeByte(3);
        break;
      case TaskLabel.Default:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskLabelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
