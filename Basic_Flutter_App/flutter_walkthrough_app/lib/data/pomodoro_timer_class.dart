import 'package:hive/hive.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/reminders_class.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'pomodoro_timer_class.g.dart'; // automatic generator, through the magic of dart and hive, this gets built
// try first a: `dart run build_runner build`
// if it still has problems uninstall the app (deletes the database) and `flutter clean`
// the @HiveType(typeId: 0) annotations tell Hive what fields to store, the rest are not saved

@HiveType(typeId: 4)
class PomodoroTimer {
  @HiveField(0)
  Duration duration;

  @HiveField(1)
  bool _timerIsRunning = false;
  bool get timerIsRunning => _timerIsRunning;

  @HiveField(2)
  DateTime? _timerStartTime;
  DateTime? get timerStartTime => _timerStartTime;

  @HiveField(3)
  DateTime? _timerEndTime;
  DateTime? get timerEndTime => _timerEndTime;

  /// How much time was left on the clock from last time
  ///
  /// This is not how much time is currently remaining when the timer is
  /// running, use getRemainingTime() for that
  @HiveField(4)
  Duration remainingTime;

  // The pomodoro timer is really just a glorified task, which we use to track its associated reminders in reminderManager
  @HiveField(5)
  Task internalTask = Task(taskName: "Pomodoro Timer");

  @HiveField(6)
  int numberOfTomatoes;

  @HiveField(7)
  bool onBreak = false;

  @HiveField(8)
  Task? associatedTask;

  static const Duration pomodoroLength = Duration(minutes: 25);
  static const Duration shortBreakTimeLength = Duration(minutes: 10);
  static const Duration longBreakTimeLength = Duration(minutes: 30);

  void startTimer() {
    if (_timerIsRunning) {
      print('Tried to start already running timer');
      return;
    }

    _timerStartTime = DateTime.now();
    _timerEndTime = _timerStartTime!.add(remainingTime);
    _timerIsRunning = true;

    TodoDatabase db = TodoDatabase();
    db.loadData();
    Reminder reminder = db.reminderManager.createReminderForDeadline(
        _timerEndTime!,
        persistentNotification: true,
        timerEndNotification: true, timerCallback: () {
      stopTimer();
      takeBreak();
    });
    db.reminderManager.registerTaskWithReminder(reminder, internalTask);

    associatedTask?.clockIn();

    db.updateDatabase();
    print('Started Pomodoro Timer');
  }

  // Save the time in the timer.
  void stopTimer() {
    if (_timerIsRunning == false) {
      print('Tried to stop timer that was not running');
      return;
    }
    _timerIsRunning = false;
    remainingTime = _timerEndTime!.difference(DateTime.now());
    _timerStartTime = null;
    _timerEndTime = null;

    TodoDatabase db = TodoDatabase();
    db.loadData();
    db.reminderManager.unregisterAllRemindersOfTask(internalTask);

    associatedTask?.clockOut();

    db.updateDatabase();
    print('Stopped Pomodoro Timer');
  }

  // reset the timer
  Duration clearTimer() {
    if (_timerIsRunning) {
      stopTimer();
    }
    Duration temp = remainingTime;
    remainingTime = duration;
    return temp;
  }

  Duration getRemainingTime() {
    if (_timerIsRunning == true && _timerEndTime != null) {
      return _timerEndTime!.difference(DateTime.now());
    } else {
      return remainingTime;
    }
  }

  /* Like startTimer() but checks the number of pomodoro iterations (tomatoes)
     and does not clock in on the task */
  void takeBreak() {
    numberOfTomatoes++;
    onBreak = true;
    associatedTask?.clockOut();

    _timerStartTime = DateTime.now();
    if (numberOfTomatoes != 0 && numberOfTomatoes % 4 == 0) {
      _timerEndTime = _timerStartTime!.add(longBreakTimeLength);
    } else {
      _timerEndTime = _timerStartTime!.add(shortBreakTimeLength);
    }

    _timerIsRunning = true;

    TodoDatabase db = TodoDatabase();
    db.loadData();
    db.reminderManager.createReminderForDeadline(_timerEndTime!,
        persistentNotification: true,
        timerEndNotification: true, timerCallback: () {
      stopTimer();
      this.remainingTime = pomodoroLength;
      startTimer();
    });

    db.updateDatabase();
    print('Started Pomodoro Timer');
  }

  /// Once again, since hive constructs new instances of every object, this.internalTask
  /// does not reference the task in the ReminderManager correctly. We reassociate based
  /// on uuid.
  ///
  /// intended to follow a call to ReminderManager.rebuildReminders
  Future<void> rebuild() async {
    TodoDatabase db = TodoDatabase();
    db.loadData();
    if (_timerIsRunning == true &&
        db.reminderManager.taskReminderMap.values.contains(this.internalTask) ==
            false) // we had a timer running but the reminder manager is missing our internal task, we have to reassociate with the task in hive
    {
      List<Reminder> newReminders =
          []; // list of reminders that match internalTask's uuid (should only be 1?)
      db.reminderManager.taskReminderMap.forEach((reminder, task) {
        if (task.taskUUID == this.internalTask.taskUUID) {
          newReminders.add(reminder);
        }
      });
      // for (final newReminder in newReminders) {
      //   db.reminderManager.taskReminderMap.forEach((_, task) {
      //     if (!identical(
      //         db.reminderManager.taskReminderMap[newReminder], task)) {
      //       print(
      //           "old pomodoro timer reminder-task associations are actually different. This is likely not what you expected.");
      //     }
      //   });
      // }
      if (newReminders.isEmpty) {
        print("No old pomodoro timer task, despite _timerIsRunning == true");
      } else {
        this.internalTask =
            db.reminderManager.taskReminderMap[newReminders[0]]!;
      }
      await db.updateDatabase();
    } else if (_timerIsRunning == false) {
      print(
          "Tried to reassociate the pomodoro timer internal task when it was already in reminder manager");
    }

    // we need to do the same for the associated task
    for (final tasklist in db.listOfTaskLists) {
      for (final newTask in tasklist.list) {
        if (newTask.taskUUID == this.associatedTask?.taskUUID) {
          this.associatedTask = newTask;
        }
      }
    }
    await db.updateDatabase();
  }

  PomodoroTimer({this.associatedTask, this.numberOfTomatoes = 0})
      : this.duration = pomodoroLength,
        this.remainingTime = pomodoroLength;
}
