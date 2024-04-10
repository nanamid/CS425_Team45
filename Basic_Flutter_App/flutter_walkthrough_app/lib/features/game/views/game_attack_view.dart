import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/features/game/controllers/game_controller.dart';

class AttackWindowView extends StatefulWidget {
  @override
  _AttackWindowViewState createState() => _AttackWindowViewState();
}

class _AttackWindowViewState extends State<AttackWindowView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  double _score = 0;
  final GameController _gameController = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      //duration refers to how fast the line moves accross the screen
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    //Make sure to adjust the Tween to be the same as the number of attack zones
    _animation = Tween(begin: -1.0, end: 0.6).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  
  void _stopAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _score = calculateScore(_animation.value);
        });
      }

      // Adding a delay before closing the dialog and applying damage
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          // Check again if the widget is still mounted
          // Apply score as damage
          _gameController.playerAttack(_score.toInt());
          // Close the dialog after the delay
          Navigator.of(context).pop();
        }
      });
    } else {
      _controller.repeat(reverse: true);
    }
  }

  double calculateScore(double value) {
    //For all the rectangles on the right, use the right edge as the value and left for left rectangles.

    if (value >= -0.25 && value <= -0.15) {
      return 50.0;
    } else if (value >= -0.4 && value <= -0.01) {
      return 30.0;
    } else if (value >= -0.6 && value <= 0.2) {
      return 15.0;
    } else {
      return 10.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: _stopAnimation,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Time to slay your enemy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        attackZone(10, Colors.blue, 5),
                        attackZone(15, Colors.green, 3),
                        attackZone(30, Colors.red, 2),
                        attackZone(50, Colors.yellow, 1),
                        attackZone(30, Colors.red, 2),
                        attackZone(15, Colors.green, 3),
                        attackZone(10, Colors.blue, 5),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      // Calculate the width of the entire row of attack zones.
                      // We assume there's some padding outside of this that we don't want the line to enter.
                      double containerWidth =
                          MediaQuery.of(context).size.width -
                              40; // Adjust the 40 if you have more/less padding
                      // This calculation ensures the center of the line stays within the desired width.
                      // The '2.5' represents half the width of the line to adjust for its own width.
                      double leftPosition =
                          ((containerWidth / 2) - 2.5) * (_animation.value + 1);
                      // Ensure the line doesn't go off the edge.
                      // The line's width is taken into account to prevent the visual part of the line from going out of bounds.
                      leftPosition =
                          leftPosition.clamp(0.0, containerWidth - 5.0);

                      return Positioned(
                        left: leftPosition,
                        child: child!,
                      );
                    },
                    child: Container(
                      width: 5,
                      height: 50,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text('Score: $_score',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget attackZone(int score, Color color, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        color: color,
        alignment: Alignment.center,
        child: Text(score.toString(),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
    );
  }
}
