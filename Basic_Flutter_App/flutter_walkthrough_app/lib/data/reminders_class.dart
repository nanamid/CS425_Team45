import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_app/data/database.dart';
import 'dart:isolate';
import 'package:test_app/data/tasklist_classes.dart';
import 'dart:async';
import 'dart:math';
import 'package:mutex/mutex.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'reminders_class.g.dart';

/* 
needs to set/unset ongoing notification/alarm
needs to set/unset notification/alarm for a task
needs to set/unset pomodoro timer notification/alarm

purpose is to abstract away alarm id management
*/
@HiveType(typeId: 5)
class ReminderManager {
  /* All of the HiveFields are intended to be final
     but the way hive autogenerated typeadapters work
     requires them to be not final
  */
  // @HiveField(0) // Seems like we lose alarms in Android when the app dies, so there's no point to store this with hive
  Map<int, Reminder> _alarmIDToReminder = <int, Reminder>{};
  Map<int, Reminder> get alarmIDToReminder =>
      Map.unmodifiable(_alarmIDToReminder);

  // @HiveField(1) // Seems like we lose notifications too
  Map<int, Reminder> _notificationIDToReminder = <int, Reminder>{};
  Map<int, Reminder> get notificationIDToReminder =>
      Map.unmodifiable(_notificationIDToReminder);

  @HiveField(2)
  List<Reminder> _allReminders = <Reminder>[];
  List<Reminder> get allReminders => List.unmodifiable(_allReminders);

  @HiveField(3)
  List<Reminder> _remindersWithPersistentNotifications = <Reminder>[];
  List<Reminder> get remindersWithPersistentNotifications =>
      List.unmodifiable(_remindersWithPersistentNotifications);

  @HiveField(4)
  List<Reminder> _remindersWithEndNotifications = <Reminder>[];
  List<Reminder> get remindersWithEndNotifications =>
      List.unmodifiable(_remindersWithEndNotifications);

  @HiveField(5)
  List<Reminder> _remindersWithAlarms = <Reminder>[];
  List<Reminder> get remindersWithAlarms =>
      List.unmodifiable(_remindersWithAlarms);

  final Mutex _notificationIDMutex = Mutex();
  final Mutex _alarmIDMutex = Mutex();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // it is important that it is <Reminder, Task> not <Task, Reminder>
  // Keys map to only one value, but one value can be associated with many keys
  // Each Reminder can only be associated with one task, while a Task can have multiple reminders
  @HiveField(6)
  Map<Reminder, Task> _taskReminderMap = Map<Reminder, Task>();
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
      _setAlarm(reminder, deadline, alarmCallback ?? defaultAlarmCallback);
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
    unregisterReminderTask(reminder);
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
    this.cancelReminder(reminder);
  }

  void unregisterAllRemindersOfTask(Task task) {
    if (!this._taskReminderMap.values.contains(task)) {
      print('task has no reminders registered');
      return;
    }
    this._taskReminderMap.forEach((key, value) {
      if (identical(value, task)) {
        this.cancelReminder(key);
      }
    });
    this._taskReminderMap.removeWhere((key, value) => identical(value, task));
  }

  List<Reminder> getAllRemindersOfTask(Task task) {
    List<Reminder> list = [];
    this._taskReminderMap.forEach((key, value) {
      list.add(key);
    });
    return list;
  }

  // Hive returns a new instance of reminders, which means the maps and lists no longer work as intended
  void rebuildReminders(List<dynamic /*TaskList*/ > listOfTaskLists) {
    // We will use the reminder instances in _allReminders as the new 'master' reminders to make everything else line up
    // This is fragile and not at all an elegant solution
    // We know reminders are the same by value if they have the same uuid
    Map<Reminder, Task> tempMap = new Map.from(_taskReminderMap);
    _taskReminderMap.clear();
    for (final newReminder in _allReminders) {
      // _remindersWithPersistentNotifications
      for (int i = 0; i < _remindersWithPersistentNotifications.length; i++) {
        _remindersWithPersistentNotifications[i] = newReminder;
      }
      // _remindersWithEndNotifications
      for (int i = 0; i < _remindersWithEndNotifications.length; i++) {
        _remindersWithEndNotifications[i] = newReminder;
      }
      // _remindersWithAlarms
      for (int i = 0; i < _remindersWithAlarms.length; i++) {
        _remindersWithAlarms[i] = newReminder;
      }
      // _taskReminderMap fix reminders
      tempMap.forEach((oldReminder, oldTask) {
        if (oldReminder.reminderUUID == newReminder.reminderUUID) {
          _taskReminderMap[newReminder] = oldTask;
        }
      });
    }

    // _taskReminderMap fix tasks
    for (final tasklist in listOfTaskLists) {
      for (final newTask in tasklist.list) {
        _taskReminderMap.forEach((reminder, oldTask) {
          if (newTask.taskUUID == oldTask.taskUUID) {
            _taskReminderMap[reminder] = newTask;
          }
        });
      }
    }
  }

  Future<void> rebuildNotifications() async {
    // CRITICAL SECTION
    await _alarmIDMutex.acquire();
    _alarmIDToReminder.clear();
    _alarmIDMutex.release();
    //

    // CRITICAL SECTION
    await _notificationIDMutex.acquire();
    _notificationIDToReminder.clear();
    _notificationIDMutex.release();
    //

    int persistent = 0;
    int end = 0;
    int alarm = 0;
    int timer = 0;
    for (final reminder in _remindersWithPersistentNotifications) {
      _showPersistentNotification(reminder);
      persistent++;
    }
    for (final reminder in _remindersWithEndNotifications) {
      _scheduleEndNotification(reminder, reminder.timerEndTime);
      end++;
    }
    for (final reminder in _remindersWithAlarms) {
      _setAlarm(reminder, reminder.timerEndTime, defaultAlarmCallback);
      alarm++;
    }

    for (final reminder in _allReminders) {
      // TODO rebuild reminder timer callbacks
    }

    print(
        "Restored Notifications - Persistent: $persistent, End: $end, Alarm: $alarm, Timer: $timer");
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
    final int newKey;

    if (existingNotificationIDs.isEmpty) {
      newKey = 0;
    } else {
      int temp = 0;
      while (existingNotificationIDs.contains(temp)) {
        temp++;
      }
      newKey = temp;
    }

    return newKey;
  }

  _findNextAvailableAlarmID() {
    final int newKey;
    if (_alarmIDToReminder.isEmpty) {
      newKey = 0;
    } else {
      int temp = 0;
      while (_alarmIDToReminder.keys.contains(temp)) {
        temp++;
      }
      newKey = temp;
    }

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
    if (scheduleDeadline == null ||
        scheduleDeadline.compareTo(DateTime.now()) <= 0) {
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

  @HiveField(2)
  String? _reminderUUID;
  String? get reminderUUID => _reminderUUID;

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
    Uuid uuid = Uuid();
    _reminderUUID = uuid.v4();
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
      alarmCallback: defaultAlarmCallback);

  var activeNotifications = await reminderManager
      .flutterLocalNotificationsPlugin
      .getActiveNotifications();
  print(activeNotifications);
  await Future.delayed(Duration(seconds: 10));
  reminderManager.cancelReminder(reminder);
}

@pragma('vm:entry-point')
void defaultAlarmCallback() {
  print("Inside alarmCallback");
}
