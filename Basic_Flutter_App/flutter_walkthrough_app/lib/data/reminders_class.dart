import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:isolate';
import 'package:test_app/data/tasklist_classes.dart';
import 'dart:async';
import 'dart:math';
import 'package:mutex/mutex.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:hive/hive.dart';

part 'reminders_class.g.dart';

/* 
needs to set/unset ongoing notification/alarm
needs to set/unset notification/alarm for a task
needs to set/unset pomodoro timer notification/alarm

purpose is to abstract away alarm id management
*/
@HiveType(typeId: 5)
class ReminderManager {
  @HiveField(0)
  final Map<int, Reminder> _alarmIDToReminder = Map<int, Reminder>();
  Map<int, Reminder> get alarmIDToReminder =>
      Map.unmodifiable(_alarmIDToReminder);

  @HiveField(1)
  final Map<int, Reminder> _notificationIDToReminder = Map<int, Reminder>();
  Map<int, Reminder> get notificationIDToReminder =>
      Map.unmodifiable(_notificationIDToReminder);

  @HiveField(2)
  final List<Reminder> _allReminders = [];
  List<Reminder> get allReminders => List.unmodifiable(_allReminders);

  @HiveField(3)
  final List<Reminder> _remindersWithPersistentNotifications = [];
  List<Reminder> get remindersWithPersistentNotifications =>
      List.unmodifiable(_remindersWithPersistentNotifications);

  @HiveField(4)
  final List<Reminder> _remindersWithEndNotifications = [];
  List<Reminder> get remindersWithEndNotifications =>
      List.unmodifiable(_remindersWithEndNotifications);

  @HiveField(5)
  final List<Reminder> _remindersWithAlarms = [];
  List<Reminder> get remindersWithAlarms =>
      List.unmodifiable(_remindersWithAlarms);

  final Mutex _notificationIDMutex = Mutex();
  final Mutex _alarmIDMutex = Mutex();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // it is important that it is <Reminder, Task> not <Task, Reminder>
  // Keys map to only one value, but one value can be associated with many keys
  // Each Reminder can only be associated with one task, while a Task can have multiple reminders
  final Map<Reminder, Task> _taskReminderMap = Map<Reminder, Task>();
  Map<Reminder, Task> get taskReminderMap => Map.unmodifiable(_taskReminderMap);

  Reminder createReminderForTimer(Duration dura,
      {bool persistentNotification = false,
      bool timerEndNotification = true,
      bool alarm = false,
      void Function()? timerCallback,
      void Function()? alarmCallback}) {
    return createReminderForDeadline(DateTime.now().add(dura),
        persistentNotification: persistentNotification,
        timerEndNotification: timerEndNotification,
        alarm: alarm,
        timerCallback: timerCallback,
        alarmCallback: alarmCallback);
  }

  Reminder createReminderForDeadline(DateTime deadline,
      {bool persistentNotification = false,
      bool timerEndNotification = true,
      bool alarm = false,
      void Function()? timerCallback,
      void Function()? alarmCallback}) {
    Reminder reminder = Reminder(DateTime.now(), deadline,
        timerCallback: genPrivateTimerCallback(timerCallback));

    _allReminders.add(reminder);

    if (persistentNotification) {
      _remindersWithPersistentNotifications.add(reminder);
      _showPersistentNotification(reminder);
    }
    if (timerEndNotification) {
      _remindersWithEndNotifications.add(reminder);
      _scheduleEndNotification(reminder, deadline);
    }
    if (alarm) {
      _remindersWithAlarms.add(reminder);
      _setAlarm(reminder, deadline, alarmCallback ?? () {});
    }
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

  void cancelReminder(Reminder reminder) async {
    // cancel the reminder timer
    reminder.killReminder();
    _allReminders.removeWhere((element) => identical(element, reminder));

    // CRITICAL SECTION
    await _notificationIDMutex.acquire();
    _notificationIDToReminder.forEach((key, value) {
      if (identical(value, reminder)) {
        flutterLocalNotificationsPlugin.cancel(key);
      }
    });
    _notificationIDToReminder
        .removeWhere((key, value) => identical(value, reminder));
    _notificationIDMutex.release();
    //

    // CRITICAL SECTION
    await _alarmIDMutex.acquire();
    _alarmIDToReminder.forEach((key, value) {
      if (identical(value, reminder)) {
        AndroidAlarmManager.cancel(key);
      }
    });
    _alarmIDToReminder.removeWhere((key, value) => identical(value, reminder));
    _alarmIDMutex.release();
    //

    _remindersWithPersistentNotifications
        .removeWhere((element) => identical(element, reminder));
    _remindersWithEndNotifications
        .removeWhere((element) => identical(element, reminder));
    _remindersWithAlarms.removeWhere((element) => identical(element, reminder));
  }

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
    this._taskReminderMap.removeWhere((key, value) => identical(value, task));
  }

  List<Reminder> getAllRemindersOfTask(Task task) {
    List<Reminder> list = [];
    this._taskReminderMap.forEach((key, value) {
      list.add(key);
    });
    return list;
  }

  Future<int> _findNextAvailableNotificationID() async {
    late final List<ActiveNotification> allNotifications;
    final List<int> existingNotificationIDs =
        _notificationIDToReminder.keys.toList();

    try {
      allNotifications =
          await (flutterLocalNotificationsPlugin.getActiveNotifications())
              .timeout(Duration(seconds: 1));
      allNotifications.forEach((element) {
        print("Existing notification id: ${element.id}");
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
    final int newKey = _alarmIDToReminder.isEmpty
        ? 0
        : _alarmIDToReminder.keys.reduce(max) + 1;

    return newKey;
  }

  void _showPersistentNotification(Reminder reminder) async {
    // CRITICAL SECTION
    await this._notificationIDMutex.acquire();
    final int newKey = await _findNextAvailableNotificationID();
    _notificationIDToReminder[newKey] = reminder;
    this._notificationIDMutex.release();
    //

    final Task? assignedTask = this._taskReminderMap[reminder];
    _showNotification(newKey,
        ongoing: true, title: assignedTask?.taskName, body: "Task Clock Open");
  }

  void _scheduleEndNotification(Reminder reminder, DateTime deadline) async {
    // CRITICAL SECTION
    await this._notificationIDMutex.acquire();
    final int newKey = await _findNextAvailableNotificationID();
    _notificationIDToReminder[newKey] = reminder;
    this._notificationIDMutex.release();
    //

    final Task? assignedTask = this._taskReminderMap[reminder];
    _showNotification(newKey,
        scheduleDeadline: deadline,
        title: assignedTask?.taskName,
        body: "Task Reminder");
  }

  void _setAlarm(
      Reminder reminder, DateTime deadline, Function alarmCallback) async {
    // CRITICAL SECTION
    await this._alarmIDMutex.acquire();
    final int newKey = await _findNextAvailableAlarmID();
    _alarmIDToReminder[newKey] = reminder;
    this._alarmIDMutex.release();
    //

    try {
      AndroidAlarmManager.oneShotAt(
              deadline, _findNextAvailableAlarmID(), alarmCallback)
          .timeout(Duration(seconds: 1));
    } on TimeoutException {
      print("Failed to set alarm: AndroidAlarmManager timed out");
    }
  }

  static Future<void> _showNotification(int id,
      {String? title,
      String? body,
      String? payload,
      DateTime? scheduleDeadline,
      bool ongoing = false}) async {
    print("Inside _showNotification, isolate=${Isolate.current.hashCode}");
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
      tz.initializeTimeZones();
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
@HiveType(typeId: 6)
class Reminder {
  @HiveField(0)
  late final DateTime _timerStartTime;
  DateTime get timerStartTime => _timerStartTime;

  @HiveField(1)
  late final DateTime _timerEndTime;
  DateTime get timerEndTime => _timerEndTime;

  Timer? timer;

  Duration get totalDuration => _timerEndTime.difference(_timerStartTime);
  Duration get remainingDuration => _timerEndTime.difference(DateTime.now());

  // think of this as a destructor
  // rather than relying on a finalizer, just explicitly kill the reminder timer
  void killReminder() {
    this.timer?.cancel();
  }

  // Hive can only generate type adapsters for zero-arg constructors, or constructors that initialize like: this.whatever
  Reminder(this._timerStartTime, this._timerEndTime,
      {void Function()? timerCallback}) {
    if (totalDuration.compareTo(Duration.zero) > 0) {
      timer = Timer(this.totalDuration, () {
        if (timerCallback != null) {
          print("Reminder callback fired");
          timerCallback();
        }
      });
    }
  }
}

/// Intended as a quick and dirty manual test to show some notifications
/// Just call this somewhere when the app is running
void testReminders() async {
  final reminderManager = ReminderManager();
  var reminder = reminderManager.createReminderForDeadline(
      DateTime.now().add(Duration(seconds: 5)),
      persistentNotification: true,
      alarm: true,
      alarmCallback: alarmCallback);

  var activeNotifications = await reminderManager
      .flutterLocalNotificationsPlugin
      .getActiveNotifications();
  print(activeNotifications);
  await Future.delayed(Duration(seconds: 10));
  reminderManager.cancelReminder(reminder);
}

@pragma('vm:entry-point')
void alarmCallback() {
  print("Inside alarmCallback");
}
