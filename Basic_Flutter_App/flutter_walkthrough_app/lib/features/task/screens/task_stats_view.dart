import 'package:flutter/material.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';

class TaskInfoView extends StatelessWidget {
  const TaskInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();
    TaskList taskList = db.listOfTaskLists[taskListIndex];
    return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[taskList] + taskList.list),
          // listenable: taskList,
          builder: (BuildContext context, Widget? child) {
            return Row(
              children: [
                // Total Tasks
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: Text(taskList.list.length.toString(),
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FittedBox(
                                child: Text("Total Tasks",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                SizedBox(width: 20),
                // Remaining
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: Text(
                                    taskList.list
                                        .where((element) =>
                                            element.taskStatus !=
                                            TaskStatus.DONE)
                                        .toList()
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FittedBox(
                                child: Text("Remaining",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            );
          },
        ));
  }
}
