import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:test_app/features/game/components/bot_avatar.dart';
import 'package:test_app/features/game/components/bot_chat.dart';
import 'package:test_app/features/game/play_session/game_page.dart';
import 'package:test_app/features/game/screens/game_main_screen.dart';
import 'package:test_app/features/game/screens/trial_screen.dart';
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
  //late AttackWindow attackWindow;
  

  // eventually will use a healthBar component instead of text
  late TextComponent botHealthText; 
  late TextComponent userHealthText;

  // Chat component -> will toggle on/off based on turn
  late BotChat botChat; 

  int userHealth = 100;
  int currentTurn = 0; //Means it's the user's turn FIRST

  bool gameOver = false;
  bool showingGameOverScreen = false;

  @override
  Future<void> onLoad() async {
    //ADD ROUTES TO NAVIGATE BETWEEN SCREENS
    add(
      router = RouterComponent(
        routes: {
          'main': Route(GameMainScreen.new),
          'level1': Route(Level1Page.new, transparent: true),
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

    
    checkGameOver();
    if (gameOver && !showingGameOverScreen) {
      router.pushNamed('gameover');
      showingGameOverScreen = true;
    }
    super.update(dt);
  }

  // FUNCTIONS
  void userAttack() {
    bot.setHealth(10); // Reducing bot health by a fixed amount
    botHealthText.text = "Bot Health: ${bot.getHealth()}";
    checkGameOver();
    if (bot.getHealth() > 0) {
      currentTurn = 1; // Switch turn to bot
      botAttack(); // Directly call for simplification, can be event-driven
    }
  }

  void botAttack() {
    userHealth -= 15;
    userHealthText.text = "User Health: $userHealth";
    checkGameOver();
    if (userHealth > 0) {
      currentTurn = 0; // Switch turn to user
    }
  }

  void checkGameOver() {
    if (userHealth <= 0) {
      gameOverScreen("Bot wins!");
      //gameOver = true;
    } else if (bot.getHealth() <= 0) {
      gameOverScreen("User wins!");
      //gameOver = true;
    }
  }

  void gameOverScreen(String message) {
    Get.snackbar("Game Over", message, snackPosition: SnackPosition.BOTTOM);
    Get.offAll(() => GamePage()); // Restart game or go to main menu
  }
}

