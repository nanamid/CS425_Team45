//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final String? taskStatus;
  final String? taskDescription;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function()? detailDialogFunction;

  ToDoTile({
    super.key,
    required this.taskName,
    this.taskStatus,
    this.taskDescription,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.detailDialogFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(15),
            )
          ],
        ),
        child: GestureDetector(
          onTap: detailDialogFunction,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Checkbox
                Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
          
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(taskStatus?? "-"),
                  ),
                ),
          
                //Task Name
                Text(
                  taskName,
                  style: TextStyle(
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
          
                Spacer(),
          
                ElevatedButton(
                  onPressed:
                      () => deleteFunction != null ? deleteFunction!(context) : null,
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
