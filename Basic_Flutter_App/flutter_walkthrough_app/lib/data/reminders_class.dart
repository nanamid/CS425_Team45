import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:isolate';
import 'package:test_app/data/tasklist_classes.dart';
import 'dart:async';
import 'dart:math';
import 'package:mutex/mutex.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/* 
needs to set/unset ongoing notification/alarm
needs to set/unset notification/alarm for a task
needs to set/unset pomodoro timer notification/alarm

purpose is to abstract away alarm id management
*/
class ReminderManager {
  final Map<int, Reminder> _alarmIDToReminder = Map<int, Reminder>();
  Map<int, Reminder> alarmIDToReminder = Map<int, Reminder>();

  final Map<int, Reminder> _notificationIDToReminder = Map<int, Reminder>();
  Map<int, Reminder> get notificationIDToReminder =>
      Map.unmodifiable(_notificationIDToReminder);

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

  final Mutex _notificationIDMutex = Mutex();

  // it is important that it is <Reminder, Task> not <Task, Reminder>
  // Keys map to only one value, but one value can be associated with many keys
  // Each Reminder can only be associated with one task, while a Task can have multiple reminders
  final Map<Reminder, Task> _taskReminderMap = Map<Reminder, Task>();
  Map<Reminder, Task> get taskReminderMap => Map.unmodifiable(_taskReminderMap);

  Reminder createReminderForTimer(Duration dura,
      {bool persistentNotification = false,
      bool timerEndNotification = true,
      void Function()? timerCallback,
      void Function()? alarmCallback}) {
    return createReminderForDeadline(DateTime.now().add(dura),
        persistentNotification: persistentNotification,
        timerEndNotification: timerEndNotification,
        timerCallback: timerCallback,
        alarmCallback: alarmCallback);
  }

  Reminder createReminderForDeadline(DateTime deadline,
      {bool persistentNotification = false,
      bool timerEndNotification = true,
      void Function()? timerCallback,
      void Function()? alarmCallback}) {
    Reminder reminder = Reminder(
        DateTime.now(), deadline, genPrivateTimerCallback(timerCallback));

    late void Function() privateAlarmCallback;

    // remember to set a notification in the callback here
    if (persistentNotification) {
      _remindersWithPersistentNotifications.add(reminder);
      _showPersistentNotification(reminder);
    }
    if (timerEndNotification) {
      _remindersWithEndNotifications.add(reminder);
      privateAlarmCallback = () {
        _showEndNotification(reminder);
        if (alarmCallback != null) {
          alarmCallback();
        }
      };

      try {
        AndroidAlarmManager.oneShotAt(
                deadline, _findNextAvailableAlarmID(), privateAlarmCallback)
            .timeout(Duration(seconds: 1));
      } on TimeoutException {
        print("Failed to set alarm: AndroidAlarmManager timed out");
      }
    }

    _allReminders.add(reminder);
    return reminder;
  }

  void Function() genPrivateTimerCallback(void Function()? timerCallback) {
    return () {
      print("inside Reminder->_privateTimerCallback");
      if (timerCallback != null) {
        timerCallback();
      }
    };
  }

  void cancelReminder(Reminder reminder) {}

  void registerTaskWithReminder(Reminder reminder, Task task) {
    if (this._taskReminderMap[reminder] != null) {
      print('reminder-task pair already mapped');
      return;
    }
    this._taskReminderMap[reminder] = task;
  }

  void unregisterReminderTask(Reminder reminder) {
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

  Future<int> _findNextAvailableNotificationID() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    late final List<ActiveNotification> allNotifications;
    final List<int> existingNotificationIDs =
        _notificationIDToReminder.keys.toList();

    try {
      allNotifications =
          await (flutterLocalNotificationsPlugin.getActiveNotifications())
              .timeout(Duration(seconds: 1));
      allNotifications.forEach((element) {
        existingNotificationIDs.add(element.id ?? -1);
      });
    } on TimeoutException {
      print(
          "Timed out waiting for LocalNotifications"); // this should only ever happen in tests (android not running)
      // rethrow;
    }

    // we still want this to run regardless of the timeout
    // would not conflict with a reminder in notificationIDToReminder.keys, but could possibly conflict with a notification created outside this class
    final int newKey = existingNotificationIDs.isEmpty
        ? 0
        : existingNotificationIDs.reduce(max) + 1;

    return newKey;
  }

  _findNextAvailableAlarmID() {
    final int newKey =
        alarmIDToReminder.isEmpty ? 0 : alarmIDToReminder.keys.reduce(max) + 1;

    return newKey;
  }

  void _showPersistentNotification(Reminder reminder) async {
    // CRITICAL SECTION
    await this._notificationIDMutex.acquire();
    final int newKey = await _findNextAvailableNotificationID();
    _notificationIDToReminder[newKey] = reminder;
    this._notificationIDMutex.release();
    //

    _showNotification(newKey, ongoing: true);
  }

  void _showEndNotification(Reminder reminder) async {
    // CRITICAL SECTION
    await this._notificationIDMutex.acquire();
    final int newKey = await _findNextAvailableNotificationID();
    _notificationIDToReminder[newKey] = reminder;
    this._notificationIDMutex.release();
    //
    _showNotification(newKey);
  }

  static Future<void> _showNotification(int id,
      {String? title,
      String? body,
      String? payload,
      DateTime? scheduleDeadline,
      bool ongoing = false}) async {
    print(
        "Inside _showOngoingNotification, isolate=${Isolate.current.hashCode}");
    // Initialize the notification plugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize settings for Android
    var android = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Define the notification details
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'testChannel',
      'testChannelName',
      channelDescription: 'testDescription',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      ongoing: ongoing,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    if (scheduleDeadline == null) {
      return flutterLocalNotificationsPlugin.show(
        id, // 1 is notification id for ongoing timer
        title ?? 'title',
        body ?? 'body',
        platformChannelSpecifics,
        payload: payload ?? 'payload',
      );
    } else if (scheduleDeadline != null) {
      return flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title ?? 'title',
          body ?? 'body',
          tz.TZDateTime.from(scheduleDeadline, tz.local),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime);
    }
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
  // rather than relying on a finalizer, just explicitly kill the reminder timer
  void killReminder() {
    this.timer.cancel();
  }

  Reminder(DateTime startTime, DateTime endTime, void Function() timerCallback)
      : this._timerStartTime = startTime,
        this._timerEndTime = endTime {
    timer = Timer(this.totalDuration, () {
      print("Reminder callback fired");
      timerCallback();
    });
  }
}
