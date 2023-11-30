// TODO annotate these so hive can store the fields

class TaskList {
  final int listID;
  List<Task> list = <Task>[];

  TaskList({
    required this.listID,
  });
}

enum TaskStatus {
  TODO,
  DONE,
}

class Task {
  final int taskID;
  String? taskName;
  TaskStatus? taskStatus;
  String? taskLabel;
  // timestamp deadline;
  String? description;
  // also need time clock entries and total

  Task({
    required this.taskID,
    this.taskName,
    this.taskLabel,
    this.description,
    // TODO timeclock stuff
  });
}
