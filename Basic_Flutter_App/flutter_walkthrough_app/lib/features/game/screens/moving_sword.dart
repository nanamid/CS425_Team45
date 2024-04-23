import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:test_app/features/game/titan_game.dart';
import 'dart:async';

import 'package:test_app/features/game/widgets/rounded_button.dart';

class AttackWindow extends ValueRoute<int>
    with HasGameReference<TitanGame>, TapCallbacks {
  AttackWindow() : super(value: 0, transparent: true);

  @override
  Component build() {
    final size = Vector2(400, 200);

    return RectangleComponent(
      position: game.size / 2,
      size: size,
      anchor: Anchor.center,
      paint: Paint()..color = Colors.white,
      children: [
        Sword(),
        //BackButton(),
        RoundedButton(
          text: 'Attack',
          action: () {
            completeWith(10); // Simulating an attack, returning damage
          },
          color: const Color(0xff758f9a),
          borderColor: const Color(0xff60d5ff),
        )..position = size / 2,
      ],
    );
  }
}

class Sword extends SpriteComponent with HasGameReference<TitanGame> {
  //final Vector2 containerSize;

  Sword();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    size = Vector2(50, 50);
    final sword = await Flame.images.load('sword.png');
    //moveSword();
  }

  // void moveSword() {
  //   double endPosition = containerSize.x - size.x;
  //   add(
  //     MoveEffect.to(
  //       Vector2(endPosition, y),
  //       EffectController(
  //         duration: 2.0, // duration of the movement
  //         alternate: true, // move back and forth
  //         infinite: true, // loop forever
  //       ),
  //     ),
  //   );
  // }
}
