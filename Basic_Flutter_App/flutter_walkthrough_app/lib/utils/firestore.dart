import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // Function for adding a new task
  // The completion field defaults to "false"
  addTask_v2(String newTaskName, String newTaskDesc) async {
    final newTask = {
      "completed": false,
      "taskName": newTaskName,
      "taskDesc": newTaskDesc
    };
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("tasks")
        .add(newTask)
        .then((value) =>
            print("Note Added to ${FirebaseAuth.instance.currentUser?.email}"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  // Function for updating a task
  // This function is only for updating the text of the task
  updateTask(String newTaskName, String newTaskDesc) async {
    final updateTask = {
      "completed": false,
      "taskName": newTaskName,
      "taskDesc": newTaskDesc
    };
    var docID = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("tasks")
        .doc()
        .id;
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("tasks")
        .doc(docID)
        .update(updateTask)
        .then((value) => print(
            "Note Updated from ${FirebaseAuth.instance.currentUser?.email}"))
        .catchError((error) => print("Failed to update note: $error"));
  }

  // Function for marking if a task is done
  isDone(bool isTaskDone) async {
    var docID = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("tasks")
        .doc()
        .id;
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("tasks")
        .doc(docID)
        .update({"completed": isTaskDone})
        .then((value) => print(
            "Marked task done from ${FirebaseAuth.instance.currentUser?.email}"))
        .catchError((error) => print("Failed to mark as done: $error"));
  }

  // Function for deleting a task
  deleteTask() async {
    var docID = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("tasks")
        .doc()
        .id;
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("tasks")
        .doc(docID)
        .delete()
        .then((value) => print(
            "Note Deleted on ${FirebaseAuth.instance.currentUser?.email}"))
        .catchError((error) => print("Failed to delete note: $error"));
  }
}
