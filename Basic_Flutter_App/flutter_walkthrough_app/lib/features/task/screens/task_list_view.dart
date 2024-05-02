import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/data/firestore.dart';
import 'package:intl/intl.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/data/reminders_class.dart';
import 'package:test_app/features/task/screens/confirm_addtask_dialogs.dart';
import 'package:test_app/features/task/screens/task_tile_view.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/constants/text_strings.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/timeclock_tile.dart';
import 'package:test_app/common/widgets/confirm_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/features/task/screens/confirm_clockinout_dialogs.dart';
import 'package:test_app/features/task/screens/task_detail_dialog.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  //References the Hive Box
  TodoDatabase db = TodoDatabase();
  final taskListIndex = 0; // hardcoded one tasklist for now

  //Firestore Service
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  /// Handler for pressing the 'clock in' button in task detail view
  /// returns false if the clock entry could not be added, see task clockIn method
  bool clockIn(Task currentTask) {
    if (currentTask.clockIn()) // if it succeeded
    {
      Reminder reminder = db.reminderManager.createReminderForTimer(
          Duration.zero,
          persistentNotification: true,
          timerEndNotification: false);
      db.reminderManager.registerTaskWithReminder(reminder, currentTask);
      db.updateDatabase();
      return true;
    } else {
      return false;
    }
  }

  /// Handler for pressing the 'clock out' button in task detail view
  /// returns false if the clock entry could not be completed, see task clockOut method
  bool clockOut(Task currentTask) {
    // In the event we press the clock out button when the pomodoro timer opened the clock
    if (db.pomodoroTimer.associatedTask == currentTask &&
        db.pomodoroTimer.timerIsRunning) {
      db.pomodoroTimer.stopTimer();
      return true; // unconditionally return true
    }
    // otherwise, it's a normal clockout
    else if (currentTask.clockOut()) {
      List<Reminder> ongoingReminders = db
          .reminderManager.remindersWithPersistentNotifications
          .where((reminder) => identical(
              db.reminderManager.taskReminderMap[reminder], currentTask))
          .toList();
      ongoingReminders.forEach((reminder) {
        db.reminderManager.cancelReminder(reminder);
      });
      db.updateDatabase();
      return true;
    } else {
      return false;
    }
  }

  void checkBoxChanged(bool? value, Task changedTask) {
    setState(() {
      if (changedTask.taskStatus != TaskStatus.DONE) // If it's not done
      {
        changedTask.taskStatusBeforeDone = changedTask.taskStatus;
        changedTask.taskStatus =
            TaskStatus.DONE; // set it to done and clock out
        if (changedTask.clockRunning) {
          this.clockOut(changedTask);
        }
      } else {
        // unchecked the box and want to go back to what it was.
        changedTask.taskStatus =
            changedTask.taskStatusBeforeDone ?? TaskStatus.TODO;
      }
    });
    db.updateDatabase();
  }

  //NEW checkBoxChanged() function w/ Firestore
  void checkBoxChangedDB(bool value, String? docID) {
    if (value) {
      firestoreService.isDone(docID!, 1);
    } else {
      firestoreService.isDone(docID!, 0);
    }
  }

  //NEW Translation function for checkbox mapping
  TaskStatus taskStatusTranslation(Map<String, dynamic> firebaseTask) {
    TaskStatus currentStatus = TaskStatus.TODO;
    if (firebaseTask['completed'] == 0 || firebaseTask['completed'] == Null) {
      currentStatus = TaskStatus.TODO;
    } else if (firebaseTask['completed'] == 1) {
      currentStatus = TaskStatus.DONE;
    } else if (firebaseTask['completed'] == 2) {
      currentStatus = TaskStatus.WAIT;
    }
    //
    return currentStatus;
  }

  void deleteTask(Task task) {
    setState(() {
      TaskList currentTaskList = db.listOfTaskLists[taskListIndex];
      currentTaskList.removeTask(task);
      db.reminderManager.unregisterAllRemindersOfTask(task);
    });
    db.updateDatabase();
  }

  //NEW deleteTask() function w/ Firestore
  void deleteTaskDB(String? docID) {
    firestoreService.deleteTask(docID!);
  }

  @override
  Widget build(BuildContext context) {
    //TextTheme textTheme = Theme.of(context).textTheme;
    TaskList currentTaskList = db.listOfTaskLists[taskListIndex];
    List<Task> currentTaskListOfTasks = currentTaskList.list;

    return ListenableBuilder(
        listenable: Listenable.merge(
            <Listenable>[currentTaskList] + currentTaskListOfTasks),
        builder: (BuildContext context, Widget? child) {
          List<Task> listOfTopLevelTasks = currentTaskList.list
              .where((element) => element.taskParentTask == null)
              .toList(); // otherwise it shows parent tasks with their expansion list of children, as well as the children themselves later in the list
          return Container(
            decoration: BoxDecoration(
              //color: testing.clrLvl2,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: AppColors.secondary,
            ),
            child: listOfTopLevelTasks.isNotEmpty

                //Task List HAS ITEMS
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(15),
                    separatorBuilder: (context, index) => 10
                        .height_space, //use space extenion here "15.height_space"
                    itemCount: listOfTopLevelTasks.length,
                    itemBuilder: (context, index) {
                      Task currentTask = listOfTopLevelTasks[index];
                      return TaskTileView(
                        task: currentTask,
                        taskIndex: index,
                        onChanged: (value, taskToChange) =>
                            checkBoxChanged(value, taskToChange),
                        deleteFunction: (context, taskToDelete) async {
                          bool? confirmation = await confirmDialog(context);
                          if (confirmation == true) {
                            deleteTask(taskToDelete);
                          }
                        },
                        detailDialogFunction: (Task task) =>
                            showTaskDetail(context, task, clockIn, clockOut),
                      );
                    })
                :
                //Task List IS EMPTY -> Lottie Animation | if All Tasks Done Show this Widgets
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //Output if the list IS EMPTY
                    children: [
                      //Lottie Animation
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(ImageStrings.noTasksAnimation,
                              animate: listOfTopLevelTasks.isNotEmpty
                                  ? false
                                  : true), //Conditional is saying, play animation if testing is empty
                        ),
                      ),

                      //Sub Text (under Lottie Animation)
                      FadeInUp(
                        from: 30,
                        child: const Text(
                          AppTexts.doneAllTask,
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
