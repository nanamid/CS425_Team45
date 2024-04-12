//CODE extended FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s
// At this point, it's just his function names and served as an example

import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:uuid/uuid.dart'; // https://pub.dev/packages/uuid

// A TodoDatabase object is the working copy of what is stored in hive
// Remember to load and store back to hive before the object dies
class TodoDatabase {
  // Meant for multiple task lists, IE. 'home', 'work', 'family', etc.
  List listOfTaskLists =
      []; // Meant to be List<TaskList> but Hive requires this to be List<dynamic>

  final _myTaskBox =
      Hive.box('taskbox'); // refers to box named 'taskbox' opened in main.dart

  // Called in home_page.dart's state for empty databases
  void createInitialDatabase() {
    listOfTaskLists = [TaskList(listName: "Default Task List")];
    (listOfTaskLists[0] as TaskList).addTask(Task(
      taskName: "Default Task",
      taskStatus: TaskStatus.TODO,
      taskDescription: "Initial task, feel free to delete",
    ));
    print("Created initial tasklist database");
  }

  //Load Data (from hive database)
  void loadData() {
    listOfTaskLists = _myTaskBox.get("TASK_LIST");
    print("Loaded ${listOfTaskLists.length} task lists:");
    for (final TaskList tlist in listOfTaskLists) {
      print("ID: ${tlist.listUUID}");
    }
    // TODO check list was added to box correctly
  }

  //Update Data (to hive database)
  void updateDatabase() {
    _myTaskBox.put("TASK_LIST", listOfTaskLists);
    print("Stored ${listOfTaskLists.length} task lists:");
    for (final TaskList tlist in listOfTaskLists) {
      print("ID: ${tlist.listUUID}");
    }
  }
}