import 'package:hive/hive.dart';

part 'tasklist_classes.g.dart'; // automatic generator, through the magic of dart and hive, this gets built
// if it has problems, a cleaning can help `flutter clean`
// the @HiveType(typeId: 0) annotations tell Hive what fields to store, the rest are not saved

// TaskList: list of tasks
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

// TODO make a type for allowed values in the TaskStatus field
// IE. TODO, DONE, WAIT
// An enum worked the way I wanted, but Hive couldn't store it

// enum TaskStatus {
//   @HiveField(0)
//   TODO,

//   @HiveField(1)
//   DONE,
// }

// This gave Hive trouble for some reason
// @HiveType(typeId: 1)
// class TaskStatus {
//   @HiveField(0, defaultValue: "-")
//   final String _status;

//   const TaskStatus() : _status = "-"; // no status
//   const TaskStatus.TODO() : _status = "TODO";
//   const TaskStatus.DONE() : _status = "DONE";
//   const TaskStatus.WAIT() : _status = "WAIT";

//   @override
//   String toString() {
//     return _status;
//   }
// }

// Task
@HiveType(typeId: 2)
class Task {
  @HiveField(0, defaultValue: -1)
  final int taskID; // TODO make this a uuid

  @HiveField(1, defaultValue: "none")
  String? taskName;

  @HiveField(2) // default is TODO, set in constructor
  String taskStatus; // TODO should be TaskStatus object

  @HiveField(3, defaultValue: "none")
  String? taskLabel;

  @HiveField(4, defaultValue: "none")
  String? taskDescription;

  // @HiveField(5, defaultValue: )
  // DateTime? taskDeadline;

  @HiveField(6)
  List<List<DateTime?>> clockList = // TODO make private?
      []; // intended as mutable list of mutable [DateTime, DateTime?]

  @HiveField(7)
  int totalTime_minutes = 0; // 0
  int totalTime_secs = 0; // for testing

  void clockIn() {
    assert(clockList.isEmpty ||
        (clockList.last[0] != null &&
            clockList.last[1] != null)); // No previously open timeclock
    clockList.add([DateTime.now(), null]);
    print("Clocked in at ${clockList.last[0]}");
  }

  void clockOut() {
    assert(clockList.last[1] == null);
    clockList.last[1] = DateTime.now();
    print("Clocked out at ${clockList.last[1]}");
    totalTime_minutes += (clockList.last[1]!.difference(clockList.last[0]!))
        .inSeconds; // TODO change this back to minutes
    totalTime_secs +=
        (clockList.last[1]!.difference(clockList.last[0]!)).inSeconds;
    print("totalTime = $totalTime_minutes ($totalTime_secs secs)");
  }

  Task({
    required this.taskID,
    this.taskName,
    this.taskStatus = "TODO",
    this.taskLabel,
    this.taskDescription,
    // timeclocks not set in constructor
  });
}

// TODO instead of a list of lists, how about a timestamp pair class?