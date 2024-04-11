//CODE extended FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s
// Modified almost entirely to fit our class structure

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_app/data/tasklist_classes.dart';

/// Used to build the list of tasks
/// Shows an overview of a task
class TaskTile extends StatelessWidget {
  final Task task;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function()? detailDialogFunction;

  late final bool _taskCompleted;
  late final bool _taskClockedIn;

  TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.deleteFunction,
    this.detailDialogFunction,
  }) {
    _taskCompleted = task.taskStatus == TaskStatus.DONE ? true : false;
    _taskClockedIn = task.clockRunning;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Slidable(
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                icon: Icons.delete,
                backgroundColor: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(15),
              )
            ],
          ),
          child: GestureDetector(
            onTap: detailDialogFunction,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: _taskCompleted,
                    onChanged: onChanged,
                  ),

                  Visibility(
                      visible: _taskClockedIn,
                      child: Icon(Icons
                          .punch_clock)), // shown if task has currently running clock

                  Card(
                    margin: EdgeInsets.all(8.0),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(task.taskStatus.label),
                    ),
                  ),

                  //Task Name
                  Text(
                    task.taskName,
                    style: TextStyle(
                      decoration: _taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  Spacer(),

                  ElevatedButton(
                    onPressed: () => deleteFunction != null
                        ? deleteFunction!(context)
                        : null,
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
