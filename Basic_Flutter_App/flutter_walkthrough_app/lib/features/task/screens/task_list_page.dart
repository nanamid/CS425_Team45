import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/features/task/screens/task_tile_view.dart';
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
  List<int> testing = [1,2,3];

  @override
  Widget build(BuildContext context) {
    //TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          //color: testing.clrLvl2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: testing.isNotEmpty

          //Task List HAS ITEMS
          ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(15),
              separatorBuilder: (context, index) =>
                  10.height_space, //use space extenion here "15.height_space"
              itemCount: testing.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    HapticFeedback.mediumImpact();
                    //testing.deleteTask(index);
                    
                    setState(() {testing.removeAt(index); // Modify the list inside setState
                     });
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
                    child: TaskTileView(),
                  ),
                );
              },
            )
          :
          //Task List IS EMPTY | if All Tasks Done Show this Widgets
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //Output if the list IS EMPTY
              children: [
                //Lottie Animation
                FadeIn(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(ImageStrings.noTasksAnimation,
                        animate: testing.isNotEmpty
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
}
