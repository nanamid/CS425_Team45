// import 'dart:math';

// import 'package:flame/events.dart';
// import 'package:flame/geometry.dart';
// import 'package:flutter/material.dart' hide Route;
// import 'package:test_app/features/game/titan_game.dart';

// import 'dart:ui';

// import 'package:flame/components.dart';

// import 'package:flame/game.dart';
// import 'package:test_app/features/game/widgets/rounded_button.dart';

// class AttackWindow extends ValueRoute<int> with HasGameReference<TitanGame> {
//   late final Sword sword;
//   late final ScoreBar scoreBar;
//   late final ScoreText scoreText;

//   AttackWindow() : super(value: 0, transparent: true) {
//     // Initialize components
//     sword = Sword();
//     scoreBar = ScoreBar();
//     scoreText = ScoreText();

//     // Add components to the game
//     addAll([scoreBar, sword, scoreText]);
//   }

//   @override
//   Component build() {
//     //Size of the Rectangle Window
//     final size = Vector2(400, 200);

//     return RectangleComponent(
//       position: game.size / 2,
//       size: size,
//       anchor: Anchor.center,
//       paint: Paint()..color = const Color(0xee858585),
//       children: [
//         RoundedButton(
//           text: 'Ok',
//           action: () {
//             // Stop the sword and calculate score
//             sword.stop();
//             int score = scoreBar.calculateScore(sword.x);
//             scoreText.updateScore(score);
//             completeWith(
//               score, // This is how we pass back the score
//             );
//           },
//           color: const Color(0xFFFFFFFF),
//           borderColor: const Color(0xFF000000),
//         )..position = Vector2(size.x / 2, 100),
//       ],
//     );
//   }
// }

// class Star extends PositionComponent with TapCallbacks {
//   Star({required this.value, required this.radius, super.position})
//       : super(size: Vector2.all(2 * radius), anchor: Anchor.center);

//   final int value;
//   final double radius;
//   final Path path = Path();
//   final Paint borderPaint = Paint()
//     ..style = PaintingStyle.stroke
//     ..color = const Color(0xffffe395)
//     ..strokeWidth = 2;
//   final Paint fillPaint = Paint()..color = const Color(0xffffe395);
//   bool active = false;

//   @override
//   Future<void> onLoad() async {
//     path.moveTo(radius, 0);
//     for (var i = 0; i < 5; i++) {
//       path.lineTo(
//         radius + 0.6 * radius * sin(tau / 5 * (i + 0.5)),
//         radius - 0.6 * radius * cos(tau / 5 * (i + 0.5)),
//       );
//       path.lineTo(
//         radius + radius * sin(tau / 5 * (i + 1)),
//         radius - radius * cos(tau / 5 * (i + 1)),
//       );
//     }
//     path.close();
//   }

//   @override
//   void render(Canvas canvas) {
//     if (active) {
//       canvas.drawPath(path, fillPaint);
//     }
//     canvas.drawPath(path, borderPaint);
//   }

//   @override
//   void onTapDown(TapDownEvent event) {
//     var on = true;
//     for (final star in parent!.children.whereType<Star>()) {
//       star.active = on;
//       if (star == this) {
//         on = false;
//       }
//     }
//   }
// }

// class Sword extends SpriteComponent with HasGameRef {
//   bool isMoving = true;

//   Sword() : super(size: Vector2(50, 20), anchor: Anchor.center);

//   @override
//   Future<void> onLoad() async {
//     sprite = await gameRef.loadSprite('sword.png');
//   }

//   @override
//   void update(double dt) {
//     if (isMoving) {
//       position.add(Vector2(100 * dt, 0)); // Moves right
//       if (x > gameRef.size.x) {
//         x = 0; // Reset position if it goes off screen
//       }
//     }
//   }

//   void stop() {
//     isMoving = false;
//   }
// }

// class ScoreBar extends PositionComponent with HasGameRef {
//   final List<ScoreZone> zones = [];

//   ScoreBar() {
//     // Calculate zone width based on the gameRef.size and the number of zones
//     double zoneWidth = gameRef.size.x / 7;
//     double zoneHeight = 30; // Adjust as needed

//     // Define colors for each score value
//     final Map<int, Color> scoreColors = {
//       10: Colors.blue,
//       15: Colors.green,
//       30: Colors.orange,
//       50: Colors.red,
//     };

//     // Define score values for each zone
//     List<int> scores = [10, 15, 30, 50, 30, 15, 10];

//     // Create score zones
//     for (int i = 0; i < scores.length; i++) {
//       zones.add(ScoreZone(
//         Vector2(i * zoneWidth, 0), // X position based on index
//         Vector2(zoneWidth, zoneHeight), // Width and height
//         scores[i], // Score value
//         Paint()..color = scoreColors[scores[i]]!, // Color based on score value
//       ));
//     }

//     // Add zones as children
//     addAll(zones);
//   }

//   int calculateScore(double swordX) {
//     // Iterate through zones to find which one the sword landed in
//     for (var zone in zones) {
//       if (zone.containsPoint(Vector2(swordX, 0))) {
//         return zone.value;
//       }
//     }
//     return 0; // Default score if no zone is matched
//   }
// }


// class ScoreZone extends PositionComponent with HasGameRef {
//   final int value;

//   ScoreZone(Vector2 position, Vector2 size, this.value, Paint paint)
//       : super(position: position, size: size, priority: 0, paint: paint);

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas); // Renders the rectangle with the specified color.
//     // Optionally, you can add text or other rendering details here.
//   }
// }



// class ScoreText extends TextComponent with HasGameRef {
//   ScoreText() : super(text: 'Score: 0', config: TextPaintConfig(color: Colors.white));

//   void updateScore(int score) {
//     text = 'Score: $score';
//   }
// }
