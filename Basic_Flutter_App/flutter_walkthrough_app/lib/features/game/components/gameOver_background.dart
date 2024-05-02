import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:test_app/features/game/titan_game.dart';
/* 
  This class is responsible for rendering the background of the game.
  It extends the SpriteComponent class, which is a component that renders a sprite.
  It also uses the HasGameRef mixin, which allows the component to access the game instance.
    allowing this component to interact with other elements of the game or query game-wide properties.
 */

class GameOverBackGround extends SpriteComponent with HasGameRef<TitanGame> {
  GameOverBackGround();

  // The onLoad method is called when the component is added to the game.
  @override
  Future<void> onLoad() async {
    // The Flame.images.load method is used to load the background image.
    final background = await Flame.images.load("backgrounds/game_over.png");

    // sets the size of the Background component to the size of the game window.
    // This ensures that the background covers the entire game view. gameRef is accessed through the HasGameRef mixin,
    // allowing this component to reference properties of the game instance.
    size = gameRef.size;

    // The sprite property is set to a Sprite instance created from the background image.
    // The sprite property of the SpriteComponent class is set to a Sprite instance created from the background image.
    // This is how the image actually gets rendered as part of the component.
    sprite = Sprite(background);
  }
}
