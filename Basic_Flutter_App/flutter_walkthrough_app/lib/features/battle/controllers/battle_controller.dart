// battle_viewmodel.dart
import 'package:test_app/features/battle/models/battle_model.dart';
import 'dart:math';

class BattleViewModel {
  final BattleModel _model = BattleModel();

  int get userHealth => _model.userHealth;
  int get botHealth => _model.botHealth;
  int get currentTurn => _model.currentTurn;

  void userAttack(int damage) {
    _model.botHealth = (_model.botHealth - damage).clamp(0, 100);
    if (_model.botHealth > 0) {
      _model.currentTurn = 1;
    }
  }

  void botAttack(int damage) {
    _model.userHealth = (_model.userHealth - damage).clamp(0, 100);
    if (_model.userHealth > 0) {
      _model.currentTurn = 0;
    }
  }

  void botRandomAttack() {
    int min = 20; // inclusive
    int max = 50; // exclusive

    // Create a new Random object
    Random rnd = Random();

    // Generate a random integer between min (inclusive) and max (exclusive) for damage
    int damage = min + rnd.nextInt(max - min);

    _model.userHealth = (_model.userHealth - damage).clamp(0, 100);
    if (_model.userHealth <= 0) {
      resetGame();
      // Handle game over logic
    }
  }

  bool isGameOver() {
    return _model.userHealth == 0 || _model.botHealth == 0;
  }

  void resetGame() {
    _model.userHealth = 100;
    _model.botHealth = 100;
    _model.currentTurn = 0;
  }
}
