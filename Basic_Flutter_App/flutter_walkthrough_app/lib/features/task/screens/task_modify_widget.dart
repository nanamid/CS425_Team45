import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/features/task/screens/confirm_addtask_dialogs.dart';
import 'package:test_app/navigation_menu.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:get/get.dart';

// Might be better to do this in a form widget
class ModifyTaskWidget extends StatefulWidget {
  const ModifyTaskWidget(
      {super.key,
      required this.saveTask,
      required this.cancelSaveTask,
      required this.task,
      required this.canCancel});

  final void Function() saveTask;
  final void Function() cancelSaveTask;
  final Task task;
  final bool canCancel;

  @override
  State<ModifyTaskWidget> createState() => _ModifyTaskWidgetState();
}

class _ModifyTaskWidgetState extends State<ModifyTaskWidget> {
  final TextEditingController taskNameController = TextEditingController();
  // final TextEditingController taskStatusController = TextEditingController();
  // final TextEditingController taskLabelController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  // TODO parent task

  /* tell the higher widget we are done modifying the task.
     this class just modifies the task its given,
     What the calling class does with it is its problem.
  */
  void _saveTask() {
    widget.task.taskName = taskNameController.text;
    widget.task.taskDescription = taskDescriptionController.text;
    widget.saveTask();
  }

  void _cancelSaveTask() {
    widget.cancelSaveTask();
  }

  @override
  Widget build(BuildContext context) {
    taskNameController.value = TextEditingValue(text: widget.task.taskName);
    taskDescriptionController.value =
        TextEditingValue(text: widget.task.taskDescription ?? "");
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
        initialSelection: widget.task.taskStatus,
        helperText: 'Task Status',
        inputDecorationTheme:
            InputDecorationTheme(fillColor: AppColors.primary, filled: true),
        onSelected: (TaskStatus? status) {
          if (status != null) {
            setState(() => widget.task.taskStatus = status);
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
        initialSelection: widget.task.taskLabel,
        helperText: 'Task Label',
        inputDecorationTheme:
            InputDecorationTheme(fillColor: AppColors.primary, filled: true),
        onSelected: (TaskLabel? label) {
          if (label != null) {
            setState(() => widget.task.taskLabel = label);
          }
        },
        dropdownMenuEntries: TaskLabel.values
            .map<DropdownMenuEntry<TaskLabel>>((TaskLabel dropdownLabel) {
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

      ElevatedButton(
        onPressed: () async {
          widget.task.taskDeadline = await showDatePicker(
              context: context,
              initialDate: widget.task.taskDeadline,
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(9999, 01, 01));
          setState(() {});
        },
        child: Text(widget.task.taskDeadline == null
            ? "Deadline Date"
            : "${widget.task.taskDeadline!.year}-${widget.task.taskDeadline!.month}-${widget.task.taskDeadline!.day}"),
      ),

      ElevatedButton(
          onPressed: () async {
            if (widget.task.taskDeadline !=
                null) // date has to be entered first
            {
              TimeOfDay? tempTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(widget.task.taskDeadline!)
                  // TODO validate this
                  );
              if (tempTime != null) {
                setState(() {
                  widget.task.taskDeadline = DateTime(
                      widget.task.taskDeadline!.year,
                      widget.task.taskDeadline!.month,
                      widget.task.taskDeadline!.day,
                      tempTime.hour,
                      tempTime.minute);
                });
              }
            }
          },
          child: Text(widget.task.taskDeadline == null
              ? "Time"
              : "${widget.task.taskDeadline!.hour.toString().padLeft(2, '0')}:${widget.task.taskDeadline!.minute.toString().padLeft(2, '0')}")),

      //Button to save or cancel input
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //SAVE
          ElevatedButton(
            style:
                TextButton.styleFrom(backgroundColor: AppColors.buttonPrimary),
            onPressed: () async {
              bool? confirmation;
              confirmation = await confirmSaveTaskDialog(context);
              if (confirmation == true) {
                _saveTask();
              }
            },
            child: buildText('Save', AppColors.textWhite, AppSizes.textSmall,
                FontWeight.normal, TextAlign.left, TextOverflow.clip),
          ),

          const SizedBox(width: 8),

          //CANCEL
          Visibility(
            visible: widget.canCancel,
            child: ElevatedButton(
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
          ),
        ],
      )
    ]);
  }
}
