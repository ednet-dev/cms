import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'layout_strategy.dart';

/// Implementation of [LayoutStrategy] optimized for compact displays
///
/// The CompactLayoutStrategy prioritizes efficient use of screen space by:
/// - Using smaller minimum widths/heights for components
/// - Applying tighter padding and spacing
/// - Using more aggressive text truncation
/// - Preferring stacked layouts over side-by-side when space is constrained
///
/// This strategy is ideal for mobile devices or multi-panel desktop layouts
/// where screen real estate is limited.
class CompactLayoutStrategy extends LayoutStrategy {
  /// Map of concept types to their minimum widths in compact layout
  static const Map<String, double> _conceptMinWidths = {
    'Domain': 180.0,
    'Model': 160.0,
    'Concept': 150.0,
    'Entity': 180.0,
    'User': 140.0,
    'Task': 140.0,
    'Project': 150.0,
    'default': 140.0,
  };

  /// Map of concept types to their minimum heights in compact layout
  static const Map<String, double> _conceptMinHeights = {
    'Domain': 60.0,
    'Model': 50.0,
    'Concept': 40.0,
    'Entity': 120.0,
    'default': 80.0,
  };

  @override
  String get id => 'compact';

  @override
  String get name => 'Compact Layout';

  @override
  String get category => 'efficiency';

  @override
  BoxConstraints getConstraintsForConcept(
    String conceptType,
    BoxConstraints parentConstraints,
  ) {
    // Get minimum dimensions for this concept type
    final minWidth =
        _conceptMinWidths[conceptType] ?? _conceptMinWidths['default']!;
    final minHeight =
        _conceptMinHeights[conceptType] ?? _conceptMinHeights['default']!;

    // If parent constraints are unbounded or too small, return our minimums
    if (!parentConstraints.hasBoundedWidth ||
        parentConstraints.maxWidth < minWidth) {
      return BoxConstraints(minWidth: minWidth, minHeight: minHeight);
    }

    // Otherwise adapt to parent constraints
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: parentConstraints.maxWidth,
      minHeight: math.min(minHeight, parentConstraints.maxHeight),
      maxHeight: parentConstraints.maxHeight,
    );
  }

  @override
  Widget buildConceptContainer({
    required BuildContext context,
    required String conceptType,
    required Widget child,
    bool fillWidth = true,
    bool fillHeight = false,
  }) {
    // First get appropriate constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        final semanticConstraints = getConstraintsForConcept(
          conceptType,
          constraints,
        );

        // Determine if we need horizontal scrolling
        final needsHorizontalScroll =
            constraints.maxWidth < semanticConstraints.minWidth;

        // Apply horizontal scrolling if needed
        if (needsHorizontalScroll) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(
                minWidth: semanticConstraints.minWidth,
                maxWidth: semanticConstraints.minWidth,
                minHeight: semanticConstraints.minHeight,
                maxHeight: semanticConstraints.maxHeight,
              ),
              child: child,
            ),
          );
        }

        // Otherwise just constrain the child
        return Container(
          constraints: semanticConstraints,
          width: fillWidth ? constraints.maxWidth : null,
          height: fillHeight ? constraints.maxHeight : null,
          child: child,
        );
      },
    );
  }

  @override
  Widget buildFlowLayout({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 8.0, // Compact uses smaller spacing
    double runSpacing = 8.0,
  }) {
    // Wrap widgets in a flow that allows them to reflow as needed
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children:
              children.map((child) {
                // Apply layout constraints to each child
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                  child: child,
                );
              }).toList(),
        );
      },
    );
  }

  @override
  bool isSuitableForDevice(BuildContext context) {
    // Especially suitable for small screens
    final width = MediaQuery.of(context).size.width;
    return width < 600 || width < 1200; // Mobile or small tablet/desktop
  }
}
