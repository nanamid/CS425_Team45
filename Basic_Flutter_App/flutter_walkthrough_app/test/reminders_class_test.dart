import 'package:test_app/data/reminders_class.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:fake_async/fake_async.dart';
import 'dart:async';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  void dummyCallback() {}
  ;
  final Duration testDuration = Duration(minutes: 10);
  final Duration testTimeout = Duration(seconds: 10);
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
      final Reminder reminder =
          Reminder(DateTime.now(), DateTime.now(), timerCallback: () {});
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
      final r = rm.createReminderForDeadline(DateTime.now().add(testDuration));
      expect(rm.allReminders, contains(r));
    });
    test('register task with reminder', () {
      final ReminderManager rm = ReminderManager();
      final reminder = rm.createReminderForTimer(testDuration);
      final Task task = Task(taskName: "foo");

      expect(rm.taskReminderMap, isEmpty);
      rm.registerTaskWithReminder(reminder, task);
      expect(rm.taskReminderMap, isNotEmpty);
      expect(rm.taskReminderMap, containsPair(reminder, task));
    });
    test('register duplicate task with reminder', () {
      final ReminderManager rm = ReminderManager();
      final reminder = rm.createReminderForTimer(testDuration);
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
      final reminder1 = rm.createReminderForTimer(testDuration);
      final reminder2 = rm.createReminderForTimer(testDuration);
      final Task task = Task(taskName: "foo");

      rm.registerTaskWithReminder(reminder1, task);
      rm.registerTaskWithReminder(reminder2, task);
      expect(rm.taskReminderMap, containsPair(reminder1, task));
      expect(rm.taskReminderMap, containsPair(reminder2, task));
      expect(rm.taskReminderMap, hasLength(2));
    });
    test('unregister reminder', () {
      final ReminderManager rm = ReminderManager();
      final reminder1 = rm.createReminderForTimer(testDuration);
      final reminder2 = rm.createReminderForTimer(testDuration);
      final reminder3 = rm.createReminderForTimer(testDuration);
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
      final reminder1 = rm.createReminderForTimer(testDuration);

      expect(rm.taskReminderMap, isEmpty);
      rm.unregisterReminderTask(reminder1);
      expect(rm.taskReminderMap, isEmpty);
    });
    test('unregister all reminders of a task', () {
      final ReminderManager rm = ReminderManager();
      final reminder1 = rm.createReminderForTimer(testDuration);
      final reminder2 = rm.createReminderForTimer(testDuration);
      final reminder3 = rm.createReminderForTimer(testDuration);
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
      final reminder1 = rm.createReminderForTimer(testDuration);
      final reminder2 = rm.createReminderForTimer(testDuration);
      final reminder3 = rm.createReminderForTimer(testDuration);
      rm.registerTaskWithReminder(reminder1, task);
      rm.registerTaskWithReminder(reminder3, task);

      List<Reminder> list = rm.getAllRemindersOfTask(task);
      expect(list, <Reminder>[reminder1, reminder3]);
    });
    test(
      'reminder manager timer callbacks',
      () {
        fakeAsync((async) {
          bool fired1 = false;
          bool fired2 = false;
          final ReminderManager rm = ReminderManager();
          assert(Duration(milliseconds: 1) < testTimeout);
          final reminder1 = rm.createReminderForTimer(Duration(milliseconds: 1),
              timerCallback: () => fired1 = true);
          final reminder2 = rm.createReminderForDeadline(
              DateTime.now().add(Duration(milliseconds: 1)),
              timerCallback: () => fired2 = true);

          async.elapse(testTimeout);
          expect(fired1, isTrue);
          expect(fired2, isTrue);
        });
      },
    );
    test('reminder sets persistent notification', () {
      fakeAsync((async) {
        final ReminderManager rm = ReminderManager();
        final reminder1 = rm.createReminderForTimer(testDuration,
            persistentNotification: true);
        final reminder2 = rm.createReminderForTimer(testDuration,
            persistentNotification: true);
        async.elapse(testTimeout); // wait for platform notification to timeout
        expect(rm.notificationIDToReminder.values, contains(reminder1));
        expect(rm.notificationIDToReminder.values, contains(reminder2));
        expect(rm.remindersWithPersistentNotifications, contains(reminder1));
        expect(rm.remindersWithPersistentNotifications, contains(reminder2));
      });
    });
    test('reminder sets end notification and alarm', () {
      fakeAsync((async) {
        AndroidAlarmManager.initialize();
        final ReminderManager rm = ReminderManager();
        final reminder1 =
            rm.createReminderForTimer(testDuration, timerEndNotification: true);
        final reminder2 =
            rm.createReminderForTimer(testDuration, timerEndNotification: true);
        async.elapse(testTimeout);
        expect(rm.notificationIDToReminder.values, contains(reminder1));
        expect(rm.notificationIDToReminder.values, contains(reminder2));
        expect(rm.remindersWithEndNotifications, contains(reminder1));
        expect(rm.remindersWithEndNotifications, contains(reminder2));
      });
    });
    test('reminders with persistent and end notification', () {
      fakeAsync((async) {
        AndroidAlarmManager.initialize();
        final ReminderManager rm = ReminderManager();
        final reminder1 = rm.createReminderForTimer(testDuration,
            timerEndNotification: true, persistentNotification: true);
        final reminder2 = rm.createReminderForTimer(testDuration,
            timerEndNotification: true, persistentNotification: true);
        async.elapse(testTimeout);
        expect(rm.notificationIDToReminder.values, contains(reminder1));
        expect(rm.notificationIDToReminder.values, contains(reminder2));
        expect(
            rm.notificationIDToReminder.values
                .where((element) => identical(element, reminder1)),
            hasLength(2));
        expect(
            rm.notificationIDToReminder.values
                .where((element) => identical(element, reminder2)),
            hasLength(2));
        expect(rm.remindersWithEndNotifications, contains(reminder1));
        expect(rm.remindersWithEndNotifications, contains(reminder2));
        expect(rm.remindersWithPersistentNotifications, contains(reminder1));
        expect(rm.remindersWithPersistentNotifications, contains(reminder2));
      });
    });
    test('reminder sets alarm', () {
      fakeAsync((async) {
        AndroidAlarmManager.initialize();
        final ReminderManager rm = ReminderManager();
        final reminder1 = rm.createReminderForTimer(testDuration,
            alarm: true, alarmCallback: () {});
        final reminder2 = rm.createReminderForTimer(testDuration,
            alarm: true, alarmCallback: () {});
        async.elapse(testTimeout);
        expect(rm.alarmIDToReminder.values, contains(reminder1));
        expect(rm.alarmIDToReminder.values, contains(reminder2));
        expect(rm.remindersWithAlarms, contains(reminder1));
        expect(rm.remindersWithAlarms, contains(reminder2));
      });
    });
    test('reminder manager alarm callbacks', () {},
        skip: "Requires android running to test android alarms");
    test('cancel reminder', () {
      fakeAsync((async) {
        AndroidAlarmManager.initialize();
        final ReminderManager rm = ReminderManager();
        final Reminder reminder1 = rm.createReminderForTimer(testDuration,
            persistentNotification: false,
            timerEndNotification: false,
            alarm: false);

        expect(reminder1.timer?.isActive, isTrue);
        expect(rm.allReminders, contains(reminder1));
        rm.cancelReminder(reminder1);
        expect(reminder1.timer?.isActive, isFalse);
        expect(rm.allReminders, isNot(contains(reminder1)));
        async.elapse(testTimeout); // acquires and releases lock

        final Reminder reminder2 = rm.createReminderForTimer(testDuration,
            persistentNotification: true,
            timerEndNotification: false,
            alarm: false);
        async.elapse(testTimeout); // create notification
        rm.cancelReminder(reminder2);
        async.elapse(testTimeout); // wait for lock
        expect(rm.notificationIDToReminder.values, isNot(contains(reminder2)));
        expect(rm.remindersWithPersistentNotifications,
            isNot(contains(reminder2)));

        final Reminder reminder3 = rm.createReminderForTimer(testDuration,
            persistentNotification: true,
            timerEndNotification: true,
            alarm: false);
        async.elapse(testTimeout); // create notification
        rm.cancelReminder(reminder3);
        async.elapse(testTimeout); // wait for lock
        expect(
            rm.notificationIDToReminder.values,
            isNot(contains(
                reminder3))); // checks that both the persistent and scheduled notification were removed
        expect(rm.remindersWithEndNotifications, isNot(contains(reminder3)));

        final Reminder reminder4 = rm.createReminderForTimer(testDuration,
            persistentNotification: true,
            timerEndNotification: true,
            alarm: true,
            alarmCallback: () {});
        async.elapse(testTimeout); // create notification
        rm.cancelReminder(reminder4);
        async.elapse(testTimeout); // wait for lock
        expect(
            rm.alarmIDToReminder.values,
            isNot(contains(
                reminder4))); // checks that both the persistent and scheduled notification were removed
        expect(rm.remindersWithAlarms, isNot(contains(reminder4)));
      });
    });
  });
  group('test Reminder object', () {
    test('Constructor', () async {
      fakeAsync((async) {
        final Reminder a = Reminder(
            DateTime.now(), DateTime.now().add(testDuration),
            timerCallback: dummyCallback);
        expect(a.timer?.isActive, isTrue);
        async.elapse(testTimeout);
      });
    });
    test('reminder total duration', () async {
      fakeAsync((async) {
        final Reminder a = Reminder(
            DateTime.now(), DateTime.now().add(Duration(milliseconds: 1)),
            timerCallback: dummyCallback);
        expect(a.totalDuration.inMilliseconds, 1);
        async.elapse(testTimeout);
      });
    });
    test('reminder remaining duration', () async {
      fakeAsync((async) {
        final Reminder a = Reminder(
            DateTime.now(), DateTime.now().add(Duration(milliseconds: 1)),
            timerCallback: dummyCallback);
        expect(a.remainingDuration, lessThan(a.totalDuration));
        async.elapse(testTimeout);
      });
    });
    test('reminder callback', () async {
      fakeAsync((async) {
        bool fired = false;
        final Reminder a = Reminder(
            DateTime.now(), DateTime.now().add(Duration(milliseconds: 1)),
            timerCallback: () => fired = true);
        async.elapse(testTimeout);
        expect(fired, isTrue);
      });
    });
  });
}
