import 'package:flame/components.dart';
import 'package:test_app/features/game/titan_game.dart';
import 'package:test_app/utils/constants/image_strings.dart';

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
//Used to define the status of the bot. The bot has 3 appearance states: happy, sad, and worried.
enum BotStatus { happy, sad, worried }

class BotAvatar extends SpriteGroupComponent<BotStatus>
    with HasGameRef<TitanGame> {
  int health = 100;

  BotAvatar();

  @override
  Future<void> onLoad() async {
    final botHappy = await gameRef.loadSprite(ImageStrings.botHappy);
    final botSad = await gameRef.loadSprite(ImageStrings.botSad);
    final botWorried = await gameRef.loadSprite(ImageStrings.botWorried);

    gameRef.bot; //implemented in Titan Game: `late BotAvatar bot`

    //size = Vector2(80, 80);
    scale = Vector2(0.25, 0.25);
    position = Vector2(200, 50); //left; top
    //position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BotStatus.happy;

    sprites = {
      BotStatus.happy: botHappy,
      BotStatus.sad: botSad,
      BotStatus.worried: botWorried,
    };
  }

  @override
  void update(double dt) {
    super.update(dt);

    //Change the bot appearance based on health
    changeBotAppearance();
  }

  void changeBotAppearance() {
    // Change the bot appearance based on the health
    if (health <= 30) {
      current = BotStatus.worried;
    } else if (health <= 50) {
      current = BotStatus.sad;
    } else {
      current = BotStatus.happy;
    }
  }

  void setHealth(int newHealth) {
    health -= newHealth;
    // Force the component to update its sprite
    update(0);
  }

  int getHealth() {
    return health;
  }
}
