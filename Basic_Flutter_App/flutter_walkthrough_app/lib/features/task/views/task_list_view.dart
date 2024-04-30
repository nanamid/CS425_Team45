import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/features/task/controllers/task_controller.dart';
import 'package:test_app/features/task/views/task_tile_view.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/text_strings.dart';
import 'package:test_app/utils/formatters/space_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  /*
     I am instantiating the instance of the taskController here
     Purpose: Get.put() is used to create and insert an instance of a dependency (usually a Controller) 
     into the GetX dependency injection system. This method ensures that the dependency is available to 
     be used throughout the app.

    I will use Get.find() in all the other files to access the taskController instance 
    because it is already created here:
    Purpose: Get.find() is used to find and retrieve an instance of a dependency that has already been registered in the GetX dependency injection system.
     
   */
  //final taskController = Get.put(TaskController());

  final TaskController controller = Get.find<TaskController>();
  

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filteredTasks.isEmpty) {
         //Task List IS EMPTY -> Lottie Animation | if All Tasks Done Show this Widgets
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //Output if the list IS EMPTY
            children: [
              //Lottie Animation
              FadeIn(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(ImageStrings.noTasksAnimation,
                      animate: controller.allTasks.isNotEmpty
                          ? false
                          : true), //Conditional is saying, play animation if testing is empty
                ),
              ),

              //Sub Text (under Lottie Animation)
              FadeInUp(
                from: 30,
                child: const Text(
                  AppTexts.doneAllTask,
                ),
              ),
            ],
          ),
        );
      }
      

      return Container(
    decoration: BoxDecoration(
        //color: testing.clrLvl2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        color: AppColors.secondary,
        ),
      child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(15),
            separatorBuilder: (context, index) => 10.height_space, //use space extenion here "15.height_space"
            
            itemCount: controller.filteredTasks.length, //controller.allTasks.length,
            itemBuilder: (context, index) {

              final task = controller.filteredTasks[index];

              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  HapticFeedback.mediumImpact();
                  controller.deleteTask(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task removed')),
                  );
                },
                background: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Icon(Icons.delete, color: Colors.red.shade700)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      //color: testing.clrLvl1,
                      borderRadius: BorderRadius.circular(20)),
                  child: TaskTileView(
                    taskInstance: task, //controller.allTasks[index],
                    index: index,
                  ),
                ),
              );
            },
          )
        );
    });
   }
  }
