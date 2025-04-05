import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

/// A layout algorithm for domain model visualization that arranges elements
/// in a master-detail pattern.
///
/// This algorithm arranges concepts and relationships to support a visual
/// hierarchy where:
/// - Root concepts (entries) are positioned at the top level
/// - Related concepts are organized as detail views
/// - Relationships are drawn with appropriate connections
class MasterDetailLayoutAlgorithm {
  /// The horizontal spacing between elements
  final double horizontalSpacing;

  /// The vertical spacing between elements
  final double verticalSpacing;

  /// The starting x position for the layout
  final double startX;

  /// The starting y position for the layout
  final double startY;

  /// Creates a new MasterDetailLayoutAlgorithm with the specified spacing.
  const MasterDetailLayoutAlgorithm({
    this.horizontalSpacing = 200.0,
    this.verticalSpacing = 150.0,
    this.startX = 100.0,
    this.startY = 100.0,
  });

  /// Calculates positions for domain concepts and relationships.
  ///
  /// [domain] is the domain to calculate positions for.
  /// [model] is the specific model within the domain.
  ///
  /// Returns a map where keys are concepts and values are their calculated positions.
  Map<Concept, Offset> calculatePositions(Domain domain, Model? model) {
    final positions = <Concept, Offset>{};
    final processedConcepts = <Concept>{};

    final concepts = model?.concepts ?? domain.models.expand((m) => m.concepts);
    final entryConcepts = concepts.where((c) => c.entry);

    // Calculate positions for entry concepts (master entries)
    double currentX = startX;
    double currentY = startY;

    for (final concept in entryConcepts) {
      positions[concept] = Offset(currentX, currentY);
      processedConcepts.add(concept);
      currentX += horizontalSpacing;
    }

    // Now process each entry concept's children (detail views)
    for (final entryConcept in entryConcepts) {
      _layoutChildren(
        entryConcept,
        positions,
        processedConcepts,
        horizontalOffset: positions[entryConcept]!.dx,
        verticalOffset: positions[entryConcept]!.dy + verticalSpacing,
      );
    }

    return positions;
  }

  /// Recursively calculates positions for children of a concept.
  ///
  /// [concept] is the parent concept.
  /// [positions] is the map to populate with calculated positions.
  /// [processedConcepts] tracks concepts that already have positions.
  /// [horizontalOffset] is the starting x position for child layout.
  /// [verticalOffset] is the starting y position for child layout.
  void _layoutChildren(
    Concept concept,
    Map<Concept, Offset> positions,
    Set<Concept> processedConcepts, {
    required double horizontalOffset,
    required double verticalOffset,
  }) {
    // Get child relationships
    final children = concept.children.whereType<Child>().toList();
    if (children.isEmpty) return;

    double currentX = horizontalOffset;
    final currentY = verticalOffset;

    for (final child in children) {
      final destinationConcept = child.destinationConcept;

      if (!processedConcepts.contains(destinationConcept)) {
        positions[destinationConcept] = Offset(currentX, currentY);
        processedConcepts.add(destinationConcept);

        // Recursively layout this concept's children
        _layoutChildren(
          destinationConcept,
          positions,
          processedConcepts,
          horizontalOffset: currentX,
          verticalOffset: currentY + verticalSpacing,
        );

        currentX += horizontalSpacing;
      }
    }
  }

  /// Creates a connection path between two concept nodes.
  ///
  /// [startPosition] is the position of the parent concept.
  /// [endPosition] is the position of the child concept.
  /// [conceptSize] is the size of concept nodes.
  ///
  /// Returns a path representing the connection.
  Path createConnectionPath(
    Offset startPosition,
    Offset endPosition,
    Size conceptSize,
  ) {
    final path = Path();

    // Calculate actual start/end points from center of nodes
    final startCenter =
        startPosition + Offset(conceptSize.width / 2, conceptSize.height / 2);
    final endCenter =
        endPosition + Offset(conceptSize.width / 2, conceptSize.height / 2);

    // Calculate control points for a smooth curve
    final controlPoint1 = Offset(
      startCenter.dx,
      startCenter.dy + (endCenter.dy - startCenter.dy) / 2,
    );

    final controlPoint2 = Offset(
      endCenter.dx,
      startCenter.dy + (endCenter.dy - startCenter.dy) / 2,
    );

    // Draw the curved path
    path.moveTo(startCenter.dx, startCenter.dy);
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endCenter.dx,
      endCenter.dy,
    );

    return path;
  }
}
