import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/common/widgets/confirm_addtask_dialogs.dart';
import 'package:test_app/navigation_menu.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:get/get.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final NavigationController controller = Get.find();

  final TextEditingController taskNameController = TextEditingController();
  // final TextEditingController taskStatusController = TextEditingController();
  TaskStatus taskStatus = TaskStatus.TODO;
  // final TextEditingController taskLabelController = TextEditingController();
  TaskLabel taskLabel = TaskLabel.Default;
  final TextEditingController taskDescriptionController =
      TextEditingController();
  // TODO deadline, reminder stuff
  // TODO parent task

  void _saveTask() {
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();

    TaskList taskList = db.listOfTaskLists[taskListIndex];
    taskList.addTask(Task(
        taskName: taskNameController.text,
        taskStatus: taskStatus,
        taskLabel: taskLabel,
        taskDescription: taskDescriptionController.text));
    taskNameController.clear();
    taskDescriptionController.clear();
    db.updateDatabase();

    controller.selectedIndex.value = 0; // hardcoded task list page index
  }

  void _cancelSaveTask() {
    controller.selectedIndex.value = 0; // hardcoded task list page index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.accent,
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              // Name
              TextField(
                controller: taskNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: AppColors.primary,
                  filled: true,
                  hintText: "Task Name",
                ),
              ),

              // Status
              DropdownMenu(
                initialSelection: TaskStatus.TODO,
                helperText: 'Task Status',
                inputDecorationTheme: InputDecorationTheme(
                    fillColor: AppColors.primary, filled: true),
                onSelected: (TaskStatus? status) {
                  if (status != null) {
                    setState(() => taskStatus = status);
                  }
                },
                dropdownMenuEntries: TaskStatus.values
                    .map<DropdownMenuEntry<TaskStatus>>((TaskStatus status) {
                  return DropdownMenuEntry<TaskStatus>(
                    value: status,
                    label: status.label,
                  );
                }).toList(),
              ),

              // Label
              DropdownMenu(
                initialSelection: TaskLabel.Default,
                helperText: 'Task Label',
                inputDecorationTheme: InputDecorationTheme(
                    fillColor: AppColors.primary, filled: true),
                onSelected: (TaskLabel? label) {
                  if (label != null) {
                    setState(() => taskLabel = label);
                  }
                },
                dropdownMenuEntries: TaskLabel.values
                    .map<DropdownMenuEntry<TaskLabel>>(
                        (TaskLabel dropdownLabel) {
                  return DropdownMenuEntry<TaskLabel>(
                    value: dropdownLabel,
                    label: dropdownLabel.label,
                  );
                }).toList(),
              ),

              // Description
              TextField(
                controller: taskDescriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: AppColors.primary,
                  filled: true,
                  hintText: "Description",
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
                      confirmation = await confirmSaveTaskDialog(context);
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

                  const SizedBox(width: 8),

                  //CANCEL
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.buttonSecondary),
                    onPressed: () async {
                      bool? confirmation;
                      confirmation = await confirmCancelTaskDialog(context);
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
            ])));
  }
}