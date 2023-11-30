//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  //List of Tasks
  List todoList = [];

  //Reference the Hive Box
  final _myBox = Hive.box('mybox');

  //First-Time Opening Function
  void createInitialDatabase() {
    todoList = [
      ["Make a Task!", false],
      ["Finish Coding Project", false],
    ];
  }

  //Load Data (from database)
  void loadData() {
    todoList = _myBox.get("TODO_LIST");
  }

  //Update Data (to database)
  void updateDatabase() {
    _myBox.put("TODO_LIST", todoList);
  }
}
