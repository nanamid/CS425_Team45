import 'package:test_app/data/tasklist_classes.dart';
import 'package:uuid/uuid.dart';
import 'package:test/test.dart';
import 'package:uuid/validation.dart';

void main() {
  group('Test TaskList Class', () {
    test('Initializer', (){
      final TaskList taskList = TaskList(listName: "name");
      expect(taskList.listName, "name");
    });
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
      expect(taskList.list.length, 0);
    });
    test("List getter is unmodifiable", () {
      final TaskList taskList = TaskList();
      expect(taskList.list.length, 0);

      try {
        taskList.list.add(Task(taskName: "foo"));
      } catch (e) {} // we want this to throw an exception, list is immutible
      expect(taskList.list.length, 0);
    });
    test("AddTask", () {
      final TaskList taskList = TaskList();
      final Task task = Task(taskName: "foo");
      taskList.addTask(task);
      expect(taskList.list.length, 1);
      expect(taskList.list.last, task);
    });
    test('add duplicate test', () {
      final TaskList taskList = TaskList();
      final Task task = Task(taskName: "foo");
      taskList.addTask(task);
      taskList.addTask(task);
      expect(taskList.list.length, 1);
      expect(taskList.list.last, task);
    });
    test("List is unmodifiable, but tasks inside are mutable", () {
      final TaskList taskList = TaskList();
      taskList.addTask(Task(taskName: "foo"));
      taskList.list.last.taskName = "foobar";
      expect(taskList.list.last.taskName, "foobar");
    });
    test("RemoveTask", () {
      final TaskList taskList = TaskList();
      taskList.addTask(Task(taskName: "foo"));
      expect(taskList.list.length, 1);
      taskList.removeTask(taskList.list.last);
      expect(taskList.list.length, 0);
    });
  });

  group("Test Task Class", (){
    test('Initializer', (){
      final Task task1 = Task(taskName: "name", taskStatus: TaskStatus.DONE, taskLabel: "label", taskDescription: "desc");
      expect(task1.taskName, "name");
      expect(task1.taskStatus, TaskStatus.DONE);
      expect(task1.taskLabel, "label");
      expect(task1.taskDescription, "desc");
      expect(task1.clockList.length, 0);
      expect(task1.totalTime_minutes, 0);
      expect(task1.totalTime_secs, 0);
      expect(task1.clockRunning, false);
      expect(task1.taskSubtasks.length, 0);
      expect(task1.taskParentTask, null);
    });
    test('Initialize Task with a uuid', (){
      final Task task = Task(taskName: "name");
      expect(task.taskUUID != null, true);
      expect(UuidValidation.isValidUUID(fromString: task.taskUUID!), true);
    });
    test('Initialize multiple with unique uuids', () {
      final Task task1 = Task(taskName: "name");
      final Task task2 = Task(taskName: "name");
      expect(task1.taskUUID != task2.taskUUID, true);
    });
    test('Open clock entry', (){
      final Task task = Task(taskName: "name");
      task.clockIn();
      expect(task.clockRunning, true);
      expect(task.clockList.length, 1);
      expect(task.clockList.last[0] != null, true);
      expect(task.clockList.last[1] == null, true);
    });
    test('Close clock entry', (){
      final Task task = Task(taskName: "name");
      task.clockIn();
      task.clockOut();
      expect(task.clockRunning, false);
      expect(task.clockList.length, 1);
      expect(task.clockList.last[0] != null, true);
      expect(task.clockList.last[1] != null, true);
    });
    test('Setting task to DONE closes running clock', (){
      final Task task = Task(taskName: "name", taskStatus: TaskStatus.TODO);
      task.clockIn();
      task.taskStatus = TaskStatus.DONE;
      expect(task.clockRunning, false);
    }, skip: 'TODO should this be checked in the widget, or in the class?');
    test('Set subtask', (){
      final Task parent = Task(taskName: "name");
      final Task child = Task(taskName: "name");
      parent.setSubTask(child);
      expect(parent.taskSubtasks.last, child);
      expect(child.taskParentTask, parent);
    });
    test('Unset subtask', () {
      final Task parent = Task(taskName: "name");
      final Task child = Task(taskName: "name");
      parent.setSubTask(child);
      parent.unsetSubTask(child);
      expect(parent.taskSubtasks.length, 0);
      expect(child.taskParentTask, null);
    });
    test('set subtask duplicate child', () {
      final Task parent = Task(taskName: "name");
      final Task child = Task(taskName: "name");
      parent.setSubTask(child);
      parent.setSubTask(child);
      expect(parent.taskSubtasks.last, child);
      expect(child.taskParentTask, parent);
    });
    test('remove nonexistent child', () {
      final Task parent = Task(taskName: "name");
      final Task child = Task(taskName: "name");
      parent.setSubTask(child);
      parent.unsetSubTask(child);
      parent.unsetSubTask(child);
      expect(parent.taskSubtasks.length, 0);
      expect(child.taskParentTask, null);
    });
    test('remove task in middle of nested subtasks', () {
      final TaskList taskList = TaskList();
      final Task grandParent = Task(taskName: "name");
      final Task parent = Task(taskName: "name");
      final Task child = Task(taskName: "name");
      taskList.addTask(grandParent);
      taskList.addTask(parent);
      taskList.addTask(child);
      grandParent.setSubTask(parent);
      parent.setSubTask(child);
      expect(taskList.list.contains(grandParent), true);
      expect(taskList.list.contains(parent), true);
      expect(taskList.list.contains(child), true);
      taskList.removeTask(parent);
      expect(true,
          false);
    }, skip: 'TODO decide whether removing parent task should kill children, or if parent of parent inherits children');
  });
  test('add parent as own subtask', () {
    final Task parent = Task(taskName: "name");
    parent.setSubTask(parent);
    expect(parent.taskSubtasks.isEmpty, true);
    expect(parent.taskParentTask, parent.taskParentTask);
  });
}
