import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'layout_strategy.dart';

/// Implementation of [LayoutStrategy] optimized for detailed information display
///
/// The DetailedLayoutStrategy prioritizes clarity and information density by:
/// - Using larger minimum widths/heights for components
/// - Applying more generous padding and spacing
/// - Showing more information fields and details
/// - Preferring side-by-side layouts when space permits
///
/// This strategy is ideal for desktop or tablet displays where users need
/// more detailed information and have larger screens available.
class DetailedLayoutStrategy extends LayoutStrategy {
  /// Map of concept types to their minimum widths in detailed layout
  static const Map<String, double> _conceptMinWidths = {
    'Domain': 320.0,
    'Model': 280.0,
    'Concept': 260.0,
    'Entity': 400.0,
    'User': 220.0,
    'Task': 280.0,
    'Project': 320.0,
    'default': 240.0,
  };

  /// Map of concept types to their minimum heights in detailed layout
  static const Map<String, double> _conceptMinHeights = {
    'Domain': 120.0,
    'Model': 100.0,
    'Concept': 80.0,
    'Entity': 200.0,
    'default': 120.0,
  };

  @override
  String get id => 'detailed';

  @override
  String get name => 'Detailed Layout';

  @override
  String get category => 'clarity';

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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                minWidth: semanticConstraints.minWidth,
                maxWidth: semanticConstraints.minWidth,
                minHeight: semanticConstraints.minHeight,
                maxHeight: semanticConstraints.maxHeight,
              ),
              // Apply padding for detailed view
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          );
        }

        // Otherwise just constrain the child with padding
        return Container(
          constraints: semanticConstraints,
          width: fillWidth ? constraints.maxWidth : null,
          height: fillHeight ? constraints.maxHeight : null,
          // Apply padding for detailed view
          padding: const EdgeInsets.all(16.0),
          child: child,
        );
      },
    );
  }

  @override
  Widget buildFlowLayout({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 16.0, // Detailed uses larger spacing
    double runSpacing = 24.0,
  }) {
    // Use grid-like layout for larger screens when possible
    return LayoutBuilder(
      builder: (context, constraints) {
        // Attempt to use a grid for larger screens
        if (constraints.maxWidth > 800) {
          // Calculate number of columns based on available width
          final columnCount = math.max(1, constraints.maxWidth ~/ 400);

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              childAspectRatio: 2.0,
              crossAxisSpacing: spacing,
              mainAxisSpacing: runSpacing,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          );
        } else {
          // Fall back to wrap for smaller screens
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children:
                children.map((child) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth,
                      minHeight: 80,
                    ),
                    child: child,
                  );
                }).toList(),
          );
        }
      },
    );
  }

  @override
  bool isSuitableForDevice(BuildContext context) {
    // Better suited for larger screens
    final width = MediaQuery.of(context).size.width;
    return width >= 1024; // Desktop or large tablet
  }
}
