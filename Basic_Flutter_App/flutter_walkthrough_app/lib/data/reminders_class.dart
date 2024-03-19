import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:isolate';
import 'package:test_app/data/tasklist_classes.dart';
import 'dart:async';

/* 
needs to set/unset ongoing notification/alarm
needs to set/unset notification/alarm for a task
needs to set/unset pomodoro timer notification/alarm

purpose is to abstract away alarm id management
*/
class ReminderManager {
  final List<int> _alarmIDs = [];
  List<int> get alarmIDs => List.unmodifiable(_alarmIDs);

  final List<Reminder> _allReminders = [];
  List<Reminder> get allReminders => List.unmodifiable(_allReminders);

  final List<Reminder> _remindersWithPersistentNotifications = [];
  List<Reminder> get remindersWithPersistentNotifications =>
      List.unmodifiable(_remindersWithPersistentNotifications);

  final List<Reminder> _remindersWithEndNotifications = [];
  List<Reminder> get remindersWithEndNotifications =>
      List.unmodifiable(_remindersWithEndNotifications);

  final List<Reminder> _remindersWithAlarms = [];
  List<Reminder> get remindersWithAlarms =>
      List.unmodifiable(_remindersWithAlarms);

  // it is important that it is <Reminder, Task> not <Task, Reminder>
  // Keys map to only one value, but one value can be associated with many keys
  // Each Reminder can only be associated with one task, while a Task can have multiple reminders
  final Map<Reminder, Task> _taskReminderMap = Map<Reminder, Task>();
  Map<Reminder, Task> get taskReminderMap => Map.unmodifiable(_taskReminderMap);

  Reminder createReminderForTimer(Duration dura,
      {bool persistentNotification = false,
      bool timerEndNotification = true,
      bool alarm = true}) {
    Reminder reminder = Reminder(DateTime.now(), DateTime.now().add(dura), (){});

    if (persistentNotification) {}
    if (timerEndNotification) {}
    if (alarm) {}

    _allReminders.add(reminder);
    return reminder;
  }

  Reminder createReminderForDeadline(DateTime deadline) {
    Reminder reminder = Reminder(DateTime.now(), deadline, (){});
    _allReminders.add(reminder);
    return reminder;
  }

  void cancelReminder(Reminder reminder) {}

  void registerTaskWithReminder(Reminder reminder, Task task) {
    if (this._taskReminderMap[reminder] != null) {
      print('reminder-task pair already mapped');
      return;
    }
    this._taskReminderMap[reminder] = task;
  }

  void unregisterReminder(Reminder reminder) {
    if (this._taskReminderMap[reminder] == null) {
      print('reminder-task pair does not exist');
      return;
    }
    this._taskReminderMap.remove(reminder);
  }

  void unregisterAllRemindersOfTask(Task task) {
    if (!this._taskReminderMap.values.contains(task)) {
      print('task has no reminders registered');
      return;
    }
    this._taskReminderMap.removeWhere((key, value) => value == task);
  }

  List<Reminder> getAllRemindersOfTask(Task task) {
    List<Reminder> list = [];
    this._taskReminderMap.forEach((key, value) {
      list.add(key);
    });
    return list;
  }

  ReminderManager();
}

// all members should be immutable
class Reminder {
  final DateTime _timerStartTime;
  DateTime get timerStartTime => _timerStartTime;

  final DateTime _timerEndTime;
  DateTime get timerEndTime => _timerEndTime;

  late final Timer timer;

  Duration get totalDuration => _timerEndTime.difference(_timerStartTime);
  Duration get remainingDuration => _timerEndTime.difference(DateTime.now());

  // think of this as a destructor
  // rather than relying on a finalizer, just explicitly kill the reminder
  void killReminder()
  {
    this.timer.cancel();
  }

  Reminder(DateTime startTime, DateTime endTime, void Function() callback)
      : this._timerStartTime = startTime,
        this._timerEndTime = endTime {
    timer = Timer(this.totalDuration, () {
      print("Reminder callback fired");
      callback();
    });
  }
}
