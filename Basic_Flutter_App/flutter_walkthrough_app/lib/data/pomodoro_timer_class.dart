import 'package:hive/hive.dart';
import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:isolate';

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

  @HiveField(4)
  Duration remaningTime;

  late Timer _nativeTimer;

  int _alarmID = 0;

  Function()? userTimerCallback;


  void _privateTimerCallback() {
    print("Inside private timer callback");
    clearTimer();
    if (userTimerCallback != null) {
      userTimerCallback!();
    }
  }

  @pragma('vm:entry-point')
  static void _alarmCallback() {
    print("Inside alarmCallback");
    showNotification();
  }

  void startTimer() async {
    if (_timerIsRunning) {
      print('Tried to start already running timer');
      return;
    }

    _timerStartTime = DateTime.now();
    _timerEndTime = _timerStartTime!.add(remaningTime);
    _nativeTimer = Timer(remaningTime, _privateTimerCallback);
    _timerIsRunning = true;
    await AndroidAlarmManager.oneShot(remaningTime, _alarmID, _alarmCallback);
    showOngoingNotification();
    task?.clockIn();
    print('Started Pomodoro Timer');
  }

  // Save the time in the timer.
  void stopTimer() {
    if (_timerIsRunning == false) {
      print('Tried to stop timer that was not running');
      return;
    }
    _nativeTimer.cancel();
    AndroidAlarmManager.cancel(_alarmID);
    _timerIsRunning = false;
    remaningTime = _timerEndTime!.difference(DateTime.now());
    _timerStartTime = null;
    _timerEndTime = null;
    
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancelAll();
    task?.clockOut();
    print('Stopped Pomodoro Timer');
  }

  Duration clearTimer() {
    if (_timerIsRunning) {
      stopTimer();
    }
    Duration temp = remaningTime;
    remaningTime = duration;
    return temp;
  }

  Duration getRemainingTime() {
    if (_timerIsRunning == true && _timerEndTime != null) {
      return _timerEndTime!.difference(DateTime.now());
    } else {
      return remaningTime;
    }
  }

  static void showNotification() async {
    print("Inside showNotification, isolate=${Isolate.current.hashCode}");
    // Initialize the notification plugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize settings for Android
    var android = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Define the notification details
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'pomodoro timer alarm',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0, // 0 is notification id for final task reminder notification
      'Reminder',
      'It\'s time for your task!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  /// shows an ongoing (persistent notification)
  static void showOngoingNotification() async {
    print("Inside showNotification, isolate=${Isolate.current.hashCode}");
    // Initialize the notification plugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize settings for Android
    var android = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Define the notification details
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'pomodoro timer ongoing',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      ongoing: true,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      1, // 1 is notification id for ongoing timer
      'Timer Running',
      'You Have a Timer Running',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  PomodoroTimer({required this.duration, this.userTimerCallback})
      : remaningTime = duration;
}
