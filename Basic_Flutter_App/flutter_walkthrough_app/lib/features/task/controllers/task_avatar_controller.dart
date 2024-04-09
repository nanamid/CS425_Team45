import 'package:get/get.dart';
import 'package:test_app/utils/constants/image_strings.dart';

class TaskAvatarController extends GetxController {
  static const int totalTasks = 10;
  static const int remainingTasks = 5;

  //This function returns the avatar image path based on the remaining tasks and total tasks
  static String getAvatarImagePath(int remainingTasks, int totalTasks) {
      double percentageOfTasksCompleted = (remainingTasks / totalTasks) * 100;
      final now = DateTime.now();
      final currentHour = now.hour;

      if (currentHour >= 8 && currentHour < 12) {
        return ImageStrings.avatarHappy;
      } else if (currentHour >= 12 && currentHour < 17) {
        if (percentageOfTasksCompleted >= 70) {
          return ImageStrings.avatarInLove;
        } else if (percentageOfTasksCompleted < 70 && percentageOfTasksCompleted >= 50) {
          return ImageStrings.avatarSemiHappy;
        } else if (percentageOfTasksCompleted < 25) {
          return ImageStrings.avatarAnnoyed;
        } else {
          return ImageStrings.avatarHappy;
        }
      } else if (currentHour >= 17 && currentHour < 22) {
        if (percentageOfTasksCompleted >= 70) {
          return ImageStrings.avatarInLove;
        } else if (percentageOfTasksCompleted < 70 && percentageOfTasksCompleted >= 50) {
          return ImageStrings.avatarAnnoyed;
        } else if (percentageOfTasksCompleted <= 25) {
          return ImageStrings.avatarAngry;
        } else {
          return ImageStrings.avatarHappy;
        }
      } else {
        //Default Avatar
        return ImageStrings.avatarHappy;
      }
    }

}
