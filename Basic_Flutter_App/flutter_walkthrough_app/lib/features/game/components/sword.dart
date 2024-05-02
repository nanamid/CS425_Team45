import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:test_app/utils/constants/image_strings.dart';
import 'package:test_app/utils/device/device_utility.dart';

class Sword extends SpriteComponent with HasGameRef {
  double screenWidth = AppDeviceUtils.getScreenWidth(
        Get.context!); // Get the size of the game canvas
  // Movement speed in units per second
  final double speed = 300;
  bool isMoving = false; // Track movement state
  bool isMovingRight = true;  // Track the direction of movement

  double leftBound = 0;
  double rightBound = 0;

  static const double yPosition = 270; // Fixed y-position for all swords

  Sword() {
    rightBound = screenWidth;
    size = Vector2(50, 200);  // Set the size based on your image dimensions
    position = Vector2(leftBound, yPosition);  // Adjust position as needed
  }


  // Load the sprite
  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load(ImageStrings.sword);
    size = size; // Set size to the initialSize or default
    position = Vector2(leftBound, yPosition); // Initial position set at left bound
    return super.onLoad();
  }

  void resetSword() {
    position = Vector2(leftBound, yPosition); // Reset position to the start
    isMoving = true;  // Start moving after reset
    isMovingRight = true;  // Start moving right after reset
  }

  // Start movement
  void startMovement() {
    isMoving = true;
  }

  // Stop movement
  void stopMovement() {
    isMoving = false;
  }

   // Update method called every frame, deltaTime is time since last frame in seconds
  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      if (isMovingRight) {
        x += speed * dt;
        if (x > rightBound - size.x) {
          x = rightBound - size.x;
          isMovingRight = false; // Change direction to left but do not move unless isMoving is true
        }
      } else {
        x -= speed * dt;
        if (x < leftBound) {
          x = leftBound;
          isMovingRight = true; // Change direction to right but do not move unless isMoving is true
        }
      }
    }
  }

  // // Update method called every frame, deltaTime is time since last frame in seconds
  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   if (isMoving) {
  //     x += speed * dt;
  //     if (x > rightBound - size.x) {
  //       // If it reaches or exceeds the right bound
  //       x = rightBound - size.x;
  //       isMoving = false; // Start moving left
  //     }
  //   } else {
  //     x -= speed * dt;
  //     if (x < leftBound) {
  //       // If it reaches or exceeds the left bound
  //       x = leftBound;
  //       isMoving = true; // Start moving right
  //     }
  //   }
  // }

  // Get current x position
  double getXPosition() {
    return x;
  }
}
