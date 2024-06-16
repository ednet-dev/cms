import 'dart:ui';

import 'component.dart';

class RenderComponent extends Component {
  final Paint paint;
  final Rect rect;

  RenderComponent(this.paint, this.rect);

  @override
  void update(double dt) {
    // Update logic for rendering
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }
}
