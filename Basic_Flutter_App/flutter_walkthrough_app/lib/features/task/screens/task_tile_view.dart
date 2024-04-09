import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/tasklist_classes.dart';

class TaskTileView extends StatefulWidget {
  final Task task;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function()? detailDialogFunction;
  final int taskIndex;

  late final bool taskCompleted;
  late final bool _taskClockedIn;

  TaskTileView(
      {super.key,
      required this.task,
      required this.onChanged,
      required this.deleteFunction,
      required this.taskIndex,
      this.detailDialogFunction}) {
    taskCompleted = task.taskStatus.name == "DONE" ? true : false;
    _taskClockedIn = task.clockRunning;
  }

  @override
  State<TaskTileView> createState() => _TaskTileViewState();
}

class _TaskTileViewState extends State<TaskTileView> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.detailDialogFunction,
        child: AnimatedContainer(
          //I'll eventually replace this with a custom card view or TaskTileView
          duration: const Duration(milliseconds: 600),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: AppColors.accent,
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
            leading: Column(
              children: [
                buildText(
                    'Task ${widget.taskIndex + 1}',
                    AppColors.textWhite,
                    AppSizes.textSmall,
                    FontWeight.normal,
                    TextAlign.left,
                    TextOverflow.clip),
                Spacer(),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      side: BorderSide(color: Colors.white, width: 2),
                      activeColor: Colors.white,
                      checkColor: AppColors.primary,
                      value: widget.taskCompleted,
                      onChanged: widget.onChanged,
                    ),
                  ),
                ),
              ],
            ),

            //Edit or Delete Task
            trailing: SizedBox(
              width: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //SWORD NUMBER
                  buildText('1', AppColors.textWhite, AppSizes.textLarge,
                      FontWeight.normal, TextAlign.start, TextOverflow.clip),
                  10.width_space,
                  //SWORD ICON
                  Image(
                    image: AssetImage(ImageStrings.swordIcon),
                    width: 30,
                    height: 30,
                  ),

                  //EDIT OR DELETE TASK BUTTON
                  PopupMenuButton<int>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: AppColors.light,
                    elevation: 1,
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          {
                            // TODO Push to Edit Page
                            break;
                          }
                        case 1:
                          {
                            // Push to Delete functionality
                            if (widget.deleteFunction != null) {
                              widget.deleteFunction!(context);
                            }
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
                    child: Icon(
                      Icons.more_vert,
                      color: AppColors.primaryBackground,
                    ),
                  ),
                ],
              ),
            ),

            //Task Title
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: Row(
                children: [
                  buildText(
                      widget.task.taskStatus.name,
                      AppColors.textWhite,
                      AppSizes.textLarge,
                      FontWeight.normal,
                      TextAlign.start,
                      TextOverflow.clip),
                  5.width_space,
                  buildText(
                      widget.task.taskName,
                      AppColors.textWhite,
                      AppSizes.textMedium,
                      FontWeight.normal,
                      TextAlign.start,
                      TextOverflow.clip),
                ],
              ),
            ),

            //Task Description (DATE & CATEGORY)
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //DATE
                  Container(
                      width: 80,
                      //padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: AppColors.primaryBackground),
                          5.width_space,
                          Expanded(
                            child: buildText(
                                // TODO task date
                                'APR 1',
                                AppColors.lightGrey,
                                AppSizes.textSmall,
                                FontWeight.w400,
                                TextAlign.start,
                                TextOverflow.clip),
                          )
                        ],
                      )),

                  //CATEGORY
                  Row(children: [
                    Icon(
                      Icons.label,
                      color: AppColors.primaryBackground,
                    ),
                    5.width_space,
                    buildText(
                        widget.task.taskLabel ?? 'Default',
                        AppColors.lightGrey,
                        AppSizes.textSmall,
                        FontWeight.w400,
                        TextAlign.start,
                        TextOverflow.clip),
                  ]),
                ],
              ),
            ),
          ),
        ));
  }
}
