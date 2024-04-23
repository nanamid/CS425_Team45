import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
import 'dart:async';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';

class PomodoroTimerWidget extends StatefulWidget {
  PomodoroTimerWidget({super.key, this.task});

  /// was used to instantiate the pomodoro timer with a task,
  /// like for creating a new pomodoro timer from the the task
  /// detail view. We aren't really doing that anymore
  final Task? task;
  @override
  State<PomodoroTimerWidget> createState() => _PomodoroTimerWidgetState();
}

class _PomodoroTimerWidgetState extends State<PomodoroTimerWidget> {
  //References the Hive Box
  final TodoDatabase _db = TodoDatabase();
  late final PomodoroTimer _pomodoroTimer;
  late TaskList taskList;

  Duration getCurrentTimerTime() {
    return _pomodoroTimer.getRemainingTime();
  }

  late Timer nativeTimer;

  @override
  void initState() {
    final taskListIndex = 0; // hardcoded one tasklist for now
    _db.loadData();
    taskList = _db.listOfTaskLists[taskListIndex];

    _pomodoroTimer = _db.pomodoroTimer;
    nativeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // print(
      //     'Update: ${getCurrentTimerTime().inMinutes}:${getCurrentTimerTime().inSeconds % 60}');
      setState(() {});
    });
    // _pomodoroTimer.associatedTask = widget.task;

    super.initState();
  }

  @override
  Widget build(BuildContext scontext) {
    PomodoroTimer pomodoroTimer = _pomodoroTimer; // alias
    return Container(
      decoration: BoxDecoration(color: AppColors.accent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // Updating timer
              Expanded(
                child: buildText(
                    "Time Remaining:\n${getCurrentTimerTime().inMinutes.toString().padLeft(2, '0')}:${(getCurrentTimerTime().inSeconds % 60).toString().padLeft(2, '0')}",
                    AppColors.textWhite,
                    AppSizes.textLarge,
                    FontWeight.bold,
                    TextAlign.center,
                    TextOverflow.clip),
              ),

              // Tomatoes remaining
              Expanded(
                child: buildText(
                    "Tomatoes Completed:\n${pomodoroTimer.numberOfTomatoes}",
                    AppColors.textWhite,
                    AppSizes.textLarge,
                    FontWeight.bold,
                    TextAlign.center,
                    TextOverflow.clip),
              ),
            ],
          ),

          20.height_space,

          // associate pomodoro timer with task, so we can clock in on that task
          DropdownMenu(
              // initialSelection: widget.task,
              helperText: 'Associate task with timer',
              hintText: 'No Task',
              textStyle: TextStyle(color: AppColors.textWhite),
              initialSelection: pomodoroTimer.associatedTask,
              enabled: !pomodoroTimer
                  .timerIsRunning, // can't change the associated task while it's runing
              inputDecorationTheme: InputDecorationTheme(
                fillColor: AppColors.secondary,
                filled: true,
                helperStyle: TextStyle(color: AppColors.textWhite),
                hintStyle: TextStyle(color: AppColors.textSecondary),
              ),
              onSelected: (Task? task) {
                if (task != null) {
                  setState(() {
                    pomodoroTimer.associatedTask = task;
                  });
                }
              },
              dropdownMenuEntries:
                  taskList.list.map<DropdownMenuEntry<Task>>((Task task) {
                return DropdownMenuEntry<Task>(
                    value: task, label: task.taskName);
              }).toList()),

          20.height_space,

          // Start Stop buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textWhite),
                  onPressed: () {
                    setState(() {
                      pomodoroTimer.startTimer();
                    });
                    _db.updateDatabase();
                  },
                  child: Text("Start")),

              5.width_space,

              // Stop
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textWhite),
                  onPressed: () {
                    pomodoroTimer.stopTimer();
                    _db.updateDatabase();
                  },
                  child: Text("Stop Timer")),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textWhite),
              onPressed: () {
                pomodoroTimer.clearTimer();
                _db.updateDatabase();
              },
              child: Text('Clear Timer'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    nativeTimer.cancel();
    super.dispose();
  }
}
