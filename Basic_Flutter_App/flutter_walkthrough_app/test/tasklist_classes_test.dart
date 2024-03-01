import 'package:test_app/data/tasklist_classes.dart';
import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:uuid/validation.dart';

void main() {
  group('Test tasklist_classes', () {
    test('Initialize TaskList with a uuid', () {
      final TaskList taskList = TaskList(listName: "name");
      expect(taskList.listUUID != null, true);
      expect(UuidValidation.isValidUUID(fromString: taskList.listUUID!), true);
    });
    test('Initialize multiple with unique uuids', () {
      final TaskList taskList1 = TaskList(listName: "name");
      final TaskList taskList2 = TaskList(listName: "name");
      expect(taskList1.listUUID != taskList2.listUUID, true);
    });
    test("Initialize with empty name", () {
      final TaskList taskList1 = TaskList(listName: "name");
      expect(taskList1.listName, "name");
      final TaskList taskList2 = TaskList();
      expect(taskList2.listName, null);
    });
    test("Initialize with empty list", () {
      final TaskList taskList = TaskList();
      expect(taskList.list, []);
    });
    test("List getter is unmodifiable", () {
      final TaskList taskList = TaskList();
      expect(taskList.list, []);

      try {
        taskList.list.add(Task(taskName: "foo"));
      } catch (e) {} // we want this to throw an exception, list is immutible
      expect(taskList.list, []);
    });
    test("AddTask", () {
      final TaskList taskList = TaskList();
      final Task task = Task(taskName: "foo");
      taskList.addTask(task);
      expect(taskList.list.length, 1);
      expect(taskList.list[0], task);
    });
    test("List is unmodifiable, but tasks inside are mutable", () {
      final TaskList taskList = TaskList();
      taskList.addTask(Task(taskName: "foo"));
      taskList.list[0].taskName = "foobar";
      expect(taskList.list[0].taskName, "foobar");
    });
    test("RemoveTask", () {
      final TaskList taskList = TaskList();
      taskList.addTask(Task(taskName: "foo"));
      expect(taskList.list.length, 1);
      taskList.removeTask(taskList.list[0]);
      expect(taskList.list.length, 0);
    });
  });
}
