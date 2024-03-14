import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:isolate';
import 'package:test_app/data/tasklist_classes.dart';

/* 
needs to set/unset ongoing notification/alarm
needs to set/unset notification/alarm for a task
needs to set/unset pomodoro timer notification/alarm

purpose is to abstract away alarm id management
*/
class ReminderManager {
  final List<int> _alarmIDs = [];
  List<int> get alarmIDs => List.unmodifiable(_alarmIDs);

  final List<Reminder> _remindersWithPersistentNotifications = [];
  List<Reminder> get remindersWithPersistentNotifications =>
      List.unmodifiable(_remindersWithPersistentNotifications);

  final List<Reminder> _remindersWithEndNotifications = [];
  List<Reminder> get remindersWithEndNotifications =>
      List.unmodifiable(_remindersWithEndNotifications);

  final List<Reminder> _remindersWithAlarms = [];
  List<Reminder> get remindersWithAlarms =>
      List.unmodifiable(_remindersWithAlarms);

  final Map<Task, Reminder> _taskReminderMap = Map<Task, Reminder>();
  Map<Task, Reminder> get taskReminderMap => Map.unmodifiable(_taskReminderMap);

  Reminder createReminderForTimer(Duration dura,
      {bool persistentNotification = false,
      bool timerEndNotification = true,
      bool alarm = true}) {
    Reminder reminder = Reminder(DateTime.now(), DateTime.now().add(dura));

    if (persistentNotification) {}
    if (timerEndNotification) {}
    if (alarm) {}

    return reminder;
  }

  Reminder createReminderForDeadline(DateTime deadline) {
    return Reminder(DateTime.now(), DateTime.now());
  }

  void cancelReminder(Reminder reminder) {}

  ReminderManager();
}

// all members should be immutable
class Reminder {
  final DateTime _timerStartTime;
  DateTime get timerStartTime => _timerStartTime;

  final DateTime _timerEndTime;
  DateTime get timerEndTime => _timerEndTime;

  Reminder(DateTime startTime, DateTime endTime)
      : this._timerStartTime = startTime,
        this._timerEndTime = endTime;
}
