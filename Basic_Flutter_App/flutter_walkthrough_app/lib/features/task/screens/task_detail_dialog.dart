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
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${currentTask.taskStatus.label}"),
                    ),

                    Padding(
                      // name
                      padding: const EdgeInsets.all(8.0),
                      child: Text(currentTask.taskName ?? "Name"),
                    ),
                  ],
                ),
                Text(
                  currentTask.clockRunning ? 'Clocked In' : 'Clocked Out',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            content: Column(children: [
              // Deadline
              Padding(
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

              // Description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: buildText(
                      "Description: ${currentTask.taskDescription}",
                      AppColors.textPrimary,
                      AppSizes.textMedium,
                      FontWeight.normal,
                      TextAlign.center,
                      TextOverflow
                          .visible), // by default, wraps to multiple lines
                ),
              ),

              // total time
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text("Total Time: ${currentTask.totalTime_minutes} mins"),
              ),

              // clock entries
              for (List<DateTime?> clockPair in currentTask.clockList)
                TimeclockTile(clockPair: clockPair)

              // TODO use ListView.separated below when we move showTaskDetail() away from an alert dialog
              // ListView.separated(
              //   padding: const EdgeInsets.all(8),
              //   itemCount: currentTask.clockList.length,
              //   itemBuilder: (context, index) {
              //     return TimeclockTile(
              //         clockPair: currentTask.clockList[index]);
              //   },
              //   separatorBuilder: (context, index) => const Divider(),
              // )
            ]),
            actions: [
              // clock in/out
              TextButton(
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
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Okay'))
                                  ],
                                ));
                      }
                    });
                  }
                },
                child: Text("Clock In"),
              ),

              TextButton(
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
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Okay'))
                                  ],
                                ));
                      }
                    });
                  }
                },
                child: Text("Clock Out"),
              ),
            ],
          );
        });
      });
}
