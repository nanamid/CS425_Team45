// TODO annotate these so hive can store the fields
import 'package:hive/hive.dart';

part 'tasklist_classes.g.dart';

@HiveType(typeId: 0)
class TaskList {
  @HiveField(0)
  final int listID; // 0 is default tasklist, otherwise TODO make this a uuid

  @HiveField(1)
  List<Task> list = <Task>[];

  TaskList({
    required this.listID,
  });
}

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  TODO,

  @HiveField(1)
  DONE,
}

@HiveType(typeId: 2)
class Task {
  @HiveField(0)
  final int taskID; // TODO make this a uuid

  @HiveField(1)
  String? taskName;

  @HiveField(2)
  TaskStatus? taskStatus;

  @HiveField(3)
  String? taskLabel;

  @HiveField(4)
  String? taskDescription;

  // timestamp deadline;
  // @HiveField(5)
  // also need time clock entries and total
  // @HiveField 6, 7, 8

  Task({
    required this.taskID,
    this.taskName,
    this.taskStatus,
    this.taskLabel,
    this.taskDescription,
    // TODO timeclock stuff
  });
}

// TODO timestamp class: list of timestamp pairs