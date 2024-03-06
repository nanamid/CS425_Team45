import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
import 'dart:async';

class PomodoroTimerWidget extends StatefulWidget {
  final PomodoroTimer pomodoroTimer;
  const PomodoroTimerWidget({super.key, required this.pomodoroTimer});
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
  }

  @override
  Widget build(BuildContext context) {
    PomodoroTimer pomodoroTimer = widget.pomodoroTimer; // alias
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Text(
              "Time: ${getCurrentTimerTime().inMinutes}:${getCurrentTimerTime().inSeconds}"),
          Row(
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
              ElevatedButton(
                  onPressed: () => pomodoroTimer.clearTimer(),
                  child: Text('Clear Timer'))
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nativeTimer?.cancel();
    super.dispose();
  }
}
