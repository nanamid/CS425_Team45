import 'dart:ui';

import 'package:flame/components.dart';

class BackgroundOverlay extends Component {
  BackgroundOverlay(this.color);

  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
    //canvas.drawRect(Rect.fromLTWH(15, 280, 400, 200), Paint()..color = color);
  }
}