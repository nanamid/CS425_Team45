import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/data/reminders_class.dart';
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

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  //References the Hive Box
  TodoDatabase db = TodoDatabase();
  final taskListIndex = 0; // hardcoded one tasklist for now

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  /// Spawns a dialog showing all task details
  /// index is index of the selected task in the current task list
  /// refreshParent() will tell parent to redraw (usually pass setState) itself
  // TODO notifications may be a more correct way to do this https://api.flutter.dev/flutter/widgets/NotificationListener-class.html
  void showTaskDetail(int index, Function() refreshParent) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
          // you have to wrap the alert dialog in a stateful builder to setState() correctly
          // normally AlertDialogs are stateless widgets
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade100,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // status
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${currentTask.taskStatus.label}"),
                      ),

                      Padding(
                        // name
                        padding: const EdgeInsets.all(8.0),
                        child: Text(currentTask.taskName ?? "Name"),
                      ),
                    ],
                  ),
                  Text(
                    currentTask.clockRunning ? 'Clocked In' : 'Clocked Out',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              content: Column(children: [
                // description
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildText(
                      currentTask.taskDeadline != null
                          ? 'Deadline: ${DateFormat('yMMMMd').format(currentTask.taskDeadline!)} ${DateFormat('Hm').format(currentTask.taskDeadline!)}'
                          : "",
                      AppColors.textPrimary,
                      AppSizes.textMedium,
                      FontWeight.normal,
                      TextAlign.center,
                      TextOverflow.ellipsis),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildText(
                      "Description: ${currentTask.taskDescription}",
                      AppColors.textPrimary,
                      AppSizes.textMedium,
                      FontWeight.normal,
                      TextAlign.center,
                      TextOverflow.ellipsis),
                ),

                // total time
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("Total Time: ${currentTask.totalTime_minutes} mins"),
                ),

                // clock entries
                for (List<DateTime?> clockPair in currentTask.clockList)
                  TimeclockTile(clockPair: clockPair)

                // TODO use ListView.separated below when we move showTaskDetail() away from an alert dialog
                // ListView.separated(
                //   padding: const EdgeInsets.all(8),
                //   itemCount: currentTask.clockList.length,
                //   itemBuilder: (context, index) {
                //     return TimeclockTile(
                //         clockPair: currentTask.clockList[index]);
                //   },
                //   separatorBuilder: (context, index) => const Divider(),
                // )
              ]),
              actions: [
                // clock in/out
                TextButton(
                  // onPressed has to wrap the async future function with a void function
                  onPressed: () async {
                    // Ask for user confirmation
                    bool? confirmation = await confirmClockInDialog(context);

                    // catch async gap: https://dart.dev/tools/linter-rules/use_build_context_synchronously
                    if (!context.mounted) {
                      return;
                    }

                    if (confirmation == true) {
                      setState(() {
                        // not necessarily best practice to setState such a big function
                        refreshParent(); // makes the timeclock icon visible on list of tasks below this alert
                        bool success = clockIn(index);
                        if (success == false) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Cannot Add Clock Entry'),
                                    content: Text('Already Clocked In'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Okay'))
                                    ],
                                  ));
                        }
                      });
                    }
                  },
                  child: Text("Clock In"),
                ),

                TextButton(
                  onPressed: () async {
                    // Ask for user confirmation
                    bool? confirmation = await confirmClockOutDialog(context);

                    // catch async gap: https://dart.dev/tools/linter-rules/use_build_context_synchronously
                    if (!context.mounted) {
                      return;
                    }

                    if (confirmation == true) {
                      setState(() {
                        // not necessarily best practice to setState such a big function
                        refreshParent(); // makes the timeclock icon visible on list of tasks below this alert
                        bool success = clockOut(index);
                        if (success == false) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Cannot Add Clock Entry'),
                                    content: Text('Not Clocked In'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Okay'))
                                    ],
                                  ));
                        }
                      });
                    }
                  },
                  child: Text("Clock Out"),
                ),
              ],
            );
          });
        });
  }

  /// Handler for pressing the 'clock in' button in task detail view
  /// returns false if the clock entry could not be added, see task clockIn method
  bool clockIn(int index) {
    Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
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
  bool clockOut(int index) {
    Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
    if (currentTask.clockOut()) {
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

  void checkBoxChanged(bool? value, int index) {
    Task changedTask = db.listOfTaskLists[taskListIndex].list[index];
    setState(() {
      final prevState = changedTask.taskStatus;
      if (prevState !=
          TaskStatus
              .DONE) // Suppose we have other statuses, like TODO, WAIT, DONE, etc.
      {
        changedTask.taskStatus =
            TaskStatus.DONE; // TODO should be TaskStatus object
      } else {
        changedTask.taskStatus =
            TaskStatus.TODO; // TODO should be TaskStatus object
      }
    });
    db.updateDatabase();
  }

  void deleteTask(Task task) {
    setState(() {
      TaskList currentTaskList = db.listOfTaskLists[taskListIndex];
      currentTaskList.removeTask(task);
      db.reminderManager.unregisterAllRemindersOfTask(task);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    //TextTheme textTheme = Theme.of(context).textTheme;
    TaskList currentTaskList = db.listOfTaskLists[taskListIndex];
    List<Task> currentTaskListOfTasks = currentTaskList.list;
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
              separatorBuilder: (context, index) =>
                  10.height_space, //use space extenion here "15.height_space"
              itemCount: listOfTopLevelTasks.length,
              itemBuilder: (context, index) {
                Task currentTask = listOfTopLevelTasks[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    HapticFeedback.mediumImpact();
                    deleteTask(
                        currentTask); // TODO see if there's a way to dismiss child tasks, not the entire parent
                  },
                  background: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Icon(Icons.delete, color: Colors.red.shade700)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        //color: testing.clrLvl1,
                        borderRadius: BorderRadius.circular(20)),
                    child: TaskTileView(
                      task: currentTask,
                      taskIndex: index,
                      onChanged: (value) => checkBoxChanged(value, index),
                      deleteFunction: (context, taskToDelete) async {
                        bool? confirmation = await confirmDialog(context);
                        if (confirmation == true) {
                          deleteTask(taskToDelete);
                        }
                      },
                      detailDialogFunction: () =>
                          showTaskDetail(index, () => setState(() {})),
                    ),
                  ),
                );
              },
            )
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
  }
}
