import 'package:flutter/material.dart';
import 'package:test_app/features/battle/controllers/battle_controller.dart';
import 'package:test_app/features/battle/screens/battle_attack_popup_view.dart';
import 'package:test_app/utils/device/device_utility.dart';

class BattleStartView extends StatefulWidget {
  const BattleStartView({super.key});

  @override
  State<BattleStartView> createState() => _BattleStartViewState();
}

class _BattleStartViewState extends State<BattleStartView> {
  final BattleViewModel _battleController = BattleViewModel();
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
      child: Text('Bot Health: ${_battleController.botHealth}'),
    );
  }

  Container _userInterface() {
    return Container(
      color: Colors.green,
      width: AppDeviceUtils.getScreenWidth(context),
      child: Text('User Health: ${_battleController.userHealth}'),
    );
  }

  Container _userActions() {
    return Container(
      color: Colors.pink,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            //USER TURN
            onAttackPressed();

            //BOT TURN
          },
          child: Text('Attack'),
        ),
      ),
    );
  }


  void onAttackPressed() {
    // Open a rectangle window (e.g., dialog) for the game
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.only(bottom: 40), // Padding from the screen edges
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, // Background color for the game window
              borderRadius: BorderRadius.circular(10),
            ),
            child: AttackPopUpView(
                viewModel: _battleController), // Pass the controller
          ),
        );
      },
    ).then((_) => setState(() {}));
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
