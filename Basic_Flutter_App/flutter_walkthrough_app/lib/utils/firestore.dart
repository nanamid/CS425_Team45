//Inspiration: https://www.youtube.com/watch?v=iQOvD0y-xnw

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // Variables
  final CollectionReference userTasks = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection("tasks");

  // Function for adding a new task
  // The completion field defaults to "false" (a new task isn't completed)
  Future<void> addTask_v2(String newTaskName) async {
    final newTask = {
      "completed": false,
      "taskName": newTaskName,
    };
    userTasks
        .add(newTask)
        .then((value) =>
            print("Note Added to ${FirebaseAuth.instance.currentUser?.email}"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  // Function for retrieving the task list from the database
  Stream<QuerySnapshot> getTasksStream() {
    final tasksStream =
        userTasks.orderBy("completed", descending: false).snapshots();
    return tasksStream;
  }

  // Function for updating a task
  // This function is only for updating the text of the task
  Future<void> updateTask(String docID, String newTaskName) async {
    final updateTask = {
      "completed": false,
      "taskName": newTaskName,
    };
    return userTasks.doc(docID).update(updateTask);
  }

  // Function for marking if a task is done
  Future<void> isDone(String docID, int isTaskDone) async {
    userTasks
        .doc(docID)
        .update({"completed": isTaskDone})
        .then((value) => print(
            "Changed task status for ${FirebaseAuth.instance.currentUser?.email}"))
        .catchError((error) => print("Failed to change task status: $error"));
  }

  // Function for deleting a task
  Future<void> deleteTask(String docID) async {
    userTasks
        .doc(docID)
        .delete()
        .then((value) => print(
            "Note Deleted on ${FirebaseAuth.instance.currentUser?.email}"))
        .catchError((error) => print("Failed to delete note: $error"));
  }
}
