import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:test_app/features/game/titan_game.dart';

class EnemyAttackWindowRoute extends Route {
  EnemyAttackWindowRoute() : super(EnemyAttackWindow.new);

  @override
  void onPush(Route? previousRoute) {
    previousRoute!.stopTime();
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute.resumeTime();
  }
}

class EnemyAttackWindow extends PositionComponent
    with TapCallbacks, HasGameRef<TitanGame> {
  late final SpriteComponent player;
  late TextComponent attackText;

  @override
  Future<void> onLoad() async {
    final game = findGame()!;
    final sprite = await Sprite.load('components/defense_window1.png');
    
    final position = Vector2(25,300);
    scale = Vector2(0.9, 0.9);

    //final size = Vector2.all(128.0);
    final player = SpriteComponent(
        scale: scale,
        sprite: sprite,
        position: position);
        
    add(player);
    addAll([
      attackText =
      TextComponent(
        text: "${gameRef.bot.getBotAttack()}",
        textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 50.0, // Specify the font size
          fontFamily: 'Bebas Neue', // Specify the font family
          color: Colors.white, // Specify text color
          fontWeight: FontWeight.bold, // Specify font weight
        ),
      ),
        position: Vector2(250,570),
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

  @override
  void onTapUp(TapUpEvent event){
    game.router.pop();
  }
  @override
  void update(double dt) {
    super.update(dt);
    attackText.text = "${gameRef.bot.getBotAttack()}";
    gameRef.userHealthText.text = "User Health: ${gameRef.user.getHealth()}";
  }
}