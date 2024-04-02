import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/common/widgets/confirm_dialog.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';

class TaskTileView extends StatelessWidget {
  const TaskTileView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //Navigate to TaskDetailsView to see Task Details
        },
        child: AnimatedContainer(
          //I'll eventually replace this with a custom card view or TaskTileView
          duration: const Duration(milliseconds: 600),
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
            leading: GestureDetector(
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

            //Edit or Delete Task
            trailing: PopupMenuButton<int>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: AppColors.light,
              elevation: 1,
              onSelected: (value) {
                switch (value) {
                  case 0:
                    {
                      // Push to Edit Page
                      break;
                    }
                  case 1:
                    {
                      // Push to Delete functionality
                      confirmDialog(context);
                      break;
                    }
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        10.width_space,
                        buildText(
                            'Edit task',
                            AppColors.dark,
                            AppSizes.textMedium,
                            FontWeight.normal,
                            TextAlign.start,
                            TextOverflow.clip)
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        10.width_space,
                        buildText(
                            'Delete task',
                            Colors.red.shade300,
                            AppSizes.textMedium,
                            FontWeight.normal,
                            TextAlign.start,
                            TextOverflow.clip)
                      ],
                    ),
                  ),
                ];
              },
              child: Icon(Icons.more_vert),
            ),

            //Task Title
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: Text('DONE'), //Text('Task $index'),
            ),

            //Task Description (DATE & CATEGORY)
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Task Date
                  Container(
                    width: 130,
                    //padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded),
                          Expanded(
                            child: buildText(
                                'April 1, 2024',
                                AppColors.black,
                                AppSizes.textSmall,
                                FontWeight.w400,
                                TextAlign.start,
                                TextOverflow.clip),
                          )
                        ],
                      )
                    ),
                  
              
                  //Task Category
                  Text('CATEGORY'), //Text('Category: ${task.category}'),
                ],
              ),
            ),
          ),
        ));
  }
}
