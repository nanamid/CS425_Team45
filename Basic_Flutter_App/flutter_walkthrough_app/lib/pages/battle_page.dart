import 'package:flutter/material.dart';
import 'package:test_app/data/avatar.dart';
import 'package:test_app/utils/battle_logic.dart';

class BattlePage extends StatefulWidget {
  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  late Avatar userAvatar;
  late Avatar botAvatar;
  late Battle battle;
  String battleLog = "";
  int turnCounter = 1;

  @override
  void initState() {
    super.initState();
    // Initialize user and bot avatars with example values
    userAvatar = Avatar(name: "User Titan", health: 100, attackPower: 2);
    botAvatar = Avatar(name: "Bot Titan", health: 100, attackPower: 1);
    battle = Battle(user: userAvatar, bot: botAvatar);
  }

  void performAttack() {
    setState(() {
      int userDamage = battle.attack(userAvatar, botAvatar);
      String userAttackLog =
          "Turn $turnCounter: User attacks bot for $userDamage damage. Bot health is now ${botAvatar.health}.\n";

      if (botAvatar.health <= 0) {
        battleLog += userAttackLog + "User wins!\n";
        return; // End function early if bot is defeated
      }

      int botDamage = battle.attack(botAvatar, userAvatar);
      String botAttackLog =
          "Turn $turnCounter: Bot attacks user for $botDamage damage. User health is now ${userAvatar.health}.\n";

      battleLog += userAttackLog + botAttackLog;

      if (userAvatar.health <= 0) {
        battleLog += "Bot wins!\n";
        return; // End function early if user is defeated
      }

      turnCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Battle Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("User Health: ${userAvatar.health}",
                style: TextStyle(fontSize: 18)),
            Text("User Attack Power: ${userAvatar.attackPower}x",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Bot Health: ${botAvatar.health}",
                style: TextStyle(fontSize: 18)),
            Text("Bot Attack Power: ${botAvatar.attackPower}x",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: botAvatar.health <= 0 || userAvatar.health <= 0
                  ? null
                  : performAttack,
              child: Text("Attack"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(battleLog),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
