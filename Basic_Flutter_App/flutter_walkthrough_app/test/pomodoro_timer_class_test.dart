import 'package:test_app/data/pomodoro_timer_class.dart';
import 'package:test/test.dart';

void main()
{
  group('Test pomodoro_timer_class', () {
    final PomodoroTimer pomo = PomodoroTimer(duration: Duration(seconds: 2), callback: (){});
    test('Constructor', () {
      expect(pomo, isA<PomodoroTimer>());
      expect(pomo.timerStartTime, isNull);
      expect(pomo.timerEndTime, isNull);
      expect(pomo.timerIsRunning, false);
      expect(pomo.previousTime, Duration.zero);
      expect(pomo.callback, returnsNormally);
    });
    test('startTimer', () {
      final Duration dura = Duration(seconds: 1);
      final PomodoroTimer pomo = PomodoroTimer(duration: dura, callback: () {});
      expect(pomo.timerIsRunning, false);
      pomo.startTimer();
      expect(pomo.timerIsRunning, true);
      expect(pomo.timerStartTime, isNotNull);
      expect(pomo.timerEndTime, isNotNull);
      final difference = pomo.timerEndTime!.difference(pomo.timerStartTime!);
      expect(difference.inSeconds, closeTo(1, 0.5));
    });
    test('Did timer callback fire?', () {
      
    }, skip: 'Requires an async future to check this');
    test('stopTimer', () {
      final Duration dura = Duration(seconds: 1);
      final PomodoroTimer pomo = PomodoroTimer(duration: dura, callback: () {});
      pomo.startTimer();

      pomo.stopTimer();
      expect(pomo.timerIsRunning, false);
      expect(pomo.previousTime.inMicroseconds, greaterThan(0));
    });
  });
}