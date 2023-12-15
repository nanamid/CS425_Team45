//CODE extended FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s
// Started with his stateful ListView, and built our class interface around it

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/utils/dialog_box.dart';
import 'package:test_app/utils/todo_tile.dart';
import 'package:test_app/data/tasklist_classes.dart';

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
  final _controller = TextEditingController();

  //Checkbox Checker (was it clicked?)
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      final prevState =
          db.listOfTaskLists[taskListIndex].list[index].taskStatus;
      if (prevState.toString() != "DONE") // Suppose we have other statuses, like TODO, WAIT, DONE, etc.
      {
        db.listOfTaskLists[taskListIndex].list[index].taskStatus =
            "DONE"; // TODO should be TaskStatus object
      } else {
        db.listOfTaskLists[taskListIndex].list[index].taskStatus =
            "TODO"; // TODO should be TaskStatus object
      }
    });
    db.updateDatabase();
  }

  //Save a Task
  void saveNewTask() {
    setState(() {
      db.listOfTaskLists[taskListIndex].list.add(Task(
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

  //Create a New Task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.listOfTaskLists[taskListIndex].list.removeAt(index);
    });
    db.updateDatabase();
  }

  void clockIn(int index) {
    setState(() {
      (db.listOfTaskLists[taskListIndex] as TaskList).list[index].clockIn();
    });
    db.updateDatabase();
  }

  void clockOut(int index) {
    setState(() {
      (db.listOfTaskLists[taskListIndex] as TaskList).list[index].clockOut();
    });
    db.updateDatabase();
  }

  void showTaskDetail(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                // Text(db.listOfTaskLists[taskListIndex].list[index].taskStatus), // TODO make the enum printable
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${db.listOfTaskLists[taskListIndex].list[index].taskStatus}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      db.listOfTaskLists[taskListIndex].list[index].taskName),
                ),
              ],
            ),
            content: Column(children: [
              Text(db.listOfTaskLists[taskListIndex].list[index]
                      .taskDescription ??
                  "Description"),
              Text(
                  "Total Time: ${db.listOfTaskLists[taskListIndex].list[index].totalTime_minutes} mins"),
              for (List clockPair in (db.listOfTaskLists[taskListIndex] as TaskList).list[index].clockList)
              Text("${clockPair[0]??DateTime(0) as DateTime} -- ${clockPair[1]??DateTime(0) as DateTime}")
            ]),
            actions: [
              TextButton(
                onPressed: () => clockIn(index),
                child: Text("Clock In"),
              ),
              TextButton(
                onPressed: () => clockOut(index),
                child: Text("Clock Out"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: db.listOfTaskLists[taskListIndex].list.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.listOfTaskLists[taskListIndex].list[index].taskName ??
                "NoName",
            taskStatus: db.listOfTaskLists[taskListIndex].list[index].taskStatus.toString(),
            taskCompleted:
                db.listOfTaskLists[taskListIndex].list[index].taskStatus.toString() == "DONE"
                    ? true
                    : false,
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            detailDialogFunction: () => showTaskDetail(index),
          );
        },
      ),
    );
  }
}
