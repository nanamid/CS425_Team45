//CODE modified from Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/duration_adapter.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
import 'package:test_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_app/navigation_menu.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:test_app/utils/device/device_utility.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/reminders_class.dart';

void main() async {
  // Initialize the Hive
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  // all custom objects need an adapter for hive to store them
  Hive.registerAdapter(TaskListAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskLabelAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PomodoroTimerAdapter());
  Hive.registerAdapter(ReminderManagerAdapter());
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(DurationAdapter());

  // Open the box named 'taskbox'
  // This allows you to use Hive.box('taskbox') elsewhere
  var taskbox = await Hive.openBox('taskbox');
  TodoDatabase db = TodoDatabase();
  if (taskbox.get("TASK_LIST") == null || taskbox.get("TASK_LIST").isEmpty) {
    await db.createInitialTasklist();
  }
  if (taskbox.get("REMINDER_MANAGER") == null) {
    await db.createInitialReminderManager();
  }
  if (taskbox.get("POMODORO_TIMER") == null) {
    await db.createInitialPomodoroTimer();
  }
  //Done when data already exists
  db.loadData();

  /* Restore task subtasks parent-child relationship */
  for (final TaskList taskList in db.listOfTaskLists) {
    taskList.rebuildSubtasks();
  }

  /* Restore notifications and alarms if the app died before they fired
     There should be no harm in doing this to an empty reminderManager
     So we call it unconditionally */
  db.reminderManager.rebuildReminders(db.listOfTaskLists);
  await db.reminderManager.rebuildNotifications();

  // same reason as rebuildReminders
  db.pomodoroTimer.rebuild();

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Run the App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar text color to white
    AppDeviceUtils.setStatusBarColor(Colors.white);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationMenu(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.light),
      ),
    );
  }
}
