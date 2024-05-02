import 'package:flame/components.dart';
import 'package:test_app/features/game/titan_game.dart';

/*
  The Bot Avatar class extends the SpriteGroupComponent class, instead of SpriteComponent since our bot component has 3 appearance 
  components(based on score) and the SpriteGroupComponent class is designed to manage a group of sprites. The Bot class extends 
  SpriteGroupComponent<BotStatus> to manage different sprites based on the bot's health states (0-30, 30-50, 50-100) and 
  implements HasGameRef<TitanGame> to access the game instance.

  enum BotStatus { happy, sad, worried }

  onLoad() -> onLoad Method:

    Loads different sprites for the bot's health states using asynchronous calls.
    Sets the bot's size and initial position within the game world.
    Assigns the loaded sprites to the corresponding health states.

*/

class UserAvatar extends SpriteComponent with HasGameRef<TitanGame> {
  int health = 100;
  int userAttack = 0;

  UserAvatar();

  @override
  Future<void> onLoad() async {
    gameRef.user; //implemented in Titan Game: `late UserAvatar user`
    sprite = await Sprite.load('avatars/avatar_back.png');

    //size = Vector2(80, 80);
    scale = Vector2(0.18, 0.18);
    position = Vector2(10, 600); //left; top
  }

  @override
  void update(double dt) {
    super.update(dt);

    // //If game is over through user health = 0 or bot health = 0, remove the bot from the game
    // if (gameRef.bot.getHealth() <= 0 || gameRef.userHealth <= 0) {
    //   removeFromParent();
    // }
  }

  void subtractHealth(int newHealth) {
    health -= newHealth;
    // Force the component to update its sprite
    update(0);
  }

  int getHealth() {
    return health;
  }

  void setHealth(int newHealth) {
    health = newHealth;
    // Force the component to update its sprite
    update(0);
  }
}
