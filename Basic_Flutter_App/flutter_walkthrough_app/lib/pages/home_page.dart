//CODE extended FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s
// Started with his stateful ListView, and built our class interface around it

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/utils/dialog_box.dart';
import 'package:test_app/utils/todo_tile.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/confirm_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Reference the Hive Box
  final _myBox = Hive.box('taskbox');
  TodoDatabase db = TodoDatabase();
  final taskListIndex = 0; // hardcoded one tasklist for now

  // TODO use NavigationDrawer to set up placeholder views

  @override
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

  //Text Controller
  // We could have multiple controllers to allow multiple simulataneous textboxes
  // So far, we clear after every use to reuse it (only one textbox at a time)
  final _controller = TextEditingController();

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

  // Handler for when we finish creating a new task
  // Uses text that was stored in the controller
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

  // Handler for clicking the 'add task' plus button
  // Uses controller for text input
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
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

  // Handler for pressing the 'clock in' button in task detail view
  void clockIn(int index) {
    Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
    currentTask.clockIn();
    db.updateDatabase();
  }

  // Handler for pressing the 'clock out' button in task detail view
  void clockOut(int index) {
    Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
    currentTask.clockOut();
    db.updateDatabase();
  }

  // Spawns a dialog showing all task details
  void showTaskDetail(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Task currentTask = db.listOfTaskLists[taskListIndex].list[index];
          // you have to wrap the alert dialog in a stateful builder to setState() correctly
          // normally AlertDialogs are stateless widgets
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
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
              content: Column(children: [
                // description
                Text(currentTask.taskDescription ?? "Description"),

                // total time
                Text("Total Time: ${currentTask.totalTime_minutes} mins"),

                // clock entries
                for (List clockPair in currentTask.clockList)
                  Text(
                      "${clockPair[0] ?? DateTime(0)} -- ${clockPair[1] ?? DateTime(0)}")
              ]),
              actions: [
                // clock in/out
                TextButton(
                  // onPressed has to wrap the async future function with a void function
                  onPressed: () async {
                    bool? confirmation = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog();
                        });
                    if (confirmation == true) {
                      setState(() {
                        clockIn(index);
                      });
                    }
                  },
                  child: Text("Clock In"),
                ),
                TextButton(
                  onPressed: () async {
                    bool? confirmation = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog();
                        });
                    if (confirmation == true) {
                      setState(() {
                        clockOut(index);
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

  @override
  // Builds a scaffold for viewing a list of tasks
  // As we move to multiple views, this will become a NavigationDrawer with some way to control which screen is drawn
  Widget build(BuildContext context) {
    List<Task> currentTaskList = db.listOfTaskLists[taskListIndex].list;
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: Text('Sample To Do List'),
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
            detailDialogFunction: () => showTaskDetail(index),
          );
        },
      ),
    );
  }
}
