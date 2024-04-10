import 'dart:math';
import 'package:get/get.dart';

class GameController extends GetxController {
  // Observables
  var playerHealth = 100.obs;
  var botHealth = 100.obs;
  var currentTurn = 0.obs; // 0 for player's turn, 1 for bot's turn
  
  // Random number generator for bot attacks
  final _random = Random();

  // Method to handle player's attack
  void playerAttack(int damage) {
    if (currentTurn.value == 0) { // Ensure it's the player's turn
      botHealth.value -= damage;
      currentTurn.value = 1; // Change turn to bot
      if (botHealth.value <= 0) {
        // Game over, player wins
        Get.snackbar('Game Over', 'You have won!');
        // Navigate back to StartBattleView after a short delay
        Future.delayed(Duration(seconds: 1), () {
          resetGame(); // Reset the game before navigating
          
          //Get.off(() => StartBattleView()); // Make sure to import StartBattleView
        });
      } else {
        // Proceed with the bot's turn after a delay
        Future.delayed(Duration(seconds: 1), () {
          botAttack();
        });
      }
    }
  }


  // Method to simulate bot's attack
  void botAttack() {
    if (currentTurn.value == 1) { // Ensure it's the bot's turn
      int damage = _random.nextInt(5) + 1; // Generate random damage between 1 and 5
      playerHealth.value -= damage;
      currentTurn.value = 0; // Change turn back to player
      if (playerHealth.value <= 0) {
        // Game over, bot wins
        Get.snackbar('Game Over', 'The bot has won!');
        resetGame();
      }
    }
  }

  // Method to reset the game
  void resetGame() {
    playerHealth.value = 100;
    botHealth.value = 100;
    currentTurn.value = 0;
    // Optionally navigate to a different screen or refresh the current game view
  }

  int isGameOver() {
    if (playerHealth.value <= 0) {
      return 1; // Bot wins
    } else if (botHealth.value <= 0) {
      return 0; // Player wins
    } else {
      return -1; // Game still in progress
    }
  }
}
