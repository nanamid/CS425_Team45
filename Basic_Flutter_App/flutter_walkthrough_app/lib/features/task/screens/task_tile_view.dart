import 'package:flutter/material.dart';
import 'package:test_app/utils/constants/colors.dart';

class TaskTileView extends StatelessWidget {
  const TaskTileView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigate to TaskView to see Task Details
      },
      child: AnimatedContainer(
        //I'll eventually replace this with a custom card view or TaskTileView
        duration: const Duration(milliseconds: 600),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]),
        child: ListTile(
          //Check Icon
          trailing: GestureDetector(
            onTap: () {
              //Check or Uncheck task
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 0.8)),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),

          //Task Title
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 3),
            child: Text('DONE'), //Text('Task $index'),
          ),

          //Task Description
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Description of Task
              Text('Description'), //Text('Description $index'),

              //Date of Task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Date '),
                      Text('SubDate '),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
