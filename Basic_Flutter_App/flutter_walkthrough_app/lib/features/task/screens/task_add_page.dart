import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/data/firestore.dart';
import 'package:test_app/features/task/screens/confirm_addtask_dialogs.dart';
import 'package:test_app/features/task/screens/task_modify_widget.dart';
import 'package:test_app/navigation_menu.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:get/get.dart';

// Might be better to do this in a form widget
class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find();
    final Task newTask = Task(taskName: "");

    void saveTask() {
      TodoDatabase db = TodoDatabase();
      final taskListIndex = 0; // hardcoded one tasklist for now
      db.loadData();
      TaskList taskList = db.listOfTaskLists[taskListIndex];
      taskList.addTask(newTask);

      if (newTask.taskDeadline != null) {
        db.reminderManager.registerTaskWithReminder(
            db.reminderManager.createReminderForDeadline(newTask.taskDeadline!),
            newTask);
      }
      db.updateDatabase();
      controller.selectedIndex.value = 0; // hardcoded task list page index
    }

    //NEW saveTask() function w/ Firestore
    void addTaskDB(String? docID, Task taskToSave) {
      final FirestoreService firestoreService = FirestoreService();
      firestoreService.addTask_v2(docID!);
    }

    void cancelSaveTask() {
      controller.selectedIndex.value = 0; // hardcoded task list page index
    }

    return Scaffold(
        backgroundColor: AppColors.accent,
        body: SafeArea(
          child: ModifyTaskWidget(
            saveTask: saveTask,
            cancelSaveTask: cancelSaveTask,
            task: newTask,
            canCancel: true,
          ),
        ));
  }
}
