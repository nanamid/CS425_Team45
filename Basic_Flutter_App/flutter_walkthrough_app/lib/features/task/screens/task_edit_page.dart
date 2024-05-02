import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key, required this.existingTask});

  final Task existingTask;

  @override
  Widget build(BuildContext context) {
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();
    TaskList taskList = db.listOfTaskLists[taskListIndex];

    void saveTask() {
      // the deadline may have changed, so we always delete the original notification
      // we do not touch the persistent notification
      for (final reminder
          in db.reminderManager.getAllRemindersOfTask(existingTask)) {
        if (db.reminderManager.remindersWithEndNotifications
            .contains(reminder)) {
          db.reminderManager.unregisterReminderTask(reminder);
        }
      }
      if (existingTask.taskDeadline != null) {
        db.reminderManager.registerTaskWithReminder(
            db.reminderManager
                .createReminderForDeadline(existingTask.taskDeadline!),
            existingTask);
      }
      db.updateDatabase();
      Get.back();
    }

    //NEW saveTask() function w/ Firestore
    void editTaskDB(String? docID, Task taskToSave) {
      final FirestoreService firestoreService = FirestoreService();
      firestoreService.updateTask_v2(docID!, taskToSave);
    }

    void cancelSaveTask() {
      // TODO store unedited version of task
      // Dart does everything by reference, and there is no easy copy() function...
      Get.back();
    }

    return Scaffold(
        backgroundColor: AppColors.accent,
        body: SafeArea(
          child: ModifyTaskWidget(
            saveTask: saveTask,
            cancelSaveTask: cancelSaveTask,
            task: existingTask,
            canCancel: true,
            taskList: taskList,
          ),
        ));
  }
}
