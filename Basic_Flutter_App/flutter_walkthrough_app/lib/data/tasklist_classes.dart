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

// enum TaskStatus {
//   @HiveField(0)
//   TODO,

//   @HiveField(1)
//   DONE,
// }

@HiveType(typeId: 1)
class TaskStatus {
  @HiveField(0)
  final String _status;
  TaskStatus() : _status = "-"; // no status
  TaskStatus.TODO() : _status = "TODO";
  TaskStatus.DONE() : _status = "DONE";
  TaskStatus.WAIT() : _status = "WAIT";
  
  @override
  String toString() {
    return _status;
  }
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

  @HiveField(5)
  DateTime? taskDeadline;

  @HiveField(6)
  List<List<DateTime?>> _clockList =
      []; // intended as mutable list of mutable [DateTime, DateTime?]

  @HiveField(7)
  int totalTime_minutes = 0; // 0
  int totalTime_secs = 0; // for testing

  void clockIn() {
    assert(_clockList.isEmpty ||
        (_clockList.last[0] != null &&
            _clockList.last[1] != null)); // No previously open timeclock
    _clockList.add([DateTime.now(), null]);
    print("Clocked in at ${_clockList.last[0]}");
  }

  void clockOut() {
    assert(_clockList.last[1] == null);
    _clockList.last[1] = DateTime.now();
    print("Clocked out at ${_clockList.last[1]}");
    totalTime_minutes += (_clockList.last[1]!.difference(_clockList.last[0]!)).inSeconds; // TODO change this back to minutes
    totalTime_secs += (_clockList.last[1]!.difference(_clockList.last[0]!)).inSeconds;
    print("totalTime = $totalTime_minutes ($totalTime_secs secs)");
  }

  Task({
    required this.taskID,
    this.taskName,
    this.taskStatus,
    this.taskLabel,
    this.taskDescription,
    // timeclocks not set in constructor
  });
}

// TODO instead of a list of lists, how about a timestamp pair class?