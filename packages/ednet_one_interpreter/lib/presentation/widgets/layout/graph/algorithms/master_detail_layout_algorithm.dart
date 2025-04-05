import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'dart:math' as math;

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
    try {
      final positions = <Concept, Offset>{};
      final processedConcepts = <Concept>{};

      // Handle potentially null model
      if (model == null) {
        print('Warning: Model is null in calculatePositions');
        return positions; // Return empty positions
      }

      // Apply safeguards for error cases
      if (domain.models.isEmpty) {
        print('Warning: Domain has no models');
        return positions;
      }

      final concepts = model.concepts;
      if (concepts.isEmpty) {
        print('Warning: Model has no concepts');
        return positions;
      }

      // Find entry concepts
      final entryConcepts = concepts.where((c) => c.entry).toList();
      if (entryConcepts.isEmpty) {
        print('No entry concepts found, using first concept as entry');
        // If no entry concepts, use the first concept as an entry point
        final firstConcept = concepts.first;
        positions[firstConcept] = Offset(startX, startY);
        processedConcepts.add(firstConcept);

        // Layout children of the first concept
        _layoutChildren(
          firstConcept,
          positions,
          processedConcepts,
          horizontalOffset: startX,
          verticalOffset: startY + verticalSpacing,
        );

        return positions;
      }

      // Calculate positions for entry concepts (master entries)
      double currentX = startX;
      double currentY = startY;

      // Position the entry concepts in a row
      for (final concept in entryConcepts) {
        positions[concept] = Offset(currentX, currentY);
        processedConcepts.add(concept);
        currentX += horizontalSpacing;
      }

      // Now process each entry concept's children (detail views)
      for (final entryConcept in entryConcepts) {
        // Skip if the entry concept is null (shouldn't happen, but just in case)
        if (entryConcept == null) continue;

        final entryPosition = positions[entryConcept];
        // Skip if we don't have a position for the entry concept
        if (entryPosition == null) continue;

        _layoutChildren(
          entryConcept,
          positions,
          processedConcepts,
          horizontalOffset: entryPosition.dx,
          verticalOffset: entryPosition.dy + verticalSpacing,
        );
      }

      return positions;
    } catch (e) {
      print('Error in calculatePositions: $e');
      return <Concept, Offset>{};
    }
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
    try {
      // Skip if the concept is null (shouldn't happen, but just in case)
      if (concept == null) {
        print('Warning: Concept is null in _layoutChildren');
        return;
      }

      // Skip if concept.children is null (shouldn't happen, but just in case)
      if (concept.children == null) {
        print('Warning: Concept.children is null for ${concept.code}');
        return;
      }

      // Get valid child relationships
      final children =
          concept.children
              .whereType<Child>()
              .where((child) => child.destinationConcept != null)
              .toList();

      if (children.isEmpty) return;

      double currentX = horizontalOffset;
      final currentY = verticalOffset;

      for (final child in children) {
        try {
          final destinationConcept = child.destinationConcept;

          // Double-check: Skip if destinationConcept is null
          if (destinationConcept == null) {
            print(
              'Warning: destinationConcept is null for child ${child.code} in concept ${concept.code}',
            );
            continue;
          }

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
        } catch (e) {
          // Skip child if there was an error
          print('Error processing child: $e');
          continue;
        }
      }
    } catch (e) {
      // Handle any errors during layout
      print('Error in _layoutChildren: $e');
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
    try {
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
    } catch (e) {
      print('Error creating connection path: $e');
      // Return empty path in case of error
      return Path();
    }
  }
}
