//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/data/tasklist_classes.dart';

void main() async {
  //Initialize the Hive
  await Hive.initFlutter();

  // all custom objects need an adapter for hive to store them
  Hive.registerAdapter(TaskListAdapter());
  // Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskAdapter());

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
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
