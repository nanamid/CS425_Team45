import 'package:test_app/data/reminders_class.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:test_app/data/tasklist_classes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  void dummyCallback() {}
  ;
  group('test reminders class', () {
    test('Constructor', () {
      final ReminderManager rm = ReminderManager();
      expect(rm.alarmIDToReminder, isEmpty);
      expect(rm.allReminders, isEmpty);
      expect(rm.remindersWithPersistentNotifications, isEmpty);
      expect(rm.remindersWithEndNotifications, isEmpty);
      expect(rm.remindersWithAlarms, isEmpty);
      expect(rm.taskReminderMap, isEmpty);
    });
    test('list getters are unmodifiable', () {
      final Reminder reminder = Reminder(DateTime.now(), DateTime.now(), () {});
      final ReminderManager rm = ReminderManager();
      try {
        rm.alarmIDToReminder[5] = reminder;
      } catch (e) {
        expect(e, isUnsupportedError);
      }
      try {
        rm.allReminders.add(reminder);
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
        rm.taskReminderMap[reminder] = Task(taskName: "foo");
      } catch (e) {
        expect(e, isUnsupportedError);
      }
    });
    test('reminders inside getter lists should be immutable', () {
      // needs timers to get added
    }, skip: "needs timers to get added");
    test('reminder for timer', () {
      final ReminderManager rm = ReminderManager();
      final r = rm.createReminderForTimer(Duration(seconds: 1));
      expect(
          DateTime.now().difference(r.timerStartTime).inSeconds, closeTo(0, 1));
      expect(
          DateTime.now().difference(r.timerEndTime).inSeconds, closeTo(1, 1));
      expect(rm.allReminders, contains(r));
    });
    test('reminder for deadline', () {
      final ReminderManager rm = ReminderManager();
      final r = rm
          .createReminderForDeadline(DateTime.now().add(Duration(seconds: 1)));
      expect(rm.allReminders, contains(r));
    });
    test('register task with reminder', () {
      final ReminderManager rm = ReminderManager();
      final reminder = rm.createReminderForTimer(Duration(seconds: 1));
      final Task task = Task(taskName: "foo");

      expect(rm.taskReminderMap, isEmpty);
      rm.registerTaskWithReminder(reminder, task);
      expect(rm.taskReminderMap, isNotEmpty);
      expect(rm.taskReminderMap, containsPair(reminder, task));
    });
    test('register duplicate task with reminder', () {
      final ReminderManager rm = ReminderManager();
      final reminder = rm.createReminderForTimer(Duration(seconds: 1));
      final Task task = Task(taskName: "foo");

      rm.registerTaskWithReminder(reminder, task);
      rm.registerTaskWithReminder(reminder, task);
      expect(rm.taskReminderMap, containsPair(reminder, task));
      expect(rm.taskReminderMap, hasLength(1));
      expect(rm.taskReminderMap[Task(taskName: "bar")], null);
    });
    test('register same task with multiple reminders', () {
      // we want this to be possible. Suppose a 5-minute-to-end reminder and end reminder
      final ReminderManager rm = ReminderManager();
      final reminder1 = rm.createReminderForTimer(Duration(seconds: 1));
      final reminder2 = rm.createReminderForTimer(Duration(seconds: 1));
      final Task task = Task(taskName: "foo");

      rm.registerTaskWithReminder(reminder1, task);
      rm.registerTaskWithReminder(reminder2, task);
      expect(rm.taskReminderMap, containsPair(reminder1, task));
      expect(rm.taskReminderMap, containsPair(reminder2, task));
      expect(rm.taskReminderMap, hasLength(2));
    });
    test('unregister reminder', () {
      final ReminderManager rm = ReminderManager();
      final reminder1 = rm.createReminderForTimer(Duration(seconds: 1));
      final reminder2 = rm.createReminderForTimer(Duration(seconds: 1));
      final reminder3 = rm.createReminderForTimer(Duration(seconds: 1));
      final Task task1 = Task(taskName: "foo");
      final Task task2 = Task(taskName: "bar");
      rm.registerTaskWithReminder(reminder1, task1);
      rm.registerTaskWithReminder(reminder2, task2);
      rm.registerTaskWithReminder(reminder3, task2);

      rm.unregisterReminderTask(reminder1);
      expect(rm.taskReminderMap, isNot(containsPair(reminder1, task1)));

      rm.unregisterReminderTask(reminder2);
      // task2 still has reminder3
      expect(rm.taskReminderMap, containsPair(reminder3, task2));
    });
    test('unregister nonexistent reminder', () {
      final ReminderManager rm = ReminderManager();
      final reminder1 = rm.createReminderForTimer(Duration(seconds: 1));

      expect(rm.taskReminderMap, isEmpty);
      rm.unregisterReminderTask(reminder1);
      expect(rm.taskReminderMap, isEmpty);
    });
    test('unregister all reminders of a task', () {
      final ReminderManager rm = ReminderManager();
      final reminder1 = rm.createReminderForTimer(Duration(seconds: 1));
      final reminder2 = rm.createReminderForTimer(Duration(seconds: 1));
      final reminder3 = rm.createReminderForTimer(Duration(seconds: 1));
      final task1 = Task(taskName: "foo");
      final task2 = Task(taskName: "bar");

      rm.registerTaskWithReminder(reminder1, task1);
      rm.registerTaskWithReminder(reminder3, task1);
      rm.registerTaskWithReminder(reminder2, task2);
      expect(rm.taskReminderMap.length, 3);

      rm.unregisterAllRemindersOfTask(task1);
      expect(rm.taskReminderMap, containsPair(reminder2, task2));
      expect(rm.taskReminderMap, isNot(containsPair(reminder1, task1)));
      expect(rm.taskReminderMap, isNot(containsPair(reminder3, task1)));

      rm.unregisterAllRemindersOfTask(task2);
      expect(rm.taskReminderMap, isEmpty);
    });
    test('unregister all reminders of a task', () {
      final ReminderManager rm = ReminderManager();
      final Task task = Task(taskName: "foo");

      rm.unregisterAllRemindersOfTask(task);
      expect(rm.taskReminderMap, isEmpty);
    });
    test('get all reminders of task', () {
      final ReminderManager rm = ReminderManager();
      final Task task = Task(taskName: "foo");
      final reminder1 = rm.createReminderForTimer(Duration(seconds: 1));
      final reminder2 = rm.createReminderForTimer(Duration(seconds: 1));
      final reminder3 = rm.createReminderForTimer(Duration(seconds: 1));
      rm.registerTaskWithReminder(reminder1, task);
      rm.registerTaskWithReminder(reminder3, task);

      List<Reminder> list = rm.getAllRemindersOfTask(task);
      expect(list, <Reminder>[reminder1, reminder3]);
    });
    test(
      'reminder manager timer callbacks',
      () async {
        bool fired1 = false;
        bool fired2 = false;
        final ReminderManager rm = ReminderManager();
        final reminder1 = rm.createReminderForTimer(Duration(milliseconds: 1),
            timerCallback: () => fired1 = true);
        final reminder2 = rm.createReminderForDeadline(
            DateTime.now().add(Duration(milliseconds: 1)),
            timerCallback: () => fired2 = true);

        await (Future.delayed(Duration(milliseconds: 1)));
        expect(fired1, isTrue);
        expect(fired2, isTrue);
      },
    );
    test('reminder sets persistent notification', () {
      final ReminderManager rm = ReminderManager();
      final reminder1 = rm.createReminderForTimer(Duration(milliseconds: 1),
          persistentNotification: true);
      expect(rm.notificationIDToReminder.values, contains(reminder1));
    }, skip: 'notifications require native code');
    test('duplicate persistent reminder', () => null,
        skip: 'notifications require native code');
    test('reminder sets end notification', () {},
        skip: 'notifications require native code');
    test('reminder sets alarm', () {}, skip: "skip");
    test('reminder manager alarm callbacks', () {}, skip: "skip");
    test('cancel reminder', () => null, skip: "skip");
  });
  group('test Reminder object', () {
    test('Constructor', () async {
      final Reminder a = Reminder(DateTime.now(),
          DateTime.now().add(Duration(milliseconds: 1)), dummyCallback);
      expect(a.timer.isActive, isTrue);
      await (Future.delayed(Duration(milliseconds: 2)));
    });
    test('reminder total duration', () async {
      final Reminder a = Reminder(DateTime.now(),
          DateTime.now().add(Duration(milliseconds: 1)), dummyCallback);
      expect(a.totalDuration.inMilliseconds, 1);
      await (Future.delayed(Duration(milliseconds: 2)));
    });
    test('reminder remaining duration', () async {
      final Reminder a = Reminder(DateTime.now(),
          DateTime.now().add(Duration(milliseconds: 1)), dummyCallback);
      expect(a.remainingDuration, lessThan(a.totalDuration));
      await (Future.delayed(Duration(milliseconds: 2)));
    });
    test('reminder callback', () async {
      bool fired = false;
      final Reminder a = Reminder(DateTime.now(),
          DateTime.now().add(Duration(milliseconds: 1)), () => fired = true);
      await (Future.delayed(Duration(milliseconds: 2)));
      expect(fired, isTrue);
    });
  });
}
