import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
import 'dart:async';
import 'package:test_app/data/tasklist_classes.dart';

class PomodoroTimerWidget extends StatefulWidget {
  final PomodoroTimer pomodoroTimer;
  final Task? task;
  const PomodoroTimerWidget({super.key, required this.pomodoroTimer, this.task});
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
    widget.pomodoroTimer.task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    PomodoroTimer pomodoroTimer = widget.pomodoroTimer; // alias
    return Column(
        children: [
          Text(
              "Time: ${getCurrentTimerTime().inMinutes}:${getCurrentTimerTime().inSeconds}"),
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
    widget.pomodoroTimer.task = null;
    super.dispose();
  }
}
