//This is where you add all your components to the game.
//This screen will serve as the mainscreen that loads after the loading screen

import 'package:flame/components.dart';
import 'package:test_app/features/game/components/background.dart';
import 'package:test_app/features/game/components/bot_avatar.dart';
import 'package:test_app/features/game/components/bot_chat.dart';

import 'package:flutter/rendering.dart';
import 'package:test_app/features/game/components/user_avatar.dart';
import 'package:test_app/features/game/titan_game.dart';
import 'package:test_app/features/game/widgets/rounded_button.dart';

class GameMainScreen extends Component with HasGameRef<TitanGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    gameRef.botChat = BotChat()
      ..position = Vector2(300, 50); // Instantiate and position

    //gameRef.defenseWindow = DefenseWindow(); // Instantiate the defense window

    addAll([
      Background(),
      //BackgroundOverlay(Color.fromARGB(255, 255, 3, 3)),
      gameRef.bot = BotAvatar(),
      gameRef.user = UserAvatar(),
      gameRef.botHealthText = TextComponent(
          text: "Bot Health: ${gameRef.bot.getBotHealth()}",
          position: Vector2(30, 100)),
      gameRef.userHealthText = TextComponent(
          text: "User Health: ${gameRef.user.getHealth()}",
          position: Vector2(210, 650)),
      //gameRef.botChat, // Add the chat component
    ]);

    add(
      RoundedButton(
        text: 'Attack',
        action: () async {
          // AttackWindow is the window that gets opened and damage is the value being pushed back
          // final damage = await game.router.pushAndWait(AttackWindow());

          // firstChild<TextComponent>()!.text = 'Score: $damage';
          // gameRef.bot.subtractHealth(damage);

          game.router.pushNamed('user-attack');
          //game.bot.botAttack();
          //
        },
        color: Color.fromARGB(255, 220, 30, 30),
        borderColor: Color.fromARGB(255, 220, 30, 30),
      )..position = game.size / 2,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    int botHealthDiv10 = gameRef.bot.getBotHealth() ~/ 10; // Integer division
    gameRef.botChat.isVisible =
        botHealthDiv10.isEven; // Toggle visibility based on even division

    gameRef.botHealthText.text = "Bot Health: ${gameRef.bot.getBotHealth()}";
    gameRef.userHealthText.text = "User Health: ${gameRef.user.getHealth()}";
  }
}
