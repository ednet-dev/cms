import 'dart:ui';
import 'package:ednet_one/presentation/widgets/layout/graph/component.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/meta_domain_canvas.dart';

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
