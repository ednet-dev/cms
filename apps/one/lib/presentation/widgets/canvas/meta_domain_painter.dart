import 'dart:math';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../layout/graph/components/node.dart';
import '../layout/graph/components/position_component.dart';
import '../layout/graph/components/system.dart';
import '../layout/graph/decorators/u_x_decorator.dart';
import '../layout/graph/layout/layout_algorithm.dart';
import 'painters/entity_painter.dart';
import 'painters/grid_painter.dart';
import 'painters/relation_painter.dart';

/// A custom painter for rendering domain models on a canvas.
///
/// This painter coordinates the rendering of entities, relationships, and grid,
/// using specialized painters for each element type.
class MetaDomainPainter extends CustomPainter {
  final Domains domains;
  final TransformationController transformationController;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;
  final bool isDragging;
  final System system;
  final BuildContext context;
  final String? selectedNode;

  // Specialized painters
  late final EntityPainter _entityPainter;
  late final RelationPainter _relationPainter;
  late final GridPainter _gridPainter;

  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
    required this.isDragging,
    required this.system,
    required this.context,
    this.selectedNode,
  }) {
    _entityPainter = EntityPainter(
      context: context,
      selectedNode: selectedNode,
    );

    _relationPainter = RelationPainter(context: context);

    _gridPainter = GridPainter();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid if needed
    // _gridPainter.paintGrid(canvas, size);

    final positions = layoutAlgorithm.calculateLayout(domains, size);
    system.nodes.clear();

    double maxLevel = _calculateMaxLevel(domains);

    // Create nodes and add them to the system
    for (var domain in domains) {
      _createDomainNodes(domain, positions, 1, maxLevel);
    }

    // Render lines and rectangles first
    system.render(canvas);

    // Render text nodes last
    system.renderText(canvas);
  }

  double _calculateMaxLevel(Domains domains) {
    double maxLevel = 1.0;
    for (var domain in domains) {
      for (var model in domain.models) {
        for (var concept in model.concepts) {
          maxLevel = max(maxLevel, _getConceptLevel(concept, 1));
        }
      }
    }
    return maxLevel;
  }

  double _getConceptLevel(Concept concept, double currentLevel) {
    double maxLevel = currentLevel;
    for (var child in concept.children) {
      maxLevel = max(maxLevel, _getChildLevel(child, currentLevel + 1));
    }
    return maxLevel;
  }

  double _getChildLevel(Property child, double currentLevel) {
    double maxLevel = currentLevel;
    if (child is Child) {
      maxLevel = max(
        maxLevel,
        _getConceptLevel(child.destinationConcept, currentLevel + 1),
      );
    }
    return maxLevel;
  }

  void _createDomainNodes(
    Domain domain,
    Map<String, Offset> positions,
    int level,
    double maxLevel,
  ) {
    final domainPosition = positions[domain.code];
    if (domainPosition == null) return;

    Color domainColor = _entityPainter.getColorForDomain(
      domain,
      level,
      maxLevel,
    );
    Node domainNode = _entityPainter.createNode(
      domainPosition,
      domainColor,
      domain.code,
    );
    system.addNode(domainNode);

    for (var model in domain.models) {
      final modelPosition = positions[model.code];
      if (modelPosition == null) continue;

      Color modelColor = _entityPainter.getColorForDomain(
        domain,
        level + 1,
        maxLevel,
      );
      Node modelNode = _entityPainter.createNode(
        modelPosition,
        modelColor,
        model.code,
      );
      system.addNode(modelNode);

      // Add line from domain to model
      system.addNode(
        _relationPainter.createLineNode(
          domainPosition,
          modelPosition,
          'has',
          'belongs to',
        ),
      );

      for (var concept in model.concepts) {
        final conceptPosition = positions[concept.code];
        if (conceptPosition == null) continue;

        Color conceptColor = _entityPainter.getColorForDomain(
          domain,
          level + 2,
          maxLevel,
        );
        Node conceptNode = _entityPainter.createNode(
          conceptPosition,
          conceptColor,
          concept.code,
        );
        system.addNode(conceptNode);

        // Add line from model to concept
        system.addNode(
          _relationPainter.createLineNode(
            modelPosition,
            conceptPosition,
            'contains',
            'is part of',
          ),
        );

        for (var child in concept.children) {
          final childPosition = positions[child.code];
          if (childPosition == null) continue;

          Color childColor = _entityPainter.getColorForDomain(
            domain,
            level + 3,
            maxLevel,
          );
          Node childNode = _entityPainter.createNode(
            childPosition,
            childColor,
            child.code,
          );
          system.addNode(childNode);

          // Add line from concept to child
          system.addNode(
            _relationPainter.createLineNode(
              conceptPosition,
              childPosition,
              child.code,
              (child as Neighbor).sourceConcept.code,
            ),
          );
        }

        // Add parent-child relationships within the concept
        for (var parent in concept.parents) {
          final parentPosition = positions[parent.code];
          if (parentPosition != null) {
            system.addNode(
              _relationPainter.createLineNode(
                parentPosition,
                conceptPosition,
                parent.code,
                parent.sourceConcept.code,
              ),
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
