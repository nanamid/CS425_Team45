import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:test_app/data/database.dart';
import 'package:test_app/utils/dialog_box.dart';
//import 'package:test_app/utils/timeclock_tile.dart';
//import 'package:test_app/utils/todo_tile.dart';
//import 'package:test_app/data/tasklist_classes.dart';
//import 'package:test_app/utils/confirm_dialog.dart';
import 'package:test_app/utils/firestore.dart';

class TaskPageDB extends StatefulWidget {
  const TaskPageDB({super.key});

  @override
  State<TaskPageDB> createState() => _TaskPageDBState();
}

class _TaskPageDBState extends State<TaskPageDB> {
  // Firestore Service
  final FirestoreService firestoreService = FirestoreService();

  // Text controllers for the task name and task description
  final _taskNameController = TextEditingController();
  //final _taskDescController = TextEditingController();  //Maybe?

  // Dialog box for creating a new task
  // This function is only for creating a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: _taskNameController,
        onSave: () {
          firestoreService.addTask_v2(_taskNameController.text);
          _taskNameController.clear();
          Navigator.pop(context);
        },
        onCancel: () => Navigator.of(context).pop(),
        confirmCancel: true,
      ),
      //
    );
  }

  // Dialog box for updating a task
  // This function is only for updating the content of the task
  void updateTask(String? docID) {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: _taskNameController,
        onSave: () {
          firestoreService.updateTask(docID!, _taskNameController.text);
          _taskNameController.clear();
          Navigator.pop(context);
        },
        onCancel: () => Navigator.of(context).pop(),
        confirmCancel: true,
      ),
      //
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // Retrieve the document from Firestore
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // Get the tasks from the document
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['taskName'];

                // Display the tasks as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => updateTask(docID),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => firestoreService.deleteTask(docID),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  //
                );
              },
            );
          } else {
            return const Text("No tasks yet!");
          }
        },
      ),
    );
  }
}
