import 'package:flame/components.dart';
import 'package:test_app/features/game/titan_game.dart';

enum ChatStatus { healthy, damaged, critical }

//IF YOU USE PHOTOSHOP TO CREATE THE CHATBOXES, RETAIN AS SpriteGroupComponent<ChatStatus>
//IF YOU USE FLAME'S TEXT COMPONENT, while using the same chat box images, change to SpriteComponent

// by using HasVisibility, we can toggle the visibility of the chat box based on the bot's health status.
class BotChat extends SpriteGroupComponent<ChatStatus>
    with HasGameRef<TitanGame>, HasVisibility {
  late TextComponent chatText;

  BotChat() {
    current = ChatStatus.healthy;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprites = {
      ChatStatus.healthy: await gameRef.loadSprite('avatars/chat_box.png'),
      ChatStatus.damaged: await gameRef.loadSprite('avatars/chat_box1.png'),
      ChatStatus.critical: await gameRef.loadSprite('avatars/chat_box1.png'),
    };

    scale = Vector2(0.5, 0.5);
    position = Vector2(10, 60);
    chatText = TextComponent(
        text: "Text is actually showing", position: Vector2(10, 10), anchor: Anchor.topLeft)
        ..priority = 1;
    add(chatText);
    //BotChat.isVisible = false; // Ensure initial visibility is set based on your game logic
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateChat();
  }

  void updateChat() {
    //Eventually replace with if(gameRef.currentTurn == 0) -> meaning it's user's turn

    if (gameRef.bot.getHealth() > 50) {
      current = ChatStatus.healthy;
      chatText = TextComponent(
        text: "Going strong", position: Vector2(10, 10), anchor: Anchor.topLeft);
    } else if (gameRef.bot.getHealth() > 30) {
      current = ChatStatus.healthy;
      chatText = TextComponent(
        text: "I'm about to die", position: Vector2(10, 10), anchor: Anchor.topLeft);
    } else {
      current = ChatStatus.healthy;
      chatText = TextComponent(
        text: "Brb crying", position: Vector2(10, 10), anchor: Anchor.topLeft);
    }
  }
}
