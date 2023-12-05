//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/tasklist_classes.dart';

class TodoDatabase {
  List listOfTaskLists =
      []; // Meant to be List<TaskList> but Hive requires this to be List<dynamic>

  final _myTaskBox = Hive.box('taskbox');

  void createInitialDatabase() {
    listOfTaskLists = [
      TaskList(listID: 0) // default
    ];
    (listOfTaskLists[0] as TaskList).list.add(Task(
          taskID: 0,
          taskName: "Default Task",
          taskStatus: "TODO", // TODO should be TaskStatus object
          taskDescription: "Initial task, feel free to delete",
        ));
    print("Created initial tasklist database");
  }

  //Load Data (from database)
  void loadData() {
    listOfTaskLists = _myTaskBox.get("TASK_LIST");
    print("Loaded ${listOfTaskLists.length} task lists:");
    for (final TaskList tlist in listOfTaskLists) {
      print("ID: ${tlist.listID}");
    }
    // TODO check list was added to box correctly
  }

  //Update Data (to database)
  void updateDatabase() {
    _myTaskBox.put("TASK_LIST", listOfTaskLists);
    print("Stored ${listOfTaskLists.length} task lists:");
    for (final TaskList tlist in listOfTaskLists) {
      print("ID: ${tlist.listID}");
    }
  }
}
