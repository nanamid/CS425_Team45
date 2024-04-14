import 'package:flutter/material.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
import 'package:test_app/features/task/screens/pomodoro_timer_widget.dart';

class PomodoroPage extends StatelessWidget {
  PomodoroPage({super.key});
  final PomodoroTimer pomodoroTimer = PomodoroTimer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PomodoroTimerWidget(
        pomodoroTimer: pomodoroTimer,
        task: pomodoroTimer.associatedTask,
      )),
    );
  }
}
