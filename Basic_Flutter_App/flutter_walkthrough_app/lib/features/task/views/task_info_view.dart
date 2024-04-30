import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/features/task/controllers/task_controller.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/formatters/space_extension.dart';


class TaskInfoView extends StatelessWidget {
  const TaskInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();
      return Container(
        decoration: BoxDecoration(
          color: AppColors.secondary,
        ),
        child: Stack(
          //First Row
          children: [
            Positioned(
              left: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Date Divider
                  Image(
                    image: AssetImage("assets/images/backgrounds/date-box.png"),
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

                  //TASK FILTER POPUP MENU
                  PopupMenuButton<TaskFilter>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: AppColors.light,
                    elevation: 1,
                    onSelected: (TaskFilter result) {
                      controller.changeFilter(result);  // Using the controller to change the filter
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskFilter>>[
                    PopupMenuItem<TaskFilter>(
                      value: TaskFilter.today,
                        child: Row(
                          children: [
                            Icon(Icons.today),
                            10.width_space,
                            Text('Today')
                          ],
                        ),
                      ),
                      PopupMenuItem<TaskFilter>(
                        value: TaskFilter.thisWeek,
                        child: Row(
                          children: [
                            Icon(Icons.view_week),
                            10.width_space,
                            Text('This Week')
                          ],
                        ),
                      ),
                      PopupMenuItem<TaskFilter>(
                        value: TaskFilter.completed,
                        child: Row(
                          children: [
                            Icon(Icons.done_all),
                            10.width_space,
                            Text('Completed')
                          ],
                        ),
                      ),
                    ],
                    child: Obx(() =>Image( //Making this Obx because it resides in stateless widget
                      image:  AssetImage(TaskController.getFilterImagePath(controller.filter.value)),
                      height: 35,
                    )),
                  ),

                  //This image will be the child icon of the pop up menu
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
                  Obx(() =>Text("${controller.totalSwords}",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))),
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
        ),
      );
    }
  }