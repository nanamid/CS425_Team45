import 'dart:math';

import 'package:test_app/data/avatar.dart';

class Battle {
  Avatar user;
  Avatar bot;
  Random random = Random();

  Battle({required this.user, required this.bot});

  double calculateAttackPower(int xp) {
    if (xp >= 81) {
      return 5;
    } else if (xp >= 51) {
      return 3;
    } else if (xp >= 31) {
      return 2;
    } else {
      return 1;
    }
  }

  int attack(Avatar attacker, Avatar defender) {
    int diceRoll = random.nextInt(6) + 1; // Dice roll between 1 and 6
    int damage = (diceRoll * attacker.attackPower).round();
    defender.health = max(0, defender.health - damage);
    return damage;
  }

  bool battleTurn() {
    int userDamage = attack(user, bot);
    print(
        "User attacks bot for $userDamage damage. Bot health is now ${bot.health}.");
    if (bot.health <= 0) {
      print("User wins!");
      return true;
    }

    int botDamage = attack(bot, user);
    print(
        "Bot attacks user for $botDamage damage. User health is now ${user.health}.");
    if (user.health <= 0) {
      print("Bot wins!");
      return true;
    }

    return false; // Continue the battle
  }
}
