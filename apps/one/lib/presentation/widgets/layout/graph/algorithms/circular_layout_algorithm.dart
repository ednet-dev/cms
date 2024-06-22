import 'dart:math';
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class CircularLayoutAlgorithm extends LayoutAlgorithm {
  final double rootRadius;
  final double initialLevelDistance;
  final double nodeSize;
  final double levelDistanceIncrement = 200.0;

  CircularLayoutAlgorithm({
    this.rootRadius = 1000.0,
    this.initialLevelDistance = 500.0, // Further increased initial distance
    this.nodeSize = 300.0,
  });

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final center = Offset(size.width / 2, size.height / 2);
    print(size);
    print(center);

    _positionRoots(domains, center, positions);

    return positions;
  }

  void _positionRoots(
      Domains domains, Offset center, Map<String, Offset> positions) {
    final rootCount = domains.length;
    print(rootCount);
    final rootAngleStep = pi / rootCount;
    for (int i = 0; i < rootCount; i++) {
      final domain = domains.elementAt(i);
      final angle = i * rootAngleStep;
      print('Angle: $angle of $rootAngleStep of $i');
      final rootPosition =
          center + Offset(rootRadius * cos(angle), rootRadius * sin(angle));
      positions[domain.code] = rootPosition;

      _positionModels(domain, rootPosition, positions, 1, angle);
    }
  }

  void _positionModels(Domain domain, Offset parentPosition,
      Map<String, Offset> positions, int level, double angle) {
    final models = domain.models.toList();
    if (models.isEmpty) return;

    final levelDistance = initialLevelDistance +
        (level - 1) * levelDistanceIncrement; // Increased increment
    final angleStep = 2 * pi / models.length;
    for (int i = 0; i < models.length; i++) {
      final model = models[i];
      final modelAngle = i * angleStep;
      final modelPosition = parentPosition +
          Offset(
              levelDistance * cos(modelAngle), levelDistance * sin(modelAngle));
      positions[model.code] = modelPosition;

      _positionConcepts(model, modelPosition, positions, level + 1, modelAngle);
    }
  }

  void _positionConcepts(Model model, Offset parentPosition,
      Map<String, Offset> positions, int level, double angle) {
    final concepts = model.concepts.toList();
    if (concepts.isEmpty) return;

    final levelDistance = initialLevelDistance +
        (level - 1) * levelDistanceIncrement; // Increased increment
    final angleStep = 2 * pi / concepts.length;
    for (int i = 0; i < concepts.length; i++) {
      final concept = concepts[i];
      final conceptAngle = i * angleStep;
      final conceptPosition = parentPosition +
          Offset(levelDistance * cos(conceptAngle),
              levelDistance * sin(conceptAngle));
      positions[concept.code] = conceptPosition;

      _positionConceptChildren(
          concept, conceptPosition, positions, level + 1, conceptAngle);
    }
  }

  void _positionConceptChildren(Concept concept, Offset parentPosition,
      Map<String, Offset> positions, int level, double angle) {
    final children = concept.children.toList();
    if (children.isEmpty) return;

    final levelDistance = initialLevelDistance +
        (level - 1) * levelDistanceIncrement; // Increased increment
    final angleStep = 2 * pi / children.length;
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final childAngle = i * angleStep;
      final childPosition = parentPosition +
          Offset(
              levelDistance * cos(childAngle), levelDistance * sin(childAngle));
      positions[child.code] = childPosition;
    }
  }
}
