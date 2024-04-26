import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/constants/text_strings.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/timeclock_tile.dart';
import 'package:test_app/features/task/screens/confirm_clockinout_dialogs.dart';

/// Spawns a dialog showing all task details
/// index is index of the selected task in the current task list
void showTaskDetail(BuildContext context, Task currentTask,
    bool Function(Task) clockIn, bool Function(Task) clockOut) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        // you have to wrap the alert dialog in a stateful builder to setState() correctly
        // normally AlertDialogs are stateless widgets
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade100,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // status
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                      child: buildText(
                          currentTask.taskStatus.label,
                          AppColors.textPrimary,
                          20,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.fade,
                          maxLines: 1),
                    ),

                    Expanded(
                      child: Padding(
                        // name
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: buildText(
                            currentTask.taskName,
                            AppColors.textPrimary,
                            24,
                            FontWeight.normal,
                            TextAlign.start,
                            TextOverflow.ellipsis,
                            maxLines: 1),
                      ),
                    ),
                  ],
                ),
                buildText(
                    currentTask.clockRunning ? 'Clocked In' : 'Clocked Out',
                    AppColors.textPrimary,
                    24,
                    FontWeight.normal,
                    TextAlign.start,
                    TextOverflow.fade,
                    maxLines: 1),
                Row(children: [
                  Icon(
                    Icons.label,
                    color: AppColors.secondary,
                  ),
                  5.width_space,
                  buildText(
                      currentTask.taskLabel.label,
                      AppColors.textPrimary,
                      AppSizes.textLarge,
                      FontWeight.bold,
                      TextAlign.start,
                      TextOverflow.fade,
                      maxLines: 1),
                ]),
              ],
            ),
            content: Container(
              width: double.maxFinite,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Deadline
                Visibility(
                  visible: currentTask.taskDeadline != null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildText(
                        currentTask.taskDeadline != null
                            ? 'Deadline: ${DateFormat('yMMMMd').format(currentTask.taskDeadline!)} ${DateFormat('Hm').format(currentTask.taskDeadline!)}'
                            : "",
                        AppColors.textPrimary,
                        AppSizes.textMedium,
                        FontWeight.normal,
                        TextAlign.center,
                        TextOverflow.ellipsis),
                  ),
                ),

                Divider(),

                // Description
                Visibility(
                  visible: currentTask.taskDescription != null,
                  child: Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildText(
                          "${currentTask.taskDescription}",
                          AppColors.textPrimary,
                          AppSizes.textMedium,
                          FontWeight.normal,
                          TextAlign.left,
                          TextOverflow.ellipsis),
                    ),
                  ),
                ),

                // total time
                Divider(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildText(
                      "Total Time: ${currentTask.totalTime.inHours.toString().padLeft(2, '0')}:${(currentTask.totalTime.inMinutes % 60).toString().padLeft(2, '0')}",
                      AppColors.textPrimary,
                      AppSizes.textLarge,
                      FontWeight.normal,
                      TextAlign.start,
                      TextOverflow.fade,
                      maxLines: 1),
                ),

                // clock entries
                // see https://stackoverflow.com/a/56355962 for how to make
                // this work in a showDialog
                Expanded(
                  flex: 3,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: currentTask.clockList.length,
                    separatorBuilder: (context, index) => 10.height_space,
                    itemBuilder: (context, index) => TimeclockTile(
                        clockPair:
                            currentTask.clockList.reversed.toList()[index]),
                  ),
                ),
              ]),
            ),
            actions: [
              // clock in/out
              Visibility(
                visible: currentTask.clockRunning ==
                    false, // can't clock in if we're already clocked in
                child: ElevatedButton(
                  // onPressed has to wrap the async future function with a void function
                  onPressed: () async {
                    // Ask for user confirmation
                    bool? confirmation = await confirmClockInDialog(context);

                    // catch async gap: https://dart.dev/tools/linter-rules/use_build_context_synchronously
                    if (!context.mounted) {
                      return;
                    }

                    if (confirmation == true) {
                      setState(() {
                        // not necessarily best practice to setState such a big function
                        bool success = clockIn(currentTask);
                        if (success == false) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Cannot Add Clock Entry'),
                                    content: Text('Already Clocked In'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Okay'))
                                    ],
                                  ));
                        }
                      });
                    }
                  },
                  child: buildText(
                      "Clock In",
                      AppColors.buttonPrimary,
                      AppSizes.textLarge,
                      FontWeight.bold,
                      TextAlign.start,
                      TextOverflow.fade,
                      maxLines: 1),
                ),
              ),

              Visibility(
                visible: currentTask
                    .clockRunning, // can't clock out unless we're clocked in
                child: ElevatedButton(
                  onPressed: () async {
                    // Ask for user confirmation
                    bool? confirmation = await confirmClockOutDialog(context);

                    // catch async gap: https://dart.dev/tools/linter-rules/use_build_context_synchronously
                    if (!context.mounted) {
                      return;
                    }

                    if (confirmation == true) {
                      setState(() {
                        // not necessarily best practice to setState such a big function
                        bool success = clockOut(currentTask);
                        if (success == false) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Cannot Add Clock Entry'),
                                    content: Text('Not Clocked In'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Okay'))
                                    ],
                                  ));
                        }
                      });
                    }
                  },
                  child: buildText(
                      "Clock Out",
                      AppColors.buttonPrimary,
                      AppSizes.textLarge,
                      FontWeight.bold,
                      TextAlign.start,
                      TextOverflow.fade,
                      maxLines: 1),
                ),
              ),
            ],
          );
        });
      });
}
