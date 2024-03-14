import 'package:test_app/data/reminders_class.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:test_app/data/tasklist_classes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('test reminders class', () {
    test('Constructor', () {
      final ReminderManager rm = ReminderManager();
      expect(rm.alarmIDs, isEmpty);
      expect(rm.remindersWithPersistentNotifications, isEmpty);
      expect(rm.remindersWithEndNotifications, isEmpty);
      expect(rm.remindersWithAlarms, isEmpty);
      expect(rm.taskReminderMap, isEmpty);
    });
    test('list getters are unmodifiable', () {
      final Reminder reminder = Reminder(DateTime.now(), DateTime.now());
      final ReminderManager rm = ReminderManager();
      try {
        rm.alarmIDs.add(5);
      } catch (e) {
        expect(e, isUnsupportedError);
      }
      try {
        rm.remindersWithPersistentNotifications.add(reminder);
      } catch (e) {
        expect(e, isUnsupportedError);
      }
      try {
        rm.remindersWithEndNotifications.add(reminder);
      } catch (e) {
        expect(e, isUnsupportedError);
      }
      try {
        rm.remindersWithAlarms.add(reminder);
      } catch (e) {
        expect(e, isUnsupportedError);
      }
      try {
        rm.taskReminderMap[Task(taskName: "foo")] = reminder;
      } catch (e) {
        expect(e, isUnsupportedError);
      }
    });
    test('reminders inside getter lists should be immutable', () {
      // needs timers to get added
    });
    test('reminder for timer', () {
      final ReminderManager rm = ReminderManager();
      final r = rm.createReminderForTimer(Duration(seconds: 1));
      expect(
          DateTime.now().difference(r.timerStartTime).inSeconds, closeTo(0, 1));
      expect(
          DateTime.now().difference(r.timerEndTime).inSeconds, closeTo(1, 1));
    });
    test('reminder for deadline', () {
      final ReminderManager rm = ReminderManager();
      rm.createReminderForDeadline(DateTime.now().add(Duration(seconds: 1)));
    });
    test('register task with reminder', () {});
  });
  group('test Reminder object', () {
    test('Constructor', () {
      final Reminder a = Reminder(DateTime.now(), DateTime.now());
    });
  });
}
