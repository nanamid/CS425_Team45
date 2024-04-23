import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_app/features/game/play_session/game_page.dart';
import 'package:test_app/features/task/controllers/task_avatar_controller.dart';
import 'package:test_app/utils/formatters/space_extension.dart';

class StartBattleView extends StatelessWidget {
  StartBattleView({super.key});
  //to show overlay (toggle the overlay on or off)
  //var _overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
              Positioned(
                      bottom: -20,
                      left: 110,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Image.asset('assets/images/backgrounds/play_button.png', 
                          width: 200, height: 200,),
                        iconSize: 5, // Optional, depending on your needs
                        onPressed: () {
                          print('Image Button Pressed!');
                          showBattleLoadingOverlay(context);
                        },
                      ),
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
                        TaskAvatarController.getAvatarImagePath(1, 8),
                        height: 200,
                        width: 200,
                      ),
                          
                      //Swords Left
                      SvgPicture.asset(
                        'assets/images/backgrounds/swords_left.svg',
                        height: 120,
                        width: 120,
                      ),
                      50.height_space,
                      
                      //Text("Swords Left: 3"),
                      
                      //BUTTON
                      // ElevatedButton(
                      //   onPressed: () {
                      //     showBattleLoadingOverlay(context);
                      //   },
                      //   child: Text('Start Battle'),
                      // ),
                    ],
                  ),
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

      //Navigate to Battle Main Page
      Get.to(() => GamePage());
    });
  }
}
