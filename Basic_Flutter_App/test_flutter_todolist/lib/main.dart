import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // some global state stuff
  List<TaskList> listOfTaskLists = <TaskList>[TaskList(0)];

  void setListOfTaskLists(List<TaskList> newList) {
    listOfTaskLists = newList;
    notifyListeners();
  }

  static int i = 0;
  void setExampleTaskList() {
    TaskList workingList = listOfTaskLists[0];
    workingList.list.add(Task(i));
    Task workingTask = workingList.list.last;
    workingTask.taskName =
        all[Random().nextInt(all.length)]; // english words package
    workingTask.taskStatus = TaskStatus.TODO;
    notifyListeners();
    i++;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    var appState = context.watch<MyAppState>();
    if (selectedIndex == 0) {
      page = TaskListPage(appState: appState);
    } else if (selectedIndex == 1) {
      page = TaskViewPage();
    } else {
      throw UnimplementedError("no widget for ${selectedIndex}");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(children: [
          SafeArea(
            child: NavigationRail(
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.check),
                  label: Text('todolist'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) =>
                  setState(() => selectedIndex = value),
            ),
          ),
          Expanded(
            child: Container(
              child: page,
            ),
          ),
        ]),
      );
    });
  }
}

class TaskListPage extends StatelessWidget {
  const TaskListPage({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => appState.setExampleTaskList(),
        child: Text('setExampleTaskList()'),
      ),
    );
  }
}

class TaskList {
  final int listID;
  List<Task> list = <Task>[];

  TaskList(this.listID);
}

enum TaskStatus {
  TODO,
  DONE,
}

class Task {
  final int taskID;
  String? taskName;
  TaskStatus? taskStatus;
  String? taskLabel;
  // timestamp deadline;
  String? description;
  // also need time clock entries and total

  Task(this.taskID);
}

class TaskViewPage extends StatefulWidget {
  final Widget? child;

  const TaskViewPage({
    super.key,
    this.child,
  });

  @override
  State<TaskViewPage> createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  // vars

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView(
      children: [
        for (Task task in appState.listOfTaskLists[0].list)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(task.taskID.toString()),
                  Text(task.taskName!),
                  Text(task.taskStatus!.toString()),
                ],
              ),
            ),
          )
      ],
    );
  }
}
