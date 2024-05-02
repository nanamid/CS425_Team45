import 'dart:ui';

import 'package:flame/components.dart';
import 'package:test_app/features/game/components/back_overlay.dart';
import 'package:test_app/features/game/components/damage_board.dart';
import 'package:test_app/features/game/components/sword.dart';
import 'package:test_app/features/game/titan_game.dart';

import 'package:flutter/rendering.dart';
import 'package:test_app/features/game/widgets/rounded_button.dart';

class Level1Page extends Component with HasGameReference<TitanGame> {
  late Sword sword;
  late DamageScoreboard scoreboard;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sword = Sword();
    scoreboard = DamageScoreboard();

    addAll([
      BackgroundOverlay(Color.fromARGB(101, 42, 7, 79)),
      AttackBox(const Color(0xff758f9a)),
      scoreboard, // Add the scoreboard to the game

      // Define buttons with updated actions
      RoundedButton(
        text: 'Back',
        action: () async {
          game.checkGameOver();
          applyBotDamage();
          await Future.delayed(Duration(seconds: 1)); // Wait for 1 second
          game.router.pop();
          sword.resetSword();
          int currentAttack = game.bot.botAttackAction();
          game.bot.setBotAttack(currentAttack);
          game.user.subtractHealth(currentAttack);
          game.router.pushNamed('enemy-attack');
          game.checkGameOver();
        },
        color: const Color(0xff758f9a),
        borderColor: const Color(0xff60d5ff),
      )..position = (game.size / 2) + Vector2(0, 60),

      RoundedButton(
        text: 'Play',
        action: () {
          sword.startMovement();
          //sword.startMoving();
        },
        color: Color.fromARGB(255, 97, 225, 86),
        borderColor: const Color(0xff60d5ff),
      )..position = (game.size / 2) + Vector2(-100, 50),

      RoundedButton(
        text: 'Stop',
        action: () {
          sword.stopMovement();
          //sword.stopMoving();
          // Print out the current x position of the sword
          //print('Sword stopped at x position: ${sword.position.x}');
        },
        color: Color.fromARGB(255, 220, 30, 30),
        borderColor: const Color(0xff60d5ff),
      )..position = (game.size / 2) + Vector2(100, 50),
    ]);
    add(sword);
    sword.startMovement();
  }

  void applyBotDamage() async {
    sword.stopMovement();
    double swordX = sword.getXPosition();
    int damage = scoreboard.calculateDamage(swordX);
    game.bot.setBotDamage(damage);
    print("Damage at position $swordX: $damage");
    game.bot.subtractBotHealth(damage);
  }
}

class AttackBox extends Component {
  AttackBox(this.color);

  final Color color;

  @override
  void render(Canvas canvas) {
    //canvas.drawColor(color, BlendMode.srcATop);
    //(left, top, width, height)
    canvas.drawRect(Rect.fromLTWH(15, 350, 400, 220), Paint()..color = color);
  }
}
