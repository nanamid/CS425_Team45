import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
import 'dart:async';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/sizes.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildText(
            "Time: ${getCurrentTimerTime().inMinutes.toString().padLeft(2, '0')}:${(getCurrentTimerTime().inSeconds % 60).toString().padLeft(2, '0')}",
            AppColors.textPrimary,
            AppSizes.textLarge,
            FontWeight.bold,
            TextAlign.center,
            TextOverflow.clip),
        // associate pomodoro timer with task, so we can clock in on that task
        DropdownMenu(
            // initialSelection: widget.task,
            helperText: 'Associate task with pomodoro timer',
            inputDecorationTheme: InputDecorationTheme(
                fillColor: AppColors.primary, filled: true),
            onSelected: (Task? task) {
              if (task != null) {
                setState(() {
                  pomodoroTimer.associatedTask = task;
                });
              }
            },
            dropdownMenuEntries:
                taskList.list.map<DropdownMenuEntry<Task>>((Task task) {
              return DropdownMenuEntry<Task>(value: task, label: task.taskName);
            }).toList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    pomodoroTimer.startTimer();
                  });
                },
                child: Text("Start")),
            ElevatedButton(
                onPressed: () {
                  pomodoroTimer.stopTimer();
                },
                child: Text("Stop Timer")),
          ],
        ),
        ElevatedButton(
            onPressed: () => pomodoroTimer.clearTimer(),
            child: Text('Clear Timer'))
      ],
    );
  }

  @override
  void dispose() {
    nativeTimer?.cancel();
    widget.pomodoroTimer.associatedTask = null;
    super.dispose();
  }
}
