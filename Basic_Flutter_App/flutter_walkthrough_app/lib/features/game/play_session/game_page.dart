import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:test_app/features/game/titan_game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final game = TitanGame();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("My Game"),
      // ),
      body: GameWidget<TitanGame>(
        game: game,
        //initialActiveOverlays: const [MainMenuScreen.id],
        // overlayBuilderMap: {
        //   //This is where you create your overlays.
        //   'mainMenu': (context, _) => MainMenuScreen(game: game),
        //   'gameOver': (context, _) => GameOverScreen(game: game),
        // },
      ),
    );
  }
}
