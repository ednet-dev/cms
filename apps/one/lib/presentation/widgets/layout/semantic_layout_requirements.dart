import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Defines semantic layout requirements for domain concepts
///
/// This class maps domain concepts to their layout requirements including
/// minimum widths, heights, and other constraints based on the semantic
/// meaning of the concept in the domain model.
class SemanticLayoutRequirements {
  /// Enable debug mode to log layout constraints for troubleshooting
  static bool debugLayoutConstraints = false;

  /// Minimum widths for specific concept types
  static const Map<String, double> conceptMinWidths = {
    // Core domain concepts
    'Domain': 280.0,
    'Model': 240.0,
    'Concept': 220.0,
    'Attribute': 200.0,
    'Entity': 300.0,

    // Common business concepts
    'User': 180.0,
    'Task': 220.0,
    'Project': 250.0,
    'Resource': 200.0,
    'Role': 180.0,
    'Team': 220.0,
    'Milestone': 230.0,
    'Budget': 250.0,
    'Initiative': 280.0,

    // Default for any other concept
    'default': 200.0,
  };

  /// Minimum heights for specific concept types
  static const Map<String, double> conceptMinHeights = {
    'Domain': 100.0,
    'Model': 80.0,
    'Concept': 60.0,
    'Entity': 150.0,

    // Default for any other concept
    'default': 120.0,
  };

  /// Preferred aspect ratios for specific concept types (width/height)
  static const Map<String, double> conceptAspectRatios = {
    'Domain': 2.0, // Wider than tall
    'Model': 1.8,
    'Concept': 1.5,
    'Entity': 1.0, // Square
    // Default for any other concept
    'default': 1.5,
  };

  /// Get the minimum width for a concept
  static double getMinWidthForConcept(String conceptType) {
    return conceptMinWidths[conceptType] ?? conceptMinWidths['default']!;
  }

  /// Get the minimum height for a concept
  static double getMinHeightForConcept(String conceptType) {
    return conceptMinHeights[conceptType] ?? conceptMinHeights['default']!;
  }

  /// Get the aspect ratio for a concept
  static double getAspectRatioForConcept(String conceptType) {
    return conceptAspectRatios[conceptType] ?? conceptAspectRatios['default']!;
  }

  /// Get layout constraints for a concept
  static BoxConstraints getConstraintsForConcept(
    String conceptType, {
    BoxConstraints? parentConstraints,
  }) {
    final minWidth = getMinWidthForConcept(conceptType);
    final minHeight = getMinHeightForConcept(conceptType);

    // Debug output if enabled
    if (debugLayoutConstraints) {
      debugPrint('🔍 Getting constraints for concept: $conceptType');
      debugPrint('  Semantic minWidth: $minWidth, minHeight: $minHeight');
      if (parentConstraints != null) {
        debugPrint('  Parent constraints: $parentConstraints');
      }
    }

    if (parentConstraints != null) {
      // Ensure we never have negative constraints by using max(0, value)
      final safeMaxHeight =
          parentConstraints.hasBoundedHeight
              ? parentConstraints.maxHeight
              : double.infinity;

      // Ensure minimum height is valid
      final safeMinHeight = math.min(minHeight, safeMaxHeight);

      return BoxConstraints(
        minWidth: minWidth,
        maxWidth: parentConstraints.maxWidth,
        minHeight: math.max(0.0, safeMinHeight), // Ensure non-negative
        maxHeight: safeMaxHeight,
      );
    }

    // Simple case with no parent constraints
    return BoxConstraints(
      minWidth: minWidth,
      minHeight: math.max(0.0, minHeight), // Ensure non-negative
    );
  }
}

/// A widget that provides semantic layout constraints for domain concepts
class SemanticLayoutContainer extends StatelessWidget {
  /// The concept type this container represents
  final String conceptType;

  /// Child widget
  final Widget child;

  /// Whether to adapt width to fill available space
  final bool fillWidth;

  /// Whether to adapt height to fill available space
  final bool fillHeight;

  /// Constructor for SemanticLayoutContainer
  const SemanticLayoutContainer({
    super.key,
    required this.conceptType,
    required this.child,
    this.fillWidth = true,
    this.fillHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final semanticConstraints =
            SemanticLayoutRequirements.getConstraintsForConcept(
              conceptType,
              parentConstraints: constraints,
            );

        // Determine if we need to scroll due to constrained width
        final needsHorizontalScroll =
            constraints.maxWidth < semanticConstraints.minWidth;

        // If we need to scroll, wrap in a SingleChildScrollView
        if (needsHorizontalScroll) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: semanticConstraints,
              width: semanticConstraints.minWidth,
              child: child,
            ),
          );
        }

        // Otherwise just apply the constraints
        return Container(
          constraints: semanticConstraints,
          width: fillWidth ? constraints.maxWidth : null,
          height: fillHeight ? constraints.maxHeight : null,
          child: child,
        );
      },
    );
  }
}

/// A widget that provides a flow layout based on semantic constraints
class SemanticFlowLayout extends StatelessWidget {
  /// The children to display in the flow
  final List<Widget> children;

  /// Optional spacing between items horizontally
  final double spacing;

  /// Optional spacing between rows vertically
  final double runSpacing;

  /// Constructor for SemanticFlowLayout
  const SemanticFlowLayout({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children,
        );
      },
    );
  }
}
