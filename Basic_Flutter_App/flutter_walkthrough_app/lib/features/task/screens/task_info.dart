import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/formatters/space_extension.dart';

class TaskInfoView extends StatelessWidget {
  const TaskInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();
    TaskList taskList = db.listOfTaskLists[taskListIndex];
    return Container(
        decoration: BoxDecoration(
          color: AppColors.secondary,
        ),
        child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[taskList] + taskList.list),
          // listenable: taskList,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: [
                Positioned(
                  left: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Date Divider
                      Image(
                        image: AssetImage(
                            "assets/images/backgrounds/date-box.png"),
                        height: 40,
                      ),
                      5.width_space,
                      //Date Text
                      Text(DateFormat.MMMMEEEEd().format(DateTime.now()),
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontFamily: 'Bebas Neue',
                              fontWeight: FontWeight.bold)),
                      95.width_space,
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage(
                            "assets/images/backgrounds/tasks_big_icon.png"),
                        height: 40,
                      ),
                      150.width_space,
                      //Swords TEXT
                      Text(
                          taskList.list
                              .where((element) =>
                                  element.taskStatus == TaskStatus.DONE)
                              .fold(
                                  0,
                                  (sum, task) =>
                                      sum + (task.taskLabel.baseSwords ?? 0))
                              .toString(),
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                //Swords
                Positioned(
                  top: 44,
                  right: 40,
                  child: SvgPicture.asset(
                    'assets/images/backgrounds/sword_left_icon.svg',
                    height: 50,
                    width: 50,
                  ),
                )
              ],
            );
          },
        ));
  }
}
