import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/data/reminders_class.dart';
import 'package:test_app/features/task/screens/confirm_addtask_dialogs.dart';
import 'package:test_app/navigation_menu.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Might be better to do this in a form widget
class ModifyTaskWidget extends StatefulWidget {
  ModifyTaskWidget({
    super.key,
    required this.saveTask,
    required this.cancelSaveTask,
    required this.task,
    required this.canCancel,
    required this.taskList,
  })  : _workingTaskName = task.taskName,
        _workingTaskStatus = task.taskStatus,
        _workingTaskLabel = task.taskLabel,
        _workingTaskDescription = task.taskDescription,
        _workingTaskDeadline = task.taskDeadline,
        _workingParentTask = task.taskParentTask;

  final void Function() saveTask;
  final void Function() cancelSaveTask;
  final Task task;
  final bool canCancel;
  final TaskList taskList;

  // temporary copies of task's fields that we can change without ruining the actual task
  String _workingTaskName;
  TaskStatus _workingTaskStatus;
  TaskLabel _workingTaskLabel;
  String? _workingTaskDescription;
  DateTime? _workingTaskDeadline;
  Task?
      _workingParentTask; // On _saveTask() parentTask is what will become the parent of this newly created/modified task

  @override
  State<ModifyTaskWidget> createState() => _ModifyTaskWidgetState();
}

class _ModifyTaskWidgetState extends State<ModifyTaskWidget> {
  final TextEditingController taskNameController = TextEditingController();
  // final TextEditingController taskStatusController = TextEditingController();
  // final TextEditingController taskLabelController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  late final List<DropdownMenuEntry<Task>> allowableParentDropdownTasks;

  @override
  void initState() {
    // used to make sure you can't set this task's parent to
    // itself or to a descendent of itself
    allowableParentDropdownTasks = widget.taskList.list
        .map<DropdownMenuEntry<Task>>((Task task) {
          return DropdownMenuEntry<Task>(value: task, label: task.taskName);
        })
        .where((element) =>
            !identical(element.value, widget.task) &&
            element.value.testIfTaskIsAncestor(widget.task) ==
                false) // don't show this task in the list of potential parents
        .toList();

    super.initState();
  }

  /* tell the higher widget we are done modifying the task.
     this class just modifies the task its given,
     What the calling class does with it is its problem.
  */
  void _saveTask() {
    if (widget._workingTaskName.isEmpty) {
      widget.task.taskName = "Unamed Task";
    } else {
      widget.task.taskName = widget._workingTaskName;
    }

    // It is possible to be clocked in, then edit the task to DONE state
    if (widget._workingTaskStatus == TaskStatus.DONE &&
        widget.task.clockRunning == true) {
      this.clockOut(widget.task);
    }
    widget.task.taskStatus = widget._workingTaskStatus;

    widget.task.taskLabel = widget._workingTaskLabel;
    widget.task.taskDescription = widget._workingTaskDescription;
    widget.task.taskDeadline = widget._workingTaskDeadline;

    widget.task.makeTopLevelTask();
    widget._workingParentTask?.setSubTask(widget.task);

    widget.saveTask();
  }

  void _cancelSaveTask() {
    widget.cancelSaveTask();
  }

  bool clockOut(Task currentTask) {
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();
    TaskList taskList = db.listOfTaskLists[taskListIndex];
    if (db.pomodoroTimer.associatedTask == currentTask &&
        db.pomodoroTimer.timerIsRunning) {
      db.pomodoroTimer.stopTimer();
      return true; // unconditionally return true
    }
    // otherwise, it's a normal clockout
    else if (currentTask.clockOut()) {
      List<Reminder> ongoingReminders = db
          .reminderManager.remindersWithPersistentNotifications
          .where((reminder) => identical(
              db.reminderManager.taskReminderMap[reminder], currentTask))
          .toList();
      ongoingReminders.forEach((reminder) {
        db.reminderManager.cancelReminder(reminder);
      });
      db.updateDatabase();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    taskNameController.value = TextEditingValue(text: widget._workingTaskName);
    taskDescriptionController.value =
        TextEditingValue(text: widget._workingTaskDescription ?? "");

    return SafeArea(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // Name
        TextField(
          controller: taskNameController,
          style: TextStyle(color: AppColors.textWhite),
          onChanged: (String text) => widget._workingTaskName = text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            fillColor: AppColors.secondary,
            filled: true,
            hintText: "Unamed Task",
            hintStyle: TextStyle(color: AppColors.textSecondary),
            labelText: "Task Name",
            labelStyle: TextStyle(color: AppColors.white),
          ),
        ),

        // Status
        DropdownMenu(
          initialSelection: widget._workingTaskStatus,
          helperText: 'Task Status',
          textStyle: TextStyle(color: AppColors.textWhite),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: AppColors.secondary,
            filled: true,
            helperStyle: TextStyle(color: AppColors.textWhite),
          ),
          onSelected: (TaskStatus? status) {
            if (status != null) {
              setState(() => widget._workingTaskStatus = status);
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
          initialSelection: widget._workingTaskLabel,
          helperText: 'Task Label',
          textStyle: TextStyle(color: AppColors.textWhite),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: AppColors.secondary,
            filled: true,
            helperStyle: TextStyle(color: AppColors.textWhite),
          ),
          onSelected: (TaskLabel? label) {
            if (label != null) {
              setState(() => widget._workingTaskLabel = label);
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
          style: TextStyle(color: AppColors.textWhite),
          onChanged: (String text) => widget._workingTaskDescription = text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            fillColor: AppColors.secondary,
            filled: true,
            // hintText: "Task Description",
            // hintStyle: TextStyle(color: AppColors.textWhite),
            labelText: "Task Description",
            labelStyle: TextStyle(color: AppColors.white),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Date
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textWhite),
              onPressed: () async {
                widget._workingTaskDeadline = await showDatePicker(
                    context: context,
                    initialDate: widget._workingTaskDeadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.utc(9999, 01, 01));
                setState(() {});
              },
              child: Text(widget._workingTaskDeadline == null
                  ? "Deadline Date"
                  : DateFormat('yMMMMd').format(widget._workingTaskDeadline!)),
            ),

            5.width_space,

            // Time
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textWhite),
              onPressed: () async {
                if (widget._workingTaskDeadline !=
                    null) // date has to be entered first
                {
                  TimeOfDay? tempTime = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(widget._workingTaskDeadline!)
                      // TODO validate this
                      );
                  if (tempTime != null) {
                    setState(() {
                      widget._workingTaskDeadline = DateTime(
                          widget._workingTaskDeadline!.year,
                          widget._workingTaskDeadline!.month,
                          widget._workingTaskDeadline!.day,
                          tempTime.hour,
                          tempTime.minute);
                    });
                  }
                }
              },
              child: Text(widget._workingTaskDeadline == null
                  ? "Time"
                  : DateFormat('Hm').format(widget._workingTaskDeadline!)),
            ),

            5.width_space,

            Visibility(
              visible: widget._workingTaskDeadline != null,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textWhite),
                  onPressed: () {
                    setState(() {
                      widget._workingTaskDeadline = null;
                    });
                  },
                  child: buildText(
                      'Clear Deadline',
                      AppColors.textWhite,
                      AppSizes.textSmall,
                      FontWeight.normal,
                      TextAlign.left,
                      TextOverflow.clip)),
            )
          ],
        ),

        // Set parent task
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu(
              key: UniqueKey(),
              initialSelection: widget._workingParentTask,
              helperText: 'Set parent task',
              hintText: "No Parent",
              textStyle: TextStyle(color: AppColors.textWhite),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: AppColors.secondary,
                filled: true,
                helperStyle: TextStyle(color: AppColors.textWhite),
                hintStyle: TextStyle(color: AppColors.textWhite),
              ),
              width: allowableParentDropdownTasks.isEmpty
                  ? 160 // if there are no entries, make it draw wide enough
                  : null, // when there are entries, it calculates width automatically
              onSelected: (Task? task) {
                if (task != null) {
                  setState(() {
                    widget._workingParentTask = task;
                  });
                }
              },
              dropdownMenuEntries: allowableParentDropdownTasks,
            ),
            5.width_space,
            Visibility(
              visible: widget._workingParentTask != null,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textWhite),
                  onPressed: () {
                    setState(() {
                      // _saveTask() will take care of unSetting tasks
                      widget._workingParentTask = null;
                    });
                  },
                  child: buildText(
                      'Unset Parent',
                      AppColors.textWhite,
                      AppSizes.textSmall,
                      FontWeight.normal,
                      TextAlign.left,
                      TextOverflow.clip)),
            )
          ],
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
      ]),
    );
  }
}
