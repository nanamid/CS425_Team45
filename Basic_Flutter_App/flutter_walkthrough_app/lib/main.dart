//CODE modified from Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
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
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PomodoroTimerAdapter());

  // Open the box named 'taskbox'
  // This allows you to use Hive.box('taskbox') elsewhere
  var taskbox = await Hive.openBox('taskbox');

  //Run the App
  runApp(const MyApp());
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