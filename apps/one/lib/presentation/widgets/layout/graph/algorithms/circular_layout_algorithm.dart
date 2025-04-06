import 'dart:math';
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class CircularLayoutAlgorithm extends LayoutAlgorithm {
  final double nodeWidth;
  final double nodeHeight;
  final double levelDistanceIncrement;

  CircularLayoutAlgorithm({
    this.nodeWidth = 600.0,
    this.nodeHeight = 300.0,
    this.levelDistanceIncrement = 200.0,
  });

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final center = Offset(size.width / 2, size.height / 2);

    if (domains.isEmpty) {
      return positions;
    }

    final domain = domains.first; // Only consider the first domain

    // Calculate the space requirement for the domain
    final requiredSpace = _calculateDomainSpace(domain);

    // Position the root domain
    _positionRoot(domain, center, positions, requiredSpace);

    return positions;
  }

  // Calculate the required space for the domain and propagate upwards
  double _calculateDomainSpace(Domain domain) {
    double maxSpace = nodeWidth;
    for (var model in domain.models) {
      maxSpace = max(maxSpace, _calculateModelSpace(model));
    }
    return maxSpace;
  }

  double _calculateModelSpace(Model model) {
    double maxSpace = nodeWidth;
    final entryConcepts =
        model.concepts.where((concept) => concept.entry).toList();
    for (var concept in entryConcepts) {
      maxSpace = max(maxSpace, _calculateConceptSpace(concept));
    }
    return maxSpace;
  }

  double _calculateConceptSpace(Concept concept) {
    double maxSpace = nodeWidth;
    for (var child in concept.children.whereType<Child>()) {
      maxSpace = max(
        maxSpace,
        _calculateConceptSpace(child.destinationConcept),
      );
    }
    return maxSpace;
  }

  void _positionRoot(
    Domain domain,
    Offset center,
    Map<String, Offset> positions,
    double requiredSpace,
  ) {
    final rootRadius = requiredSpace / (0.5 * pi);

    // Position the root domain
    positions[domain.code] = center;

    // Position the models
    _positionModels(domain, center, positions, rootRadius, 1, 0, 4 * pi);
  }

  void _positionModels(
    Domain domain,
    Offset parentPosition,
    Map<String, Offset> positions,
    double levelDistance,
    int level,
    double startAngle,
    double angleRange,
  ) {
    final models = domain.models.toList();
    if (models.isEmpty) return;

    double currentAngle = startAngle;
    for (var model in models) {
      final angleStep = angleRange / models.length;
      final modelPosition =
          parentPosition +
          Offset(
            levelDistance * cos(currentAngle + angleStep / 2),
            levelDistance * sin(currentAngle + angleStep / 2),
          );
      positions[model.code] = modelPosition;

      _positionConcepts(
        model,
        modelPosition,
        positions,
        levelDistance + levelDistanceIncrement,
        level + 1,
        currentAngle,
        angleStep,
      );

      currentAngle += angleStep;
    }
  }

  void _positionConcepts(
    Model model,
    Offset parentPosition,
    Map<String, Offset> positions,
    double levelDistance,
    int level,
    double startAngle,
    double angleRange,
  ) {
    final concepts = model.concepts.where((concept) => concept.entry).toList();
    if (concepts.isEmpty) return;

    double currentAngle = startAngle;
    for (var concept in concepts) {
      final angleStep = angleRange / concepts.length;
      final conceptPosition =
          parentPosition +
          Offset(
            levelDistance * cos(currentAngle + angleStep / 2),
            levelDistance * sin(currentAngle + angleStep / 2),
          );
      positions[concept.code] = conceptPosition;

      _positionConceptChildren(
        concept,
        conceptPosition,
        positions,
        levelDistance + levelDistanceIncrement,
        level + 1,
        currentAngle,
        angleStep,
      );

      currentAngle += angleStep;
    }
  }

  void _positionConceptChildren(
    Concept concept,
    Offset parentPosition,
    Map<String, Offset> positions,
    double levelDistance,
    int level,
    double startAngle,
    double angleRange,
  ) {
    // Process children of type Child
    final childNodes = concept.children.whereType<Child>().toList();
    if (childNodes.isNotEmpty) {
      _positionChildNodes(
        childNodes,
        parentPosition,
        positions,
        levelDistance,
        level,
        startAngle,
        angleRange,
      );
    }

    // Process attributes
    for (var attribute in concept.attributes.whereType<Attribute>()) {
      _positionAttribute(attribute, parentPosition, positions);
    }
  }

  void _positionChildNodes(
    List<Child> children,
    Offset parentPosition,
    Map<String, Offset> positions,
    double levelDistance,
    int level,
    double startAngle,
    double angleRange,
  ) {
    double currentAngle = startAngle;
    for (var child in children) {
      final angleStep = angleRange / children.length;
      final childPosition =
          parentPosition +
          Offset(
            levelDistance * cos(currentAngle + angleStep / 2),
            levelDistance * sin(currentAngle + angleStep / 2),
          );
      positions[child.destinationConcept.code] = childPosition;

      currentAngle += angleStep;
    }
  }

  void _positionAttribute(
    Attribute attribute,
    Offset parentPosition,
    Map<String, Offset> positions,
  ) {
    final attributePosition =
        parentPosition +
        Offset(-nodeWidth, 0); // Example positioning for attributes
    positions[attribute.code] = attributePosition;
  }
}
