import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../layouts/providers/layout_provider.dart';

/// A container that applies semantic layout constraints based on concept type
///
/// This widget is the primary integration point for the semantic layout system.
/// It automatically applies appropriate layout constraints, scrolling behavior,
/// and other layout characteristics based on the semantic meaning of the
/// specified concept type.
///
/// SemanticConceptContainer is part of the "holy trinity" architecture that
/// separates layout, theme, and domain model concerns while maintaining semantic
/// connections between them.
///
/// Example:
/// ```dart
/// SemanticConceptContainer(
///   conceptType: 'User',
///   child: UserProfileWidget(),
/// )
/// ```
class SemanticConceptContainer extends StatelessWidget {
  /// The type of domain concept this container represents
  ///
  /// This is used to determine appropriate sizing, layout constraints,
  /// and scrolling behavior based on the semantic requirements of the concept.
  final String conceptType;

  /// The child widget to display within this container
  final Widget child;

  /// Whether to expand to fill available width
  final bool fillWidth;

  /// Whether to expand to fill available height
  final bool fillHeight;

  /// Whether to make the content scrollable
  final bool scrollable;

  /// ScrollController for the scrollable content
  final ScrollController? scrollController;

  /// Constructor for SemanticConceptContainer
  const SemanticConceptContainer({
    super.key,
    required this.conceptType,
    required this.child,
    this.fillWidth = true,
    this.fillHeight = false,
    this.scrollable = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Get the active layout strategy from the provider
    final layoutProvider = Provider.of<LayoutProvider>(context);

    // Get the container from the layout strategy
    Widget container = layoutProvider.activeStrategy.buildConceptContainer(
      context: context,
      conceptType: conceptType,
      child: child,
      fillWidth: fillWidth,
      fillHeight: fillHeight,
    );

    // Wrap with scroll container if needed
    if (scrollable) {
      return SingleChildScrollView(
        controller: scrollController,
        child: container,
      );
    }

    return container;
  }
}

/// A container for flowing multiple child widgets with semantic layout
///
/// This widget applies appropriate flow layout for a collection of widgets,
/// adapting to available space according to the current layout strategy.
///
/// Example:
/// ```dart
/// SemanticFlowContainer(
///   children: [
///     UserWidget(user1),
///     UserWidget(user2),
///     UserWidget(user3),
///   ],
/// )
/// ```
class SemanticFlowContainer extends StatelessWidget {
  /// List of child widgets to arrange in the flow layout
  final List<Widget> children;

  /// Optional horizontal spacing between items
  final double spacing;

  /// Optional vertical spacing between rows
  final double runSpacing;

  /// Constructor for SemanticFlowContainer
  const SemanticFlowContainer({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    // Get the active layout strategy from the provider
    final layoutProvider = Provider.of<LayoutProvider>(context);

    // Use the active strategy to build the flow layout
    return layoutProvider.activeStrategy.buildFlowLayout(
      context: context,
      children: children,
      spacing: spacing,
      runSpacing: runSpacing,
    );
  }
}

/// A builder widget that provides semantic layout constraints
///
/// This widget is useful when you need to know the appropriate layout
/// constraints for a concept type when building a custom layout.
///
/// Example:
/// ```dart
/// SemanticConstraintsBuilder(
///   conceptType: 'User',
///   builder: (context, constraints) {
///     return Container(
///       width: constraints.minWidth,
///       height: constraints.minHeight,
///       child: UserProfileWidget(),
///     );
///   },
/// )
/// ```
class SemanticConstraintsBuilder extends StatelessWidget {
  /// The type of domain concept to get constraints for
  final String conceptType;

  /// Builder function that receives the semantic constraints
  final Widget Function(BuildContext context, BoxConstraints constraints)
  builder;

  /// Constructor for SemanticConstraintsBuilder
  const SemanticConstraintsBuilder({
    super.key,
    required this.conceptType,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the layout provider
        final layoutProvider = Provider.of<LayoutProvider>(context);

        // Get semantic constraints for this concept
        final semanticConstraints = layoutProvider.activeStrategy
            .getConstraintsForConcept(conceptType, constraints);

        // Call the builder with the semantic constraints
        return builder(context, semanticConstraints);
      },
    );
  }
}
