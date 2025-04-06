import 'dart:math';
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';

import '../components/tree_node.dart';
import '../layout/layout_algorithm.dart';

class RankedEmbeddingLayoutAlgorithm extends LayoutAlgorithm {
  final double nodeWidth = 100.0;
  final double nodeHeight = 50.0;
  final double verticalGap = 80.0;
  final double horizontalGap = 30.0;

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final domainSizes = <String, Size>{};

    for (var domain in domains) {
      final domainSize = _calculateDomainSize(domain);
      domainSizes[domain.code] = domainSize;
    }

    double currentX = 0.0;
    for (var domain in domains) {
      final domainSize = domainSizes[domain.code]!;
      final rootX = currentX + domainSize.width / 2;
      final rootY = domainSize.height / 2 + verticalGap;
      final root = TreeNode(domain.code, Offset(rootX, rootY));
      positions[domain.code] = root.position;
      _calculateModelPositions(
        root,
        domain.models,
        currentX,
        currentX + domainSize.width,
        positions,
      );
      currentX += domainSize.width + horizontalGap;
    }

    return positions;
  }

  Size _calculateDomainSize(Domain domain) {
    double maxWidth = 0.0;
    double totalHeight = 0.0;

    for (var model in domain.models) {
      final modelSize = _calculateModelSize(model);
      maxWidth = max(maxWidth, modelSize.width);
      totalHeight += modelSize.height + verticalGap;
    }

    return Size(maxWidth, totalHeight);
  }

  Size _calculateModelSize(Model model) {
    double maxWidth = 0.0;
    double totalHeight = 0.0;

    for (var concept in model.concepts) {
      final conceptSize = _calculateConceptSize(concept);
      maxWidth = max(maxWidth, conceptSize.width);
      totalHeight += conceptSize.height + verticalGap;
    }

    return Size(maxWidth, totalHeight);
  }

  Size _calculateConceptSize(Concept concept) {
    double maxWidth = 0.0;
    double totalHeight = 0.0;

    for (var child in concept.children) {
      final childSize = _calculateConceptSize(
        (child as Child).destinationConcept,
      );
      maxWidth = max(maxWidth, childSize.width);
      totalHeight += childSize.height + verticalGap;
    }

    for (var attribute in concept.attributes) {
      maxWidth = max(maxWidth, nodeWidth);
      totalHeight += nodeHeight + verticalGap;
    }

    return Size(maxWidth, totalHeight);
  }

  void _calculateModelPositions(
    TreeNode parent,
    Models models,
    double xMin,
    double xMax,
    Map<String, Offset> positions,
  ) {
    if (models.isEmpty) return;

    final y = parent.position.dy + verticalGap;
    final width = (xMax - xMin) / max(1, models.length);

    for (var i = 0; i < models.length; i++) {
      final model = models.at(i);
      final x = xMin + i * width + width / 2;
      final childNode = TreeNode(model.code, Offset(x, y));
      parent.children.add(childNode);
      positions[childNode.key] = childNode.position;
      _calculateConceptPositions(
        childNode,
        model.concepts,
        xMin + i * width,
        xMin + (i + 1) * width,
        positions,
      );
    }
  }

  void _calculateConceptPositions(
    TreeNode parent,
    Concepts concepts,
    double xMin,
    double xMax,
    Map<String, Offset> positions,
  ) {
    if (concepts.isEmpty) return;

    final y = parent.position.dy + verticalGap;
    final width = (xMax - xMin) / max(1, concepts.length);

    for (var i = 0; i < concepts.length; i++) {
      final concept = concepts.at(i);
      final x = xMin + i * width + width / 2;
      final childNode = TreeNode(concept.code, Offset(x, y));
      parent.children.add(childNode);
      positions[childNode.key] = childNode.position;
      _calculateConceptChildrenPositions(
        childNode,
        concept.children,
        xMin + i * width,
        xMin + (i + 1) * width,
        positions,
      );
      _calculateAttributePositions(
        childNode,
        concept.attributes,
        xMin + i * width,
        xMin + (i + 1) * width,
        positions,
      );
    }
  }

  void _calculateConceptChildrenPositions(
    TreeNode parent,
    Children children,
    double xMin,
    double xMax,
    Map<String, Offset> positions,
  ) {
    if (children.isEmpty) return;

    final y = parent.position.dy + verticalGap;
    final width = (xMax - xMin) / max(1, children.length);

    for (var i = 0; i < children.length; i++) {
      final child = children.at(i);
      final x = xMin + i * width + width / 2;
      final childNode = TreeNode(child.code, Offset(x, y));
      parent.children.add(childNode);
      positions[childNode.key] = childNode.position;

      // If the child can navigate, calculate the positions of its children
      if (child is Child && child.navigate) {
        _calculateConceptChildrenPositions(
          childNode,
          child.destinationConcept.children,
          xMin + i * width,
          xMin + (i + 1) * width,
          positions,
        );
      }
    }
  }

  void _calculateAttributePositions(
    TreeNode parent,
    Attributes attributes,
    double xMin,
    double xMax,
    Map<String, Offset> positions,
  ) {
    if (attributes.isEmpty) return;

    final y = parent.position.dy + verticalGap;
    final width = (xMax - xMin) / max(1, attributes.length);

    for (var i = 0; i < attributes.length; i++) {
      final attribute = attributes.at(i);
      final x = xMin + i * width + width / 2;
      final childNode = TreeNode(attribute.code, Offset(x, y));
      parent.children.add(childNode);
      positions[childNode.key] = childNode.position;
    }
  }
}
