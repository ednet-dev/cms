import 'dart:math';
import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class CircularLayoutAlgorithm extends LayoutAlgorithm {
  final double rootRadius;
  final double levelDistance;
  final double nodeSize;

  CircularLayoutAlgorithm({
    this.rootRadius = 100.0,
    this.levelDistance = 150.0,
    this.nodeSize = 50.0,
  });

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final center = Offset(size.width / 2, size.height / 2);

    _positionRoots(domains, center, positions);

    return positions;
  }

  void _positionRoots(
      Domains domains, Offset center, Map<String, Offset> positions) {
    final rootCount = domains.length;
    final rootAngleStep = 2 * pi / rootCount;
    for (int i = 0; i < rootCount; i++) {
      final domain = domains.elementAt(i);
      final angle = i * rootAngleStep;
      final rootPosition =
          center + Offset(rootRadius * cos(angle), rootRadius * sin(angle));
      positions[domain.code] = rootPosition;

      _positionChildren(
          domain, rootPosition, positions, 1, angle, rootAngleStep / 2);
    }
  }

  void _positionChildren(
      Entity parent,
      Offset parentPosition,
      Map<String, Offset> positions,
      int level,
      double angle,
      double angleRange) {
    final children = parent.concept.children;
    if (children.isEmpty) return;

    final angleStep = angleRange / children.length;
    for (int i = 0; i < children.length; i++) {
      final child = children.elementAt(i);
      final childAngle = angle - angleRange / 2 + i * angleStep + angleStep / 2;
      final childPosition = parentPosition +
          Offset(
              levelDistance * cos(childAngle), levelDistance * sin(childAngle));
      positions[child.code] = childPosition;

      _positionChildren(child, childPosition, positions, level + 1, childAngle,
          angleStep / 2);
    }
  }
}
