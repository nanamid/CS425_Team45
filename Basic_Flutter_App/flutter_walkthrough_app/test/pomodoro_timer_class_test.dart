import 'package:test_app/data/pomodoro_timer_class.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group(
    'Test pomodoro_timer_class',
    () {
      final PomodoroTimer pomo = PomodoroTimer();
      test('Constructor', () {
        expect(pomo, isA<PomodoroTimer>());
        expect(pomo.timerStartTime, isNull);
        expect(pomo.timerEndTime, isNull);
        expect(pomo.timerIsRunning, false);
        expect(pomo.remainingTime, Duration.zero);
      });
      test('startTimer', () {
        final Duration dura = Duration(seconds: 1);
        final PomodoroTimer pomo = PomodoroTimer();
        expect(pomo.timerIsRunning, false);
        pomo.startTimer();
        expect(pomo.timerIsRunning, true);
        expect(pomo.timerStartTime, isNotNull);
        expect(pomo.timerEndTime, isNotNull);
        final difference = pomo.timerEndTime!.difference(pomo.timerStartTime!);
        expect(difference.inSeconds, closeTo(1, 0.5));
      }, skip: "Now requires hive to be initialized");
      test('Did timer callback fire?', () {});
      test('stopTimer', () {
        final Duration dura = Duration(seconds: 1);
        final PomodoroTimer pomo = PomodoroTimer();
        pomo.startTimer();
        pomo.stopTimer();
        expect(pomo.timerIsRunning, false);
        expect(pomo.remainingTime.inMicroseconds, greaterThan(0));
      }, skip: "Now requires hive to be initialized");
    },
  );
}
