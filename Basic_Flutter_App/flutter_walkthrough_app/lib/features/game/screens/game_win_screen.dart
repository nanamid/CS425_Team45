import 'dart:ui';

import 'package:flame/components.dart';
import 'package:test_app/features/game/titan_game.dart';

class GameWinScreen extends Component with HasGameReference<TitanGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    addAll([
      //Add the GameOverScreen Overlay
      //BackgroundOverlay(Color.fromARGB(133, 0, 0, 0)),
    ]);
  }
}
