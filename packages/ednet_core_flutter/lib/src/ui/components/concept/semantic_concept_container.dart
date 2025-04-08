part of ednet_core_flutter;

/// A container that applies semantic layout constraints based on concept type
///
/// This widget is the primary integration point for the semantic layout system.
/// It automatically applies appropriate layout constraints, scrolling behavior,
/// and other layout characteristics based on the semantic meaning of the
/// specified concept type.
///
/// SemanticConceptContainer is part of the EDNet Shell Architecture that
/// separates layout, theme, and domain model concerns while maintaining semantic
/// connections between them.
///
/// Example:
/// ```dart
/// SemanticConceptContainer(
///   conceptType: 'User',
///   child: UserProfileWidget(),
///   disclosureLevel: DisclosureLevel.standard,
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

  /// Optional padding to override the default for this concept
  final EdgeInsetsGeometry? padding;

  /// Whether to apply the default semantic padding for this concept type
  final bool applySemanticPadding;

  /// Optional margin to apply around the container
  final EdgeInsetsGeometry? margin;

  /// The disclosure level to use for this container
  final DisclosureLevel disclosureLevel;

  /// Constructor for SemanticConceptContainer
  const SemanticConceptContainer({
    Key? key,
    required this.conceptType,
    required this.child,
    this.fillWidth = true,
    this.fillHeight = false,
    this.scrollable = false,
    this.scrollController,
    this.padding,
    this.applySemanticPadding = false,
    this.margin,
    this.disclosureLevel = DisclosureLevel.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a simple container for now
    Widget container = Container(
      width: fillWidth ? double.infinity : null,
      height: fillHeight ? double.infinity : null,
      color: Theme.of(context).colorScheme.surface,
      child: child,
    );

    // Apply semantic padding if specified
    if (applySemanticPadding) {
      const spacing = 16.0; // Default semantic spacing
      container = Padding(
        padding: const EdgeInsets.all(spacing),
        child: container,
      );
    }

    // Apply custom padding if specified (overrides semantic padding)
    if (padding != null) {
      container = Padding(
        padding: padding!,
        child: container,
      );
    }

    // Apply margin if specified
    if (margin != null) {
      container = Padding(
        padding: margin!,
        child: container,
      );
    }

    // Handle scrolling more intelligently
    if (scrollable) {
      // Check if we're already in a ScrollView by looking for ScrollController in ancestry
      final existingController =
          scrollController ?? PrimaryScrollController.maybeOf(context);

      return LayoutBuilder(
        builder: (context, constraints) {
          // If height is constrained, use scrolling container
          if (constraints.maxHeight.isFinite) {
            return Scrollbar(
              controller: existingController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: existingController,
                // Only use primary if:
                // 1. We don't have an explicit controller AND
                // 2. We're not already within a scroll view
                primary: scrollController == null && existingController == null,
                child: container,
              ),
            );
          } else {
            // If constraints allow unlimited height, just return the container
            // to avoid nested scrolling issues
            return container;
          }
        },
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
///   disclosureLevel: DisclosureLevel.standard,
/// )
/// ```
class SemanticFlowContainer extends StatelessWidget {
  /// List of child widgets to arrange in the flow layout
  final List<Widget> children;

  /// Optional horizontal spacing between items
  final double spacing;

  /// Optional vertical spacing between rows
  final double runSpacing;

  /// The disclosure level to use for this container
  final DisclosureLevel disclosureLevel;

  /// Constructor for SemanticFlowContainer
  const SemanticFlowContainer({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.disclosureLevel = DisclosureLevel.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
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
///   disclosureLevel: DisclosureLevel.standard,
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

  /// The disclosure level to use for constraints
  final DisclosureLevel disclosureLevel;

  /// Constructor for SemanticConstraintsBuilder
  const SemanticConstraintsBuilder({
    Key? key,
    required this.conceptType,
    required this.builder,
    this.disclosureLevel = DisclosureLevel.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For now, just pass along the layout constraints
        final semanticConstraints = constraints;

        // Call the builder with the semantic constraints
        return builder(context, semanticConstraints);
      },
    );
  }
}
