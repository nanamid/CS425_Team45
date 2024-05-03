import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/common/widgets/confirm_dialog.dart';
import 'package:test_app/features/task/screens/task_edit_page.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:intl/intl.dart';

class TaskTileView extends StatefulWidget {
  final Task task;
  Function(bool?, Task)? onChanged;
  Function(BuildContext, Task)? deleteFunction;
  Function(Task)? detailDialogFunction;
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
    return ListenableBuilder(
        listenable: Listenable.merge([widget.task] + widget.task.taskSubtasks),
        builder: (BuildContext context, Widget? child) {
          return Dismissible(
            key: UniqueKey(),
            // confirmDismiss: (DismissDirection _) => confirmDialog(context),
            onDismissed: (direction) {
              HapticFeedback.mediumImpact();
              if (widget.deleteFunction != null) {
                widget.deleteFunction!(context, widget.task);
              }
            },
            background: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child:
                  Center(child: Icon(Icons.delete, color: Colors.red.shade700)),
            ),
            child: GestureDetector(
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  if (widget.detailDialogFunction != null) {
                    widget.detailDialogFunction!(widget.task);
                  }
                },
                child: AnimatedContainer(
                  //I'll eventually replace this with a custom card view or TaskTileView
                  duration: const Duration(milliseconds: 600),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: widget._taskClockedIn
                          ? AppColors.success
                          : AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]),
                  child: ExpansionTile(
                    key: PageStorageKey(widget.task.taskUUID),
                    backgroundColor: AppColors.primary,
                    //Check Icon
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: widget._taskClockedIn ? AppColors.success : null,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: buildText(
                                'Task ${widget.taskIndex + 1}',
                                AppColors.textWhite,
                                AppSizes.textSmall,
                                FontWeight.normal,
                                TextAlign.left,
                                TextOverflow.clip),
                          ),
                          Expanded(
                            child: Checkbox(
                              side: BorderSide(color: Colors.white, width: 2),
                              activeColor: Colors.white,
                              checkColor: AppColors.primary,
                              value: widget.taskCompleted,
                              onChanged: (bool? value) {
                                if (widget.onChanged != null) {
                                  widget.onChanged!(value, widget.task);
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: widget.task.taskSubtasks.isNotEmpty,
                            child: Expanded(
                              child: buildText(
                                  '${widget.task.taskSubtasks.length}+',
                                  AppColors.textWhite,
                                  AppSizes.textSmall,
                                  FontWeight.normal,
                                  TextAlign.left,
                                  TextOverflow.clip),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Edit or Delete Task
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          //SWORD NUMBER -----------------------------------------------------
                          buildText(
                              '${widget.task.taskLabel.baseSwords}',
                              AppColors.textWhite,
                              AppSizes.textLarge,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip),
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
                                            Get.to(() => EditTaskPage(
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
                                            if (widget.detailDialogFunction !=
                                                null) {
                                              widget.detailDialogFunction!(
                                                  widget.task);
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

                                // Info button
                                Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          if (widget.detailDialogFunction !=
                                              null) {
                                            widget.detailDialogFunction!(
                                                widget.task);
                                          }
                                        },
                                        color: AppColors.light,
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.1),
                              ),
                              child: buildText(
                                  widget.task.taskStatus.label,
                                  AppColors.textWhite,
                                  AppSizes.textLarge,
                                  FontWeight.bold,
                                  TextAlign.start,
                                  TextOverflow.clip,
                                  maxLines: 1),
                            ),
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
                          Expanded(
                            child: Container(
                                //padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: Column(
                                  children: [
                                    // Task Deadline
                                    Visibility(
                                      visible: widget.task.taskDeadline != null,
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today_rounded,
                                              color:
                                                  AppColors.primaryBackground),
                                          5.width_space,
                                          Expanded(
                                            child: buildText(
                                                DateFormat('MMM d').format(widget
                                                        .task.taskDeadline ??
                                                    DateTime
                                                        .now()), // won't show the null case because of Visibility widget above
                                                AppColors.lightGrey,
                                                AppSizes.textSmall,
                                                FontWeight.w400,
                                                TextAlign.start,
                                                TextOverflow.clip,
                                                maxLines: 1),
                                          )
                                        ],
                                      ),
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
                          taskIndex: widget.task.taskSubtasks.indexOf(child),
                          detailDialogFunction: widget.detailDialogFunction,
                        )
                    ],
                  ),
                )),
          );
        });
  }
}
