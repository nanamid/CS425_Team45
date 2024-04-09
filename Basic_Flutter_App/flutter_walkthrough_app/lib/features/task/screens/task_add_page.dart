import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/common/widgets/confirm_dialog.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController taskNameController = TextEditingController();
    void _saveTask() {
      TodoDatabase db = TodoDatabase();
      final taskListIndex = 0; // hardcoded one tasklist for now
      db.loadData();

      TaskList taskList = db.listOfTaskLists[taskListIndex];
      taskList.addTask(Task(taskName: taskNameController.text));
      taskNameController.clear();
      db.updateDatabase();
    }

    void _cancelSaveTask() {/*TODO cancel button in addTask*/}

    return Scaffold(
        backgroundColor: AppColors.accent,
        body: SafeArea(
            child: SizedBox(
                height: 120,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Receive User Input
                      TextField(
                        controller: taskNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: AppColors.primary,
                          hintText: "Add a New Task",
                        ),
                      ),

                      //Button to save or cancel input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //SAVE
                          ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.buttonPrimary),
                            onPressed: () async {
                              bool? confirmation;
                              confirmation = await confirmDialog(context);
                              if (confirmation == true) {
                                _saveTask();
                              }
                            },
                            child: buildText(
                                'Save',
                                AppColors.textWhite,
                                AppSizes.textSmall,
                                FontWeight.normal,
                                TextAlign.left,
                                TextOverflow.clip),
                          ),

                          //TEXT BOX
                          const SizedBox(width: 8),

                          //CANCEL
                          ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.buttonSecondary),
                            onPressed: () async {
                              bool? confirmation;
                              confirmation = await confirmDialog(context);
                              if (confirmation == true) {
                                _cancelSaveTask();
                              }
                            },
                            child: buildText(
                                'Cancel',
                                AppColors.textWhite,
                                AppSizes.textSmall,
                                FontWeight.normal,
                                TextAlign.left,
                                TextOverflow.clip),
                          ),
                        ],
                      )
                    ]))));
  }
}
