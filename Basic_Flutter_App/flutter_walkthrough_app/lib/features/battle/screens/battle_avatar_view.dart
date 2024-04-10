import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_app/features/battle/screens/battle_start_view.dart';
import 'package:test_app/features/task/controllers/task_avatar_controller.dart';

class BattlePage extends StatelessWidget {
  BattlePage({super.key});
  //to show overlay (toggle the overlay on or off)
  //var _overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Battle Title
            Text("Are you ready to battle?"),

            //Avatar View
            SvgPicture.asset(
              //Create a function that gets the total tasks and remaining tasks
              TaskAvatarController.getAvatarImagePath(1, 8),
              height: 120,
              width: 120,
            ),

            //BUTTON
            ElevatedButton(
              onPressed: () {
                showBattleLoadingOverlay(context);
              },
              child: Text('Start Battle'),
            ),
          ],
        ),
      ),
    );
  }

  void showBattleLoadingOverlay(BuildContext context) {
    OverlayEntry loadingOverlay;
    loadingOverlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.red,
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
    Future.delayed(Duration(seconds: 1), () {
      loadingOverlay.remove();

      //Navigate to Battle Start Page
      Get.to(() => BattleStartView());
    });
  }
}
