import 'dart:ui';

import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:test_app/utils/device/device_utility.dart';

class DamageScoreboard extends PositionComponent {
  Sprite? scoreboardSprite;

  DamageScoreboard() {
    // Assuming the scoreboard size matches the image size
    double width = AppDeviceUtils.getScreenWidth(Get.context!) - 50;
    size = Vector2(width, 150); // Set the size based on your image dimensions
    position = Vector2(12, 180); // Adjust position as needed
  }

  @override
  Future<void>? onLoad() async {
    // Load the sprite for the scoreboard
    scoreboardSprite = await Sprite.load('components/damage_board.png');
    return super.onLoad();
  }

  int calculateDamage(double xPosition) {
    // Damage zones based on the provided image and dimensions
    if (xPosition >= 180 && xPosition <= 210) {
      return 50; // Damage for the 50 zone
    } else if (xPosition >= 140 && xPosition <= 250) {
      return 20; // Damage for the 15 zones
    } else if (xPosition >= 80 && xPosition <= 300) {
      return 15; // Damage for the 20 zones
    } else {
      return 10; // No damage outside the designated areas
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    scoreboardSprite?.render(canvas, position: position, size: size);
  }
}
