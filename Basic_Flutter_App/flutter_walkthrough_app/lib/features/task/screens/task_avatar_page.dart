import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/features/task/controllers/task_controller.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/device/device_utility.dart';

class TaskAvatarView extends StatelessWidget {
  const TaskAvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    //Import all the data
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();
    TaskList taskList = db.listOfTaskLists[taskListIndex];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageStrings.avatarBackground),
          fit: BoxFit.cover,
        ),
      ),
      //color: Colors.lightGreen,
      child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[taskList] + taskList.list),
          // listenable: taskList,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: [
                //Task Details Background (Orange Background)
                Positioned(
                  top: 80,
                  left: 50,
                  child: Image(
                    image:
                        AssetImage("assets/images/backgrounds/task_info.png"),
                  ),
                ),

                //Task Details
                Positioned(
                  top: 88,
                  left: 58,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //- TASKS COMPLETED
                      Text(
                          taskList.list
                              .where((element) =>
                                  element.taskStatus == TaskStatus.DONE)
                              .toList()
                              .length
                              .toString(),
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Image(
                        image: AssetImage("assets/images/backgrounds/line.png"),
                      ),
                      //- TASKS TOTAL
                      Text(taskList.list.length.toString(),
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                //Task Details CheckMark Icon
                Positioned(
                  top: 80,
                  left: 110,
                  child: Image(
                    image:
                        AssetImage("assets/images/backgrounds/completion_icon.png"),
                  ),
                ),
                
                //STREAK
                Positioned(
                  top: 80,
                  left: 270,
                  child: Image(
                    image: AssetImage("assets/images/backgrounds/streak1.png"),
                  ),
                ),

                //Avatar
                Positioned(
                    //Positioned vs Align: Use Positioned for precise formatting on the screen
                    top: 160,
                    left: AppDeviceUtils.getScreenWidth(context) / 2 - 50,
                    child: SvgPicture.asset(
                      //TaskAvatarController.getAvatarImagePath(int completedTasks, int totalTasks)
                      TaskController.getAvatarImagePath(
                        //Completed Tasks
                        taskList.list
                              .where((element) =>
                                  element.taskStatus == TaskStatus.DONE)
                              .toList()
                              .length, 
                        //Total Tasks
                        taskList.list.length),
                      height: 130,
                      width: 130,
                    )),

                //Task Count
                Align(
                  alignment: Alignment.bottomCenter,
                  //Task Stats

                  child: Row(),
                ),
              ],
            );
          }),
    );
  }
}
