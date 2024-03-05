//CODE modified from Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/tasks_page.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  //Initialize the Hive
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  // all custom objects need an adapter for hive to store them
  Hive.registerAdapter(TaskListAdapter());
  // Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskAdapter());

  // Open the box named 'taskbox'
  // This allows you to use Hive.box('taskbox') elsewhere
  var taskbox = await Hive.openBox('taskbox');

  //Run the App
  runApp(const MyApp());

  DateTime alarmTime = DateTime.now().add(Duration(seconds: 10));
  print("Alarm 10 secs from now");
  await AndroidAlarmManager.oneShotAt(
    alarmTime,
    0, // Unique ID for the alarm
    alarmCallback,
    wakeup: true,
    exact: true,
    alarmClock: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.light),
      ),
    );
  }
}

@pragma('vm:entry-point')
void alarmCallback() {
  print("Inside alarmCallback");
  showNotification();
}

void showNotification() async {
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
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Show the notification
  await flutterLocalNotificationsPlugin.show(
    0,
    'Reminder',
    'It\'s time for your task!',
    platformChannelSpecifics,
    payload: 'item x',
  );
}
