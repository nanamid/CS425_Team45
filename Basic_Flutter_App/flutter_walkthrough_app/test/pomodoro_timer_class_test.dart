import 'package:test_app/data/pomodoro_timer_class.dart';
import 'package:test/test.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main()
{
  group('Test pomodoro_timer_class', () {
    final PomodoroTimer pomo = PomodoroTimer(userTimerCallback: (){});
    test('Constructor', () {
      expect(pomo, isA<PomodoroTimer>());
      expect(pomo.timerStartTime, isNull);
      expect(pomo.timerEndTime, isNull);
      expect(pomo.timerIsRunning, false);
      expect(pomo.remaningTime, Duration.zero);
      expect(pomo.userTimerCallback, returnsNormally);
    });
    test('startTimer', () {
      final Duration dura = Duration(seconds: 1);
      final PomodoroTimer pomo = PomodoroTimer();
      expect(pomo.timerIsRunning, false);
      pomo.startTimer(dura);
      expect(pomo.timerIsRunning, true);
      expect(pomo.timerStartTime, isNotNull);
      expect(pomo.timerEndTime, isNotNull);
      final difference = pomo.timerEndTime!.difference(pomo.timerStartTime!);
      expect(difference.inSeconds, closeTo(1, 0.5));
    }, skip: 'Requires android to be running, no longer suitable for a unit test');
    test('Did timer callback fire?', () {
      
    }, skip: 'Requires an async future to check this');
    test('stopTimer', () {
      final Duration dura = Duration(seconds: 1);
      final PomodoroTimer pomo = PomodoroTimer();
      pomo.startTimer(dura);

      pomo.stopTimer();
      expect(pomo.timerIsRunning, false);
      expect(pomo.remaningTime.inMicroseconds, greaterThan(0));
    }, skip: 'Requires android to be running, no longer suitable for a unit test');
  }, skip: 'Requires android to be running, no longer suitable for a unit test');
}