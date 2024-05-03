
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_app/data/database.dart';
import 'package:test_app/data/tasklist_classes.dart';
import 'package:test_app/features/game/views/game_page.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/formatters/space_extension.dart';

class StartBattleView extends StatelessWidget {
  StartBattleView({super.key});

  @override
  Widget build(BuildContext context) {
    TodoDatabase db = TodoDatabase();
    final taskListIndex = 0; // hardcoded one tasklist for now
    db.loadData();
    TaskList taskList = db.listOfTaskLists[taskListIndex];
  //final TaskController controller = Get.find<TaskController>();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/Menu.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[taskList] + taskList.list),
          // listenable: taskList,
          builder: (BuildContext context, Widget? child) {
            return Stack(
          children: [
            Positioned(
              bottom: -20,
              left: 110,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Image.asset(
                  'assets/images/backgrounds/play_button.png',
                  width: 200,
                  height: 200,
                ),
                iconSize: 5, // Optional, depending on your needs
                onPressed: () {
                  print('Image Button Pressed!');
                  showBattleLoadingOverlay(context);
                },
              ),
            ),
            Positioned(
                    top: 555,
                    left: 250,
                    child: Text(taskList.list
                              .where((element) =>
                                  element.taskStatus == TaskStatus.DONE)
                              .fold(
                                  0,
                                  (sum, task) =>
                                      sum + (task.taskLabel.baseSwords ?? 0))
                              .toString(), //${controller.totalSwords}
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                          //fontFamily: 'Bebas Neue',
                          fontWeight: FontWeight.w800,)),
                    // child: Obx(() =>Text("11", //${controller.totalSwords}
                    //   style: TextStyle(
                    //       fontSize: 45,
                    //       color: Colors.white,
                    //       //fontFamily: 'Bebas Neue',
                    //       fontWeight: FontWeight.w800,))),
                  ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Battle Title
                  //Text("Are you ready to battle?"),
                  50.height_space,
                  SvgPicture.asset(
                    'assets/images/backgrounds/start_battle.svg',
                    height: 180,
                    width: 180,
                  ),
                  30.height_space,

                  //Avatar View
                  SvgPicture.asset(
                    //Create a function that gets the total tasks and remaining tasks
                    ImageStrings.avatarHappy, //controller.avatarImagePath.value,
                    height: 200,
                    width: 200,
                  ),
                  // Obx(() => SvgPicture.asset(
                  //   //Create a function that gets the total tasks and remaining tasks
                  //   controller.avatarImagePath.value, //controller.avatarImagePath.value,
                  //   height: 200,
                  //   width: 200,
                  // )),

                  //Swords Left
                  SvgPicture.asset(
                    'assets/images/backgrounds/swords_left1.svg',
                    height: 120,
                    width: 120,
                  ),
                  
                  50.height_space,
                ],
              ),
            ),
          ],
        );
          },
        ),
      ),
    );
  }

  

  void showBattleLoadingOverlay(BuildContext context) {
    OverlayEntry loadingOverlay;
    loadingOverlay = OverlayEntry(
      builder: (context) {
        return Container(
          //color: Colors.red,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/Menu.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Insert loading overlay
    Overlay.of(context).insert(loadingOverlay);

    // Remove loading overlay and navigate to battle start page after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      loadingOverlay.remove();


      //This navigate page is what allows the back button to exists on the app bar
      //Navigate to Battle Main Page
      Get.to(() => GamePage());
    });
  }
}