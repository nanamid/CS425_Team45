import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:test_app/features/game/components/gameOver_background.dart';
import 'package:test_app/features/game/titan_game.dart';

class GameOverRoute extends Route {
  GameOverRoute() : super(GameOverScreen.new);

  @override
  void onPush(Route? previousRoute) {
    previousRoute!.stopTime();
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute.resumeTime();
  }
}

class GameOverScreen extends PositionComponent
    with TapCallbacks, HasGameRef<TitanGame> {
  late TextComponent attackText;

  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    
    add(GameOverBackGround());
    addAll([
      attackText =
      TextComponent(
        text: "You've earned 90 xP", //${gameRef.bot.getBotAttack()}
        textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 50.0, // Specify the font size
          fontFamily: 'Bebas Neue', // Specify the font family
          color: Colors.white, // Specify text color
          fontWeight: FontWeight.bold, // Specify font weight
        ),
      ),
        position: Vector2(210,570),
        anchor: Anchor.center,
        children: [
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(
              duration: 0.3,
              alternate: true,
              infinite: true,
            ),
          ),
        ],
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

}
