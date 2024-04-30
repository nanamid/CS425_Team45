import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/features/task/controllers/task_controller.dart';
import 'package:test_app/features/task/views/task_avatar_page.dart';
import 'package:test_app/features/task/views/task_list_view.dart';
import 'package:test_app/features/task/views/task_info_view.dart';

class TasksPage extends StatelessWidget {

  final TaskController controller = Get.put(TaskController());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      bottom: false,
      top: false,
      child: Column(
        children: [
          //Avatar View
          Expanded(flex: 20, child: TaskAvatarView()),

          //Task Stats
          Expanded(flex: 5, child: TaskInfoView()),

          //Task List
          Expanded(flex: 20, child: TaskListView()),
        ],
      ),
    ));
  }
}
