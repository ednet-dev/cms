import 'dart:ui';
import 'package:ednet_one/presentation/widgets/layout/graph/component.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/meta_domain_canvas.dart';

class PositionComponent extends Component {
  Offset position;

  PositionComponent(this.position);

  @override
  void update(double dt) {
    // Update logic for position
  }

  @override
  void render(Canvas canvas) {
    // Render logic for position (e.g., drawing a marker)
  }
}
