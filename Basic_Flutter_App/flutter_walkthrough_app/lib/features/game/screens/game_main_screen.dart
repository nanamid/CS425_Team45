//This is where you add all your components to the game.
//This screen will serve as the mainscreen that loads after the loading screen

import 'package:flame/components.dart';
import 'package:test_app/features/game/components/bot_avatar.dart';
import 'package:test_app/features/game/components/bot_chat.dart';

import 'package:flutter/rendering.dart';
import 'package:test_app/features/game/titan_game.dart';
import 'package:test_app/features/game/widgets/rounded_button.dart';

class GameMainScreen extends Component with HasGameRef<TitanGame>{
  @override
  Future<void> onLoad() async {
    super.onLoad();

    gameRef.botChat = BotChat()
      ..position = Vector2(300, 50); // Instantiate and position
    addAll([
      gameRef.bot = BotAvatar(),
      gameRef.botHealthText = TextComponent(
          text: "Bot Health: ${gameRef.bot.getHealth()}",
          position: Vector2(10, 10)),
      gameRef.userHealthText = TextComponent(
          text: "User Health: $gameRef.userHealth", position: Vector2(10, 30)),
      gameRef.botChat, // Add the chat component
    ]);

    add(
      RoundedButton(
        text: 'Attack',
        action: () async {
          // AttackWindow is the window that gets opened and damage is the value being pushed back
          // final damage = await game.router.pushAndWait(AttackWindow());

          // firstChild<TextComponent>()!.text = 'Score: $damage';
          // gameRef.bot.setHealth(damage);

          game.router.pushNamed('level1');
        },
        color: const Color(0xff758f9a),
        borderColor: const Color(0xff60d5ff),
      )..position = game.size / 2,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    int botHealthDiv10 = gameRef.bot.getHealth() ~/ 10; // Integer division
    gameRef.botChat.isVisible =
        botHealthDiv10.isEven; // Toggle visibility based on even division

    gameRef.botHealthText.text = "Bot Health: ${gameRef.bot.getHealth()}";
  }
}
