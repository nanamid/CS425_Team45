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
  String?
      _listUUID; // This really should be a late final String, but hive had problems // TODO fix this
  String? get listUUID => _listUUID;

  @HiveField(1)
  final String? listName;

  @HiveField(2)
  List<Task> _list = <Task>[];
  List<Task> get list => List.unmodifiable(
      _list); // the list itself is unmodifiable, but the tasks inside should be modifiable

  bool addTask(Task newTask) {
    if (_list.where((task) => task == newTask).isNotEmpty) {
      print("Couldn't add task, child already exists");
      return false;
    }
    _list.add(newTask);
    print("Added Task UUID: ${newTask.taskUUID}");
    return true;
  }

  bool removeTask(Task removedTask) {
    bool result = _list.remove(removedTask);
    if (result == false) {
      print("Could not remove task");
    }
    return result;
  }

  TaskList({this.listName}) {
    Uuid uuid = Uuid();
    _listUUID = uuid.v4(); // generates a v4 (random) uuid
  }
}

// IE. TODO, DONE, WAIT
@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  TODO,

  @HiveField(1)
  DONE,

  @HiveField(2)
  WAIT,
}

// Task
@HiveType(typeId: 2)
class Task {
  // @HiveField(0, defaultValue: "-1")
  @HiveField(0)
  String? _taskUUID;
  String? get taskUUID => _taskUUID;

  @HiveField(1, defaultValue: "none")
  String taskName;

  @HiveField(2, defaultValue: TaskStatus.TODO)
  TaskStatus taskStatus;

  @HiveField(3, defaultValue: "none")
  String? taskLabel;

  @HiveField(4, defaultValue: "none")
  String? taskDescription;

  // @HiveField(5, defaultValue: DateTime(0))
  @HiveField(5) // requires defaultValue to be const, which DateTime isn't
  DateTime? _taskDeadline; // has to be set alongside an alarm

  @HiveField(6)
  List<DateTime> _taskReminders = []; // has to be set alongside an alarm

  @HiveField(7)
  List<List<DateTime?>> clockList = // TODO make private?
      []; // intended as mutable list of mutable [DateTime, DateTime?]

  @HiveField(8)
  int totalTime_minutes = 0; // 0
  int totalTime_secs = 0; // for testing

  @HiveField(9)
  bool _clockRunning = false;
  bool get clockRunning => _clockRunning; // allow read but no write

  @HiveField(10)
  List<Task> taskSubtasks = [];

  @HiveField(11)
  Task? taskParentTask;

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

  /// set a task to be child of this task
  bool setSubTask(Task newChild) {
    if (taskSubtasks.where((task) => task == newChild).isNotEmpty) {
      print("Couldn't add sub task, child already exists");
      return false;
    }
    if (identical(this, newChild))
    {
      print("Couldn't add subtask, is itself");
      return false;
    }
    newChild.taskParentTask = this;
    taskSubtasks.add(newChild);
    return true;
  }

  /// Separate a child from this parent task
  bool unsetSubTask(Task separatedChild) {
    if (taskSubtasks.where((task) => task == separatedChild).isEmpty) {
      print("Couldn't separate child from parent, task not a child");
      return false;
    }
    separatedChild.taskParentTask = this.taskParentTask;
    taskSubtasks.remove(separatedChild);
    return true;
  }

  Task({
    required this.taskName,
    this.taskStatus = TaskStatus.TODO,
    this.taskLabel,
    this.taskDescription,
    // deadline, reminders, clocklist, subtasks, parenttask set with methods
  }) {
    Uuid uuid = Uuid();
    _taskUUID = uuid.v4();
  }
}

// TODO instead of a list of lists, how about a timestamp pair class?