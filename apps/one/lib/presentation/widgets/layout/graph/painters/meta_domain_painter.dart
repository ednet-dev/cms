import 'dart:math';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../components/node.dart';
import '../components/position_component.dart';
import '../components/system.dart';
import '../decorators/u_x_decorator.dart';
import '../layout/layout_algorithm.dart';

class MetaDomainPainter extends CustomPainter {
  final Domains domains;
  final TransformationController transformationController;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;
  final bool isDragging;
  final System system;
  final BuildContext context;
  final String? selectedNode;
  final Function(String) onNodeTap;

  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
    required this.isDragging,
    required this.system,
    required this.context,
    required this.selectedNode,
    required this.onNodeTap,
  });

  Color _getColorForDomain(Domain domain, int level, double maxLevel) {
    double hue = (domain.hashCode % 360).toDouble();
    double saturation = 0.7;
    double brightness = (0.9 - (level / maxLevel) * 0.5).clamp(0.0, 1.0);
    return HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
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

    Color domainColor = _getColorForDomain(domain, level, maxLevel);
    Node domainNode = _createNode(domainPosition, domainColor, domain.code);
    system.addNode(domainNode);

    for (var model in domain.models) {
      final modelPosition = positions[model.code];
      if (modelPosition == null) continue;

      Color modelColor = _getColorForDomain(domain, level + 1, maxLevel);
      Node modelNode = _createNode(modelPosition, modelColor, model.code);
      system.addNode(modelNode);

      // Add line from domain to model
      system.addNode(
        _createLineNode(domainPosition, modelPosition, 'has', 'belongs to'),
      );

      for (var concept in model.concepts) {
        final conceptPosition = positions[concept.code];
        if (conceptPosition == null) continue;

        Color conceptColor = _getColorForDomain(domain, level + 2, maxLevel);
        Node conceptNode = _createNode(
          conceptPosition,
          conceptColor,
          concept.code,
        );
        system.addNode(conceptNode);

        // Add line from model to concept
        system.addNode(
          _createLineNode(
            modelPosition,
            conceptPosition,
            'contains',
            'is part of',
          ),
        );

        for (var child in concept.children) {
          final childPosition = positions[child.code];
          if (childPosition == null) continue;

          Color childColor = _getColorForDomain(domain, level + 3, maxLevel);
          Node childNode = _createNode(childPosition, childColor, child.code);
          system.addNode(childNode);

          // Add line from concept to child
          system.addNode(
            _createLineNode(
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
              _createLineNode(
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

  Node _createLineNode(
    Offset start,
    Offset end,
    String fromToName,
    String toFromName,
  ) {
    Node node = Node();
    node.addComponent(
      LineComponent(
        start: start,
        end: end,
        fromToName: fromToName,
        toFromName: toFromName,
        fromTextStyle: Theme.of(context).textTheme.labelSmall!,
        toTextStyle: Theme.of(context).textTheme.labelSmall!,
      ),
    );
    return node;
  }

  Node _createNode(Offset position, Color color, String label) {
    bool isSelected = label == selectedNode;
    Node node = Node();
    node.addComponent(
      RenderComponent(
        Paint()..color = color,
        Rect.fromCenter(center: position, width: 100, height: 50),
        glow: isSelected ? 10.0 : 0.0,
      ),
    );
    node.addComponent(
      TextComponent(
        text: label,
        position: position,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(color: Colors.white),
        backgroundColor: Colors.black.withValues(alpha: 255.0 * 0.5),
      ),
    );
    return node;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
