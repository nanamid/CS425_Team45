import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/features/game/controllers/game_controller.dart';
import 'package:test_app/features/game/views/game_attack_view.dart';
import 'package:test_app/utils/device/device_utility.dart';

class MainBattleView extends StatefulWidget {
  const MainBattleView({super.key});

  @override
  State<MainBattleView> createState() => _MainBattleViewState();
}

class _MainBattleViewState extends State<MainBattleView> {
  final GameController _gameController = Get.put(GameController());

  String buttonText = 'Attack';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.pause),
          onPressed: () => _showPauseMenu(context),
        ),
        title: Text('Battle Start'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //BOT UI
          Expanded(flex: 3, child: _botInterface()),

          //GAME WINDOW
          Expanded(
              flex: 4,
              child: Container(
                color: Colors.blue,
              )),

          //USER UI
          Expanded(flex: 3, child: _userInterface()),

          //USER ACTIONS
          Expanded(flex: 2, child: _userActions()),
        ],
      )),
    );
  }

  Container _botInterface() {
  return Container(
    color: Colors.orange,
    width: AppDeviceUtils.getScreenWidth(context),
    child: Obx(() => Text('Bot Health: ${_gameController.botHealth}')),
  );
}

Container _userInterface() {
  return Container(
    color: Colors.green,
    width: AppDeviceUtils.getScreenWidth(context),
    child: Obx(() => Text('User Health: ${_gameController.playerHealth}')),
  );
}


  Container _userActions() {
  return Container(
    color: Colors.pink,
    child: Center(
      child: ElevatedButton(
        onPressed: () => onAttackPressed(), // Updated line
        child: Text(buttonText),
      ),
    ),
  );
  }



  void onAttackPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AttackWindowView(); // No need to pass the controller as it's being accessed directly within AttackWindowView
      },
    ).then((_) {
      setState(
          () {}); // If you need to update the state based on the outcome of the dialog
    });
  }

  void _showPauseMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 40), // Adjust to screen size
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'You paused the game',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Handle exit action
                        Navigator.pop(context); // Close the dialog
                        Navigator.pop(context); // Return to the BattleStartPage
                      },
                      child: Text('Exit'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // Text color
                        backgroundColor: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle resume action
                        Navigator.pop(context); // Just close the dialog
                      },
                      child: Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                        foregroundColor: Colors.white, // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
