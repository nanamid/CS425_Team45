import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:get/get.dart';
import 'package:test_app/features/game/components/bot_avatar.dart';
import 'package:test_app/features/game/components/bot_chat.dart';
import 'package:test_app/features/game/components/user_avatar.dart';
import 'package:test_app/features/game/views/enemy_attack_window_view.dart';
import 'package:test_app/features/game/views/game_main_view.dart';
import 'package:test_app/features/game/views/game_over_view.dart';
import 'package:test_app/features/game/views/user_attack_window.dart';
// other imports as necessary

/*
    This is the main game class that will be used to control the game.
    It will contain all the game logic and components.
  */

class TitanGame extends FlameGame {
  // DECLARE ALL COMPONENTS - however, you only add() them to their respective screens

  TitanGame();

  //Router Component to move across multiple screens within the game
  late final RouterComponent router;

  // GAME COMPONENTS
  late BotAvatar bot;
  late UserAvatar user;
  //late AttackWindow attackWindow;

  // eventually will use a healthBar component instead of text
  late TextComponent botHealthText;
  late TextComponent userHealthText;

  //late DefenseWindow defenseWindow;

  // Chat component -> will toggle on/off based on turn
  late BotChat botChat;

  int userHealth = 100;
  int currentTurn = 0; //Means it's the user's turn FIRST

  bool gameOver = false;
  bool showingGameOverScreen = false;

  //final TaskController controller = Get.find<TaskController>();

  @override
  Future<void> onLoad() async {
    //ADD ROUTES TO NAVIGATE BETWEEN SCREENS
    add(
      router = RouterComponent(
        routes: {
          'main': Route(GameMainScreen.new),
          'user-attack': Route(UserAttackWindow.new, transparent: true),
          //'game-win': Route(GameWinScreen.new),
          'enemy-attack': Route(EnemyAttackWindow.new, transparent: true),
          'gameover': GameOverRoute(),
          //'gameover': Route(GameOverScreen.new),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'pause': PauseRoute(),
          // 'confirm-dialog': OverlayRoute.existing(),
          /*
            'unique-route-name': Route(YourWidget.new),
           */
        },
        initialRoute: 'main',
      ),
    );

    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    //checkGameOver();
    // if (gameOver && !showingGameOverScreen) {
    //   // router.pushNamed('gameover');
    //   showingGameOverScreen = true;
    //   //Navigate to Battle Main Page
    //   //Get.to(() => StartBattleView());
    // }
    // if (bot.getHealth() <= 0 || userHealth <= 0) {
    //   router.pushNamed('gameover');
    //   showingGameOverScreen = true;
    // }
    super.update(dt);
  }

  void checkGameOver() {
    if (user.getHealth() <= 0) {
      reset();
      gameOverScreen("Bot wins!");
      gameOver = false;
      reset();

      //gameOver = true;
    } else if (bot.getBotHealth() <= 0) {
      reset();
      gameOverScreen("User wins!");
      gameOver = false;
      reset();

      //gameOver = true;
    }
  }

  void reset() {
    user.setHealth(100);
    bot.setBotHealth(100);
    currentTurn = 0; //Means it's the user's turn FIRST
    gameOver = false;
  }

  void gameOverScreen(String message) {
    // reset();
    // gameOver = false;
    router.pushNamed('gameover');
    //controller.setTotalSwords(1);

    //await Future.delayed(Duration(seconds: 5)); // Wait for 1 second
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(Get.context!);
      //router.pushNamed('gameover');
      //Navigator.pop(Get.context!);
    });

    //Get.snackbar("Game Over", message, snackPosition: SnackPosition.BOTTOM);
  }

  int getXP() {
    Random random = Random();
    return 50 +
        random.nextInt(
            51); // random.nextInt(51) generates a random number from 0 to 50
  }

  void showGameOverOverlay(BuildContext context) {
    OverlayEntry loadingOverlay;
    loadingOverlay = OverlayEntry(
      builder: (context) {
        return Container(
          //color: Colors.red,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/game_over.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'You have earned 50 xP',
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
      Navigator.pop(Get.context!);
    });
  }
}
