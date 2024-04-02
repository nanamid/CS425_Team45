import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_app/common/widgets/build_text.dart';
import 'package:test_app/features/task/controllers/task_avatar_controller.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/constants/sizes.dart';
import 'package:test_app/utils/device/device_utility.dart';

class TaskAvatarView extends StatelessWidget {
  const TaskAvatarView({super.key});

  @override
  Widget build(BuildContext context) {

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
          //Avatar
          Positioned( //Positioned vs Align: Use Positioned for precise formatting on the screen
              top: 200,
              left: AppDeviceUtils.getScreenWidth(context) / 2 - 50,
              child: SvgPicture.asset(

                //Create a function that gets the total tasks and remaining tasks
                TaskAvatarController.getAvatarImagePath(1, 8),
                height: 120,
                width: 120,
              )),

         

          //Task Count
          Align(
            alignment: Alignment.bottomCenter,
            //Task Stats

            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: buildText(
                        "Total Tasks: ${TaskAvatarController.totalTasks}",
                        Colors.white,
                        AppSizes.textLarge,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip)),
                Expanded(
                    flex: 2,
                    child: buildText(
                        "Remaining Tasks: ${TaskAvatarController.remainingTasks}",
                        Colors.white,
                        AppSizes.textLarge,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
