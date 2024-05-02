import 'dart:math';

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
  int botAttack = 0;
  int damageToBot = 0;

  BotAvatar();

  @override
  Future<void> onLoad() async {
    final botHappy = await gameRef.loadSprite(ImageStrings.botHappy);
    final botSad = await gameRef.loadSprite(ImageStrings.botSad);
    final botWorried = await gameRef.loadSprite(ImageStrings.botWorried);

    gameRef.bot; //implemented in Titan Game: `late BotAvatar bot`
    //gameRef.defenseWindow = DefenseWindow(); // Instantiate the defense window

    //size = Vector2(80, 80);
    scale = Vector2(0.22, 0.22);
    position = Vector2(210, 130); //left; top
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

    // //If game is over through user health = 0 or bot health = 0, remove the bot from the game
    // if (gameRef.bot.getHealth() <= 0 || gameRef.userHealth <= 0) {
    //   removeFromParent();
    // }
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

  int botAttackAction() {
    final List<int> choices = [5, 10, 15]; // List of possible choices
    final random = Random();
    int index = random.nextInt(choices.length); // Generate a random index
    //choices[index] => the number at the random index

    final choiceRandom = Random();
    bool shouldAdd = choiceRandom.nextBool(); // Randomly returns true or false

    int newBotDamage = getBotDamage();

    // Get the current health status
    int userHealth = gameRef.user.getHealth();
    int botHealth = gameRef.bot.getBotHealth();

    // Check the difference in health
    if ((userHealth - botHealth).abs() > 20) {
        botAttack = 25;
        setBotAttack(botAttack);
        print('Bot Attack (Health difference > 20): $botAttack');
        return botAttack;
    }


    if (shouldAdd) {
      botAttack = newBotDamage + choices[index];
      setBotAttack(botAttack);
      print('Bot Attack (from bot_avatar.dart): $botAttack');
      return botAttack; // Perform addition
    } else {
          // Check if subtracting would result in a negative number
          if (newBotDamage - choices[index] > 0) {
            botAttack = newBotDamage - choices[index];
          } else {
            // Ensure botAttack is never zero by using the smallest choice
            botAttack = choices[2]; // This assumes the list is sorted and 5 is the smallest
          }
          setBotAttack(botAttack);
          print('Bot Attack (from bot_avatar.dart): $botAttack');
          return botAttack; // Ensure it's always a positive attack
          
      // // Check if subtracting would result in a negative number
      // if (newBotDamage - choices[index] >= 0) {
      //   botAttack = newBotDamage - choices[index];
      //   setBotAttack(botAttack);
      //   print('Bot Attack (from bot_avatar.dart): $botAttack');
      //   return botAttack; // Perform subtraction

      // } else {
      //   // Optionally set botAttack to zero or just skip the subtraction
      //   botAttack = choices[index]; // or keep botAttack = newBotDamage;
      //   setBotAttack(botAttack);
      //   print('Bot Attack (from bot_avatar.dart): $botAttack');
      //   return botAttack; // Perform subtraction
      // }
    }
  }

  void subtractBotHealth(int newBotDamage) {
    health -= newBotDamage;
    setBotDamage(newBotDamage);
    // Force the component to update its sprite
    update(0);
  }

  int getBotHealth() {
    return health;
  }

  void setBotHealth(int newHealth) {
    health = newHealth;
    // Force the component to update its sprite
    update(0);
  }

  int getBotDamage() {
    return damageToBot;
  }

  void setBotDamage(int newBotDamage) {
    damageToBot = newBotDamage;
    // Force the component to update its sprite
    update(0);
  }

  int getBotAttack() {
    print('Bot Damage to user: $botAttack');
    return botAttack;
  }

  void setBotAttack(int newBotAttack) {
    botAttack = newBotAttack;
    // Force the component to update its sprite
    update(0);
  }
}
