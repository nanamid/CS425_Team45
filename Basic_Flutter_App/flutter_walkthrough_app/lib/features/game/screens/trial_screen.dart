import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:test_app/features/game/titan_game.dart';

import 'package:flutter/rendering.dart';
import 'package:test_app/features/game/widgets/rounded_button.dart';

class Level1Page extends Component with HasGameReference<TitanGame> {
  SpriteComponent sword = SpriteComponent();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // sword
    //   ..sprite = await loadSprite('sword.png')
    //   ..position = Vector2(100, 100)
    //   ..size = Vector2(100, 100);
    

    addAll([
      Background(Color.fromARGB(101, 42, 7, 79)),
      AttackBox(const Color(0xff758f9a)),

      // Define buttons with updated actions
      RoundedButton(
        text: 'Back',
        action: () {
          game.router.pop();
        },
        color: const Color(0xff758f9a),
        borderColor: const Color(0xff60d5ff),
      )..position = (game.size / 2) + Vector2(0, 50),

      RoundedButton(
        text: 'Play',
        action: () {
          //sword.startMoving();
        },
        color: Color.fromARGB(255, 97, 225, 86),
        borderColor: const Color(0xff60d5ff),
      )..position = (game.size / 2) + Vector2(-100, 50),

      RoundedButton(
        text: 'Stop',
        action: () {
          //sword.stopMoving();
          // Print out the current x position of the sword
          //print('Sword stopped at x position: ${sword.position.x}');
        },
        color: Color.fromARGB(255, 220, 30, 30),
        borderColor: const Color(0xff60d5ff),
      )..position = (game.size / 2) + Vector2(100, 50),
    ]);
  }
}

//////// TRIAL CODE
// class Sword extends SpriteComponent with HasGameRef<TitanGame> {
//   Sword() : super() {
//     // debugMode = true;
//   }
//   final _random = Random();
//   @override
//   void onLoad() async {
//     await super.onLoad();
//     sprite = await gameRef.loadSprite('airship.png');
//     size = Vector2(gameRef.size.y * 800 / 469, gameRef.size.y) * .10;
//     flipHorizontallyAroundCenter();
//     double yPosition = _random.nextDouble() * game.size.y;
//     position = Vector2(gameRef.size.x * .95, yPosition);
//     add(
//       CircleHitbox(
//           anchor: Anchor.center, radius: size.y * .35, position: size / 2),
//     );
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     if (x > 0 && !gameRef.gameOver) {
//       x = x - 100 * dt;
//     } else {
//       removeFromParent();
//     }

//     if (gameRef.elapsedTime.elapsed.inSeconds > 30 && x > gameRef.crow.x) {
//       if (gameRef.crow.y > y) {
//         y += 3 * dt;
//       } else {
//         y -= 3 * dt;
//       }
//     }
//   }
// }



///////

/////// THE REST OF THE CODE
class Background extends Component {
  Background(this.color);

  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
    //canvas.drawRect(Rect.fromLTWH(15, 280, 400, 200), Paint()..color = color);
  }
}

class AttackBox extends Component {
  AttackBox(this.color);

  final Color color;

  @override
  void render(Canvas canvas) {
    //canvas.drawColor(color, BlendMode.srcATop);
    canvas.drawRect(Rect.fromLTWH(15, 280, 400, 200), Paint()..color = color);
  }
}

abstract class SimpleButton extends PositionComponent with TapCallbacks {
  SimpleButton(this._iconPath, {super.position}) : super(size: Vector2.all(40));

  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0x66ffffff);

  final Paint _iconPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xffaaaaaa)
    ..strokeWidth = 7;

  final Path _iconPath;

  void action();

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      _borderPaint,
    );

    canvas.drawPath(_iconPath, _iconPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _iconPaint.color = const Color(0xffffffff);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _iconPaint.color = const Color(0xffaaaaaa);

    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _iconPaint.color = const Color(0xffaaaaaa);
  }
}


