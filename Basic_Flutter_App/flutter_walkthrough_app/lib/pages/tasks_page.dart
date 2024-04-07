//CODE extended FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s
// Started with his stateful ListView, and built our class interface around it

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/utils/dialog_box.dart';
import 'package:test_app/utils/timeclock_tile.dart';
import 'package:test_app/utils/todo_tile.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/confirm_dialog.dart';
//import 'package:test_app/pages/tasks_page.service.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  //Reference the Hive Box
  //final _myBox = Hive.box('taskbox');
  TodoDatabase db = TodoDatabase();
  final taskListIndex = 0; // hardcoded one tasklist for now

  // TODO use NavigationDrawer to set up placeholder views

  @override
  /*
  void initState() {
    //First-Time Opening Function
    if (_myBox.get("TASK_LIST") == null) {
      db.createInitialDatabase();
    } else {
      //Done when data already exists
      db.loadData();
    }

    super.initState();
  }
  */

  // Text Controller
  // These controllers are responsible for handling the text of a task
  final _controller = TextEditingController();
  final _taskNameController = TextEditingController();
  final _taskDescController = TextEditingController();

  void dispose() {
    _taskNameController.dispose();
    _taskDescController.dispose();
    super.dispose();
  }

  // Handler for clicking the checkbox
  // Assumes clicking check -> set as DONE. Unchecking -> set as TODO.
  // User should manually edit task to change status to something else (like WAIT)
  void checkBoxChanged(bool? value, int index) {
    Task changedTask = db.listOfTaskLists[taskListIndex].list[index];
    setState(() {
      final prevState = changedTask.taskStatus;
      if (prevState.toString() !=
          "DONE") // Suppose we have other statuses, like TODO, WAIT, DONE, etc.
      {
        changedTask.taskStatus = "DONE"; // TODO should be TaskStatus object
      } else {
        changedTask.taskStatus = "TODO"; // TODO should be TaskStatus object
      }
    });
    db.updateDatabase();
  }

  void checkBoxChanged_v2() {
    //
  }

  // Handler for when we finish creating a new task
  // Uses text that was stored in the controller
  /**/
  void saveNewTask() {
    List<Task> currentTaskList = db.listOfTaskLists[taskListIndex].list;
    setState(() {
      currentTaskList.add(Task(
        taskID: 0,
        taskName: _controller.text,
        taskStatus: "TODO", // TODO should be TaskStatus object
      ));
      //Clears the textbox for the next task
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  //Updated version of the handler for saving a new task
  //Now with Firebase Firestore capabilities!
  void saveNewTask_v2(String newTaskName, String newTaskDesc) {
    final newTask = <String, String>{
      "taskName": newTaskName,
      "taskDesc": newTaskDesc
    };
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks")
        .add(newTask);
  }

  //A new handler designed to update the currently selected task
  void updateTask(String newTaskName, String newTaskDesc) {
    final newTask = <String, String>{
      "taskName": newTaskName,
      "taskDesc": newTaskDesc
    };
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(newTask);
  }

  // Handler for clicking the 'add task' plus button
  // Uses controller for text input
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _taskNameController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
          confirmCancel: true,
        );
      },
    );
  }

  // Handler for deleting tasks (swipe to delete, press delete button)
  void deleteTask(int index) {
    setState(() {
      List<Task> currentTaskList = db.listOfTaskLists[taskListIndex].list;
      currentTaskList.removeAt(index);
    });
    db.updateDatabase();
  }

  void deleteTask_v2() {
    //
  }

  /// Handler for pressing the 'clock in' button in task detail view
  /// returns false if the clock entry could not be added, see task clockIn method
  bool clockIn(int index) {
    Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
    if (currentTask.clockIn()) // if it succeeded
    {
      db.updateDatabase();
      return true;
    } else {
      return false;
    }
  }

  bool clockIn_v2(int index) {
    //TEMP
    return false;
    //TEMP
  }

  /// Handler for pressing the 'clock out' button in task detail view
  /// returns false if the clock entry could not be completed, see task clockOut method
  bool clockOut(int index) {
    Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
    if (currentTask.clockOut()) {
      db.updateDatabase();
      return true;
    } else {
      return false;
    }
  }

  bool clockOut_v2(int index) {
    //TEMP
    return false;
    //TEMP
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // status
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${currentTask.taskStatus}"),
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
                Text(currentTask.taskDescription ?? "Description"),

                // total time
                Text("Total Time: ${currentTask.totalTime_minutes} mins"),

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
                    bool? confirmation = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog();
                        });

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
                    bool? confirmation = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog();
                        });

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

  void showTaskDetail_v2() {
    //
  }

  @override
  // Builds a scaffold for viewing a list of tasks
  // As we move to multiple views, this will become a NavigationDrawer with some way to control which screen is drawn
  Widget build(BuildContext context) {
    List<Task> currentTaskList = db.listOfTaskLists[taskListIndex].list;
    //
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentTaskList.length,
        itemBuilder: (context, index) {
          Task currentTask = currentTaskList[index];
          return TaskTile(
            taskName: currentTask.taskName ?? "NoName",
            taskStatus: currentTask.taskStatus.toString(),
            taskCompleted:
                currentTask.taskStatus.toString() == "DONE" ? true : false,
            taskClockedIn: currentTask.clockRunning,
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) async {
              bool? confirmation = await showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmDialog();
                  });
              if (confirmation == true) {
                deleteTask(index);
              }
            },
            detailDialogFunction: () =>
                showTaskDetail(index, () => setState(() {})),
          );
        },
      ),
    );
  }
}
