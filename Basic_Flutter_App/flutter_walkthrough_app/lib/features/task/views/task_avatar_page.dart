import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_app/features/task/controllers/task_controller.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/device/device_utility.dart';


class TaskAvatarView extends StatelessWidget {
  const TaskAvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageStrings.avatarBackground),
            fit: BoxFit.cover,
          ),
        ),
        //color: Colors.lightGreen,
        child: Stack(
          children: [
            //Task Details Background
            Positioned(
              top: 80,
              left: 50,
              child: Image(
                image: AssetImage("assets/images/backgrounds/task_info.png"),
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
                  Obx(() =>Text("${controller.numTasksCompleted}",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))),
                  Image(
                    image: AssetImage("assets/images/backgrounds/line.png"),
                  ),
                  //- TASKS TOTAL
                  Obx(() =>Text("${controller.numTasks}",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))),
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
            /*
              Create a function where if the user completes at least 1 task, the streak is completed that day
              if not, the streak changes nothing to it.
           */
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
                top: 180,
                left: AppDeviceUtils.getScreenWidth(context) / 2 - 50,
                child: Obx(() => SvgPicture.asset(
                  controller.avatarImagePath.value,
                  // //Create a function that gets the total tasks and completed tasks
                  // TaskController.getAvatarImagePath(controller.numTasksCompleted.value,
                  //     controller.numTasks.value), //(int remaining, int total)
                  height: 120,
                  width: 120,
                ))),

            //Task Count
            Align(
              alignment: Alignment.bottomCenter,
              //Task Stats

              child: Row(),
            ),
          ],
        ),
      );
    }
  }
