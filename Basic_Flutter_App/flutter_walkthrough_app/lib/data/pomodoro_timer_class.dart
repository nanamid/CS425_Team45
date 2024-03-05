import 'package:hive/hive.dart';
import 'dart:async';

part 'pomodoro_timer_class.g.dart'; // automatic generator, through the magic of dart and hive, this gets built
// try first a: `dart run build_runner build`
// if it still has problems uninstall the app (deletes the database) and `flutter clean`
// the @HiveType(typeId: 0) annotations tell Hive what fields to store, the rest are not saved

@HiveType(typeId: 4)
class PomodoroTimer {
  @HiveField(0)
  Duration duration;

  @HiveField(1)
  bool _timerIsRunning = false;
  bool get timerIsRunning => _timerIsRunning;

  @HiveField(2)
  DateTime? _timerStartTime;
  DateTime? get timerStartTime => _timerStartTime;

  @HiveField(3)
  DateTime? _timerEndTime;
  DateTime? get timerEndTime => _timerEndTime;

  @HiveField(4)
  Duration previousTime;

  late Timer _nativeTimer;

  void Function()? callback;
  // TODO add notification callbacks

  void startTimer() {
    _timerStartTime = DateTime.now();
    _timerEndTime = _timerStartTime!.add(duration);
    _nativeTimer = Timer(duration, callback ?? (){});
    _timerIsRunning = true;
  }

  // Save the time in the timer.
  void stopTimer()
  {
    if (_timerIsRunning == false)
    {
      print('Tried to stop timer that was not running');
      return;
    }
    _nativeTimer.cancel();
    _timerIsRunning=false;
    previousTime += DateTime.now().difference(_timerStartTime!);
  }

  PomodoroTimer(
      {required this.duration,
      this.callback,
      this.previousTime = Duration.zero});
}
