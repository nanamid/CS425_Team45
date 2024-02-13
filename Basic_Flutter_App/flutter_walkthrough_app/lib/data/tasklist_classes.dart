import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'tasklist_classes.g.dart'; // automatic generator, through the magic of dart and hive, this gets built
// try first a: `dart run build_runner build`
// if it still has problems uninstall the app (deletes the database) and `flutter clean`
// the @HiveType(typeId: 0) annotations tell Hive what fields to store, the rest are not saved

// TaskList: list of tasks
@HiveType(typeId: 0)
class TaskList {
  @HiveField(0)
  late final String _listUUID;
  String get listUUID => _listUUID;

  @HiveField(1)
  List<Task> list = <Task>[];

  TaskList()
  {
    Uuid uuid = Uuid();
    _listUUID = uuid.v4(); // generates a v4 (random) uuid
  }
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
  @HiveField(0, defaultValue: "-1")
  late final String _taskUUID;
  String get taskUUID => _taskUUID;

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

  @HiveField(8)
  bool _clockRunning = false;
  bool get clockRunning => _clockRunning; // allow read but no write

  /// adds a clock entry to the task structure
  /// returns false when cannot add entry, like when a clock is already open.
  bool clockIn() {
    try {
      if (clockList.isNotEmpty && _clockRunning == true) {
        throw Exception(
            'clockList not empty. clockList.isEmpty: ${clockList.isEmpty}, _clockRunning: $_clockRunning');
      }
    } catch (e) {
      print('Cannot clock in: $e');
      return false;
    }

    assert(clockList.isEmpty ||
        (clockList.last[0] != null &&
            clockList.last[1] != null)); // No previously open timeclock

    clockList.add([DateTime.now(), null]);
    _clockRunning = true;
    print("Clocked in at ${clockList.last[0]}");
    return true;
  }

  /// completes a clock entry on the task structure
  /// returns false when cannot add entry, like when a clock is not open.
  bool clockOut() {
    try {
      if (clockList.isEmpty || _clockRunning == false) {
        throw Exception(
            'no active clock. clockList.isEmpty: ${clockList.isEmpty}, _clockRunning: $_clockRunning');
      }
    } catch (e) {
      print('Cannot clock in: $e');
      return false;
    }

    assert(clockList.last[1] == null);

    clockList.last[1] = DateTime.now();
    _clockRunning = false;
    print("Clocked out at ${clockList.last[1]}");
    totalTime_minutes += (clockList.last[1]!.difference(clockList.last[0]!))
        .inSeconds; // TODO change this back to minutes after the demo
    totalTime_secs +=
        (clockList.last[1]!.difference(clockList.last[0]!)).inSeconds;
    print("totalTime = $totalTime_minutes ($totalTime_secs secs)");
    return true;
  }

  Task({
    this.taskName,
    this.taskStatus = "TODO",
    this.taskLabel,
    this.taskDescription,
    // timeclocks not set in constructor
  })
  {
    Uuid uuid = Uuid();
    _taskUUID = uuid.v4();
  }
}

// TODO instead of a list of lists, how about a timestamp pair class?