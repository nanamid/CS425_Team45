import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/features/game/screens/game_start_screen.dart';
import 'package:test_app/features/task/views/task_page.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/image_strings.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    //We are using the Scaffold widget to make use of the bottomNavigationBar property.
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          backgroundColor: AppColors.accent,
          height: 90,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(
              icon: Image.asset(ImageStrings.toDoIcon, width: 40, height: 40),
              label: "To Do",
            ),
            NavigationDestination(
              icon: Image.asset(ImageStrings.battleIcon,width: 40, height: 40),
              label: "Battle",
            ),
            NavigationDestination(
              icon: Image.asset(ImageStrings.addTaskIcon, width: 50, height: 50),
              label: "Add Task",
            ),
            NavigationDestination(
              icon: Image.asset(ImageStrings.timerIcon, width: 40, height: 40),
              label: "Timer",
            ),
            NavigationDestination(
              icon: Image.asset(ImageStrings.slimeIcon, width: 40, height: 40),
              label: "Titan",
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    TasksPage(),
    StartBattleView(),
    Container(color: Colors.yellow),
    Container(color: Colors.purple),
    Container(color: Colors.pink),
  ];
}
