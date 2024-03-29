import 'package:flutter/material.dart';
import 'package:test_app/features/task/screens/task_avatar_page.dart';
import 'package:test_app/features/task/screens/task_list_page.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          //Avatar View
          Expanded(flex: 3, child: TaskAvatarView()),

          //Task Stats
          Expanded(flex: 1, child: Container(color: Colors.purple)),

          //Task List
          Expanded(flex: 6, child: TaskListView()),
        ],
      ),
    ));
  }
}
