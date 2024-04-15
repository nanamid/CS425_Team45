import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/features/task/screens/task_edit_page.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/todo_tile.dart';

class TaskTileView extends StatefulWidget {
  final Task task;
  Function(bool?)? onChanged;
  Function(BuildContext, Task)? deleteFunction;
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
    taskCompleted = task.taskStatus == TaskStatus.DONE ? true : false;
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
        onLongPress: () {
          HapticFeedback.mediumImpact();
          if (widget.detailDialogFunction != null) {
            widget.detailDialogFunction!();
          }
        },
        child: AnimatedContainer(
          //I'll eventually replace this with a custom card view or TaskTileView
          duration: const Duration(milliseconds: 600),
          margin: const EdgeInsets.symmetric(horizontal: 8),
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
          child: ExpansionTile(
            backgroundColor: AppColors.primary,
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
              width: 80,
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

                  //EDIT OR DELETE TASK BUTTON and Information Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: PopupMenuButton<int>(
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
                                    Get.to(EditTaskPage(
                                            existingTask: widget.task))
                                        ?.then((_) {
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                    break;
                                  }
                                case 1:
                                  {
                                    // Detail dialog
                                    if (widget.detailDialogFunction != null) {
                                      widget.detailDialogFunction!();
                                    }
                                    break;
                                  }
                                case 2:
                                  {
                                    // Push to Delete functionality
                                    // actually a showdialog
                                    if (widget.deleteFunction != null) {
                                      widget.deleteFunction!(
                                          context, widget.task);
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
                                      Icon(Icons.info),
                                      10.width_space,
                                      buildText(
                                          'Task Details',
                                          AppColors.dark,
                                          AppSizes.textMedium,
                                          FontWeight.normal,
                                          TextAlign.start,
                                          TextOverflow.clip)
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
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
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: widget.detailDialogFunction,
                                color: AppColors.buttonSecondary,
                                icon: Icon(Icons.info_outline)))
                      ],
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
                  Expanded(
                    child: buildText(
                        widget.task.taskStatus.label,
                        AppColors.textWhite,
                        AppSizes.textLarge,
                        FontWeight.normal,
                        TextAlign.start,
                        TextOverflow.clip,
                        maxLines: 1),
                  ),
                  Expanded(
                    flex: 2,
                    child: buildText(
                        widget.task.taskName,
                        AppColors.textWhite,
                        AppSizes.textMedium,
                        FontWeight.normal,
                        TextAlign.start,
                        TextOverflow.ellipsis,
                        maxLines: 1),
                  ),
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
                  Expanded(
                    child: Container(
                        //padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Column(
                          children: [
                            Row(
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
                                      TextOverflow.clip,
                                      maxLines: 1),
                                )
                              ],
                            ),

                            //CATEGORY
                            Row(children: [
                              Icon(
                                Icons.label,
                                color: AppColors.primaryBackground,
                              ),
                              5.width_space,
                              buildText(
                                  widget.task.taskLabel.label,
                                  AppColors.lightGrey,
                                  AppSizes.textSmall,
                                  FontWeight.w400,
                                  TextAlign.start,
                                  TextOverflow.fade,
                                  maxLines: 1),
                            ]),
                          ],
                        )),
                  ),
                ],
              ),
            ),

            // Children tiles
            children: [
              for (final child in widget.task.taskSubtasks)
                TaskTileView(
                    task: child,
                    onChanged: widget.onChanged,
                    deleteFunction: widget.deleteFunction,
                    taskIndex: widget.taskIndex)
            ],
          ),
        ));
  }
}
