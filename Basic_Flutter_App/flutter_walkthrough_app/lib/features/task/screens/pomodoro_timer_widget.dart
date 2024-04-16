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
  PomodoroTimerWidget({super.key, this.task, required this.pomodoroTimer});

  final PomodoroTimer pomodoroTimer;
  final Task? task;
  @override
  State<PomodoroTimerWidget> createState() => _PomodoroTimerWidgetState();
}

class _PomodoroTimerWidgetState extends State<PomodoroTimerWidget> {
  Duration getCurrentTimerTime() {
    return widget.pomodoroTimer.getRemainingTime();
  }

  late Timer nativeTimer;

  @override
  void initState() {
    super.initState();
    nativeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(
          'Update: ${getCurrentTimerTime().inMinutes}:${getCurrentTimerTime().inSeconds}');
      setState(() {});
    });
    widget.pomodoroTimer.associatedTask = widget.task;
  }

  @override
  Widget build(BuildContext scontext) {
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();
    TaskList taskList = db.listOfTaskLists[taskListIndex];

    PomodoroTimer pomodoroTimer = widget.pomodoroTimer; // alias
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
                  },
                  child: Text("Stop Timer")),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textWhite),
              onPressed: () => pomodoroTimer.clearTimer(),
              child: Text('Clear Timer'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    nativeTimer?.cancel();
    widget.pomodoroTimer.associatedTask = null;
    super.dispose();
  }
}
