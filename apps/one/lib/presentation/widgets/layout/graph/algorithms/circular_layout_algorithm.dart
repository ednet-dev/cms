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
    this.levelDistance = 200.0,
    this.nodeSize = 100.0,
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

      _positionModels(domain, rootPosition, positions, 1, angle, pi / 2);
    }
  }

  void _positionModels(
      Domain domain,
      Offset parentPosition,
      Map<String, Offset> positions,
      int level,
      double angle,
      double angleRange) {
    final models = domain.models.toList();
    if (models.isEmpty) return;

    final angleStep = angleRange / models.length;
    for (int i = 0; i < models.length; i++) {
      final model = models[i];
      final modelAngle = angle - angleRange / 2 + i * angleStep + angleStep / 2;
      final modelPosition = parentPosition +
          Offset(levelDistance * level * cos(modelAngle),
              levelDistance * level * sin(modelAngle));
      positions[model.code] = modelPosition;

      _positionConcepts(model, modelPosition, positions, level + 1, modelAngle,
          angleStep / 2);
    }
  }

  void _positionConcepts(
      Model model,
      Offset parentPosition,
      Map<String, Offset> positions,
      int level,
      double angle,
      double angleRange) {
    final concepts = model.concepts.toList();
    if (concepts.isEmpty) return;

    final angleStep = angleRange / concepts.length;
    for (int i = 0; i < concepts.length; i++) {
      final concept = concepts[i];
      final conceptAngle =
          angle - angleRange / 2 + i * angleStep + angleStep / 2;
      final conceptPosition = parentPosition +
          Offset(levelDistance * level * cos(conceptAngle),
              levelDistance * level * sin(conceptAngle));
      positions[concept.code] = conceptPosition;

      _positionConceptChildren(concept, conceptPosition, positions, level + 1,
          conceptAngle, angleStep / 2);
    }
  }

  void _positionConceptChildren(
      Concept concept,
      Offset parentPosition,
      Map<String, Offset> positions,
      int level,
      double angle,
      double angleRange) {
    final children = concept.children.toList();
    if (children.isEmpty) return;

    final angleStep = angleRange / children.length;
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final childAngle = angle - angleRange / 2 + i * angleStep + angleStep / 2;
      final childPosition = parentPosition +
          Offset(levelDistance * level * cos(childAngle),
              levelDistance * level * sin(childAngle));
      positions[child.code] = childPosition;

      // _positionConceptChildren(child, childPosition, positions, level + 1,
      //     childAngle, angleStep / 2);
    }
  }
}
