import 'package:flame/components.dart';

import 'package:flame/effects.dart';

import 'package:flame/events.dart';
import 'package:test_app/features/game/titan_game.dart';

class PausePage extends Component with TapCallbacks, HasGameReference<TitanGame> {

  @override

  Future<void> onLoad() async {

    final game = findGame()!;

    addAll([

      TextComponent(

        text: 'PAUSED',

        position: game.canvasSize / 2,

        anchor: Anchor.center,

        children: [

          ScaleEffect.to(

            Vector2.all(1.1),

            EffectController(

              duration: 0.3,

              alternate: true,

              infinite: true,

            ),

          ),

        ],

      ),

    ]);

  }


  @override

  bool containsLocalPoint(Vector2 point) => true;


  @override

  void onTapUp(TapUpEvent event) => game.router.pop();

}