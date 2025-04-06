import 'dart:math';
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class RadialTreeLayoutAlgorithm extends LayoutAlgorithm {
  final double nodeWidth;
  final double nodeHeight;
  final double levelGap;

  RadialTreeLayoutAlgorithm({
    this.nodeWidth = 100.0,
    this.nodeHeight = 50.0,
    this.levelGap = 50.0,
  });

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double angleStep = 2 * pi / domains.length;
    double currentAngle = 0.0;

    for (var domain in domains) {
      _calculatePositionsForDomain(
        domain.code,
        domain,
        centerX,
        centerY,
        0,
        currentAngle,
        angleStep,
        positions,
      );
      currentAngle += angleStep;
    }

    return positions;
  }

  void _calculatePositionsForDomain(
    String nodeId,
    Domain domain,
    double centerX,
    double centerY,
    int level,
    double angle,
    double angleStep,
    Map<String, Offset> positions,
  ) {
    double radius = level * levelGap;
    double x = centerX + radius * cos(angle);
    double y = centerY + radius * sin(angle);

    positions[nodeId] = Offset(x, y);

    double childAngleStep = angleStep / max(domain.models.length, 1);
    double currentChildAngle =
        angle - (childAngleStep * (domain.models.length - 1)) / 2;

    for (var model in domain.models) {
      _calculatePositionsForModel(
        model.code,
        model,
        x,
        y,
        level + 1,
        currentChildAngle,
        childAngleStep,
        positions,
      );
      currentChildAngle += childAngleStep;
    }
  }

  void _calculatePositionsForModel(
    String modelId,
    Model model,
    double centerX,
    double centerY,
    int level,
    double angle,
    double angleStep,
    Map<String, Offset> positions,
  ) {
    double radius = level * levelGap;
    double x = centerX + radius * cos(angle);
    double y = centerY + radius * sin(angle);

    positions[modelId] = Offset(x, y);

    double childAngleStep = angleStep / max(model.concepts.length, 1);
    double currentChildAngle =
        angle - (childAngleStep * (model.concepts.length - 1)) / 2;

    for (var entity in model.concepts) {
      _calculatePositionsForEntity(
        entity.code,
        model,
        entity,
        x,
        y,
        level + 1,
        currentChildAngle,
        childAngleStep,
        positions,
      );
      currentChildAngle += childAngleStep;
    }
  }

  void _calculatePositionsForEntity(
    String entityId,
    Model model,
    Entity entity,
    double centerX,
    double centerY,
    int level,
    double angle,
    double angleStep,
    Map<String, Offset> positions,
  ) {
    double radius = level * levelGap;
    double x = centerX + radius * cos(angle);
    double y = centerY + radius * sin(angle);

    positions[entityId] = Offset(x, y);

    final safeEntity = Concept.safeGetConcept(model, entity);

    double childAngleStep =
        angleStep / max(safeEntity.concept.children.length, 1);
    double currentChildAngle =
        angle - (childAngleStep * (safeEntity.concept.children.length - 1)) / 2;

    for (var child in safeEntity.concept.children) {
      _calculatePositionsForConceptChild(
        child.code,
        child as Child,
        x,
        y,
        level + 1,
        currentChildAngle,
        childAngleStep,
        positions,
      );
      currentChildAngle += childAngleStep;
    }
    // } catch (e) {
    //   double childAngleStep =
    //       angleStep / max((entity as Concept).children.length, 1);
    //   double currentChildAngle =
    //       angle - (childAngleStep * (entity.children.length - 1)) / 2;
    //
    //   for (var child in entity.children) {
    //     _calculatePositionsForConceptChild(child.code, child as Child, x, y,
    //         level + 1, currentChildAngle, childAngleStep, positions);
    //     currentChildAngle += childAngleStep;
    //   }
    // }
  }

  void _calculatePositionsForConceptChild(
    String childId,
    Child child,
    double centerX,
    double centerY,
    int level,
    double angle,
    double angleStep,
    Map<String, Offset> positions,
  ) {
    double radius = level * levelGap;
    double x = centerX + radius * cos(angle);
    double y = centerY + radius * sin(angle);

    positions[childId] = Offset(x, y);

    double childAngleStep =
        angleStep / max(child.destinationConcept.children.length, 1);
    double currentChildAngle =
        angle -
        (childAngleStep * (child.destinationConcept.children.length - 1)) / 2;

    for (var grandChild in child.destinationConcept.children) {
      _calculatePositionsForConceptChild(
        grandChild.code,
        grandChild as Child,
        x,
        y,
        level + 1,
        currentChildAngle,
        childAngleStep,
        positions,
      );
      currentChildAngle += childAngleStep;
    }
  }
}
