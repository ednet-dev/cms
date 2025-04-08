import 'package:flutter/material.dart';

/// A layout strategy defines how UI components should be sized, positioned and organized
/// based on semantic concepts from the domain model.
///
/// This is part of the "holy trinity" architecture that separates:
/// 1. Layout strategy (how things are arranged)
/// 2. Theme strategy (how things look visually)
/// 3. Domain model (the underlying business concepts)
///
/// By making these three aspects pluggable and interchangeable, we achieve a flexible
/// architecture that can adapt to different user preferences and device capabilities
/// while maintaining semantic meaning from the domain model.
/// // TODO: Use ednet_core/ednet_core.dart entity for identity and value objects for immutable objects
abstract class LayoutStrategy {
  /// Unique identifier for this layout strategy
  ///
  /// Used to store user preferences and identify this strategy in the system.
  /// Should be a lowercase string with no spaces.
  String get id;

  /// Human-readable name for this strategy
  ///
  /// Displayed to users when selecting between layout strategies.
  String get name;

  /// Category this layout belongs to (e.g., "compact", "detailed", "accessibility")
  ///
  /// Used to group related layout strategies in selection interfaces.
  String get category;

  /// Returns appropriate layout constraints for a given concept type
  ///
  /// This method maps semantic domain concepts to appropriate size constraints.
  /// For example, a "User" concept might have different size requirements than
  /// a "Transaction" concept.
  ///
  /// [conceptType] - The type of concept from the domain model (e.g., "User", "Project")
  /// [parentConstraints] - The constraints imposed by the parent widget
  ///
  /// Returns [BoxConstraints] that define the min/max dimensions for this concept.
  BoxConstraints getConstraintsForConcept(
    String conceptType,
    BoxConstraints parentConstraints,
  );

  /// Builds a container widget appropriate for a domain concept
  ///
  /// This method creates a container that respects the semantic requirements
  /// of the given concept type, applying appropriate constraints, scrolling
  /// behavior, and other layout characteristics.
  ///
  /// [context] - The build context
  /// [conceptType] - Type of concept from the domain model
  /// [child] - The child widget to contain
  /// [fillWidth] - Whether to expand to fill available width
  /// [fillHeight] - Whether to expand to fill available height
  ///
  /// Returns a Widget that properly contains the child according to this layout strategy.
  Widget buildConceptContainer({
    required BuildContext context,
    required String conceptType,
    required Widget child,
    bool fillWidth = true,
    bool fillHeight = false,
  });

  /// Builds a flow layout for multiple components
  ///
  /// This method organizes multiple widgets in a flow-based layout that adapts
  /// to available space, similar to a responsive grid or flow layout.
  ///
  /// [context] - The build context
  /// [children] - List of widgets to arrange
  /// [spacing] - Horizontal space between items
  /// [runSpacing] - Vertical space between rows
  ///
  /// Returns a Widget that organizes children according to this layout strategy.
  Widget buildFlowLayout({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 16.0,
    double runSpacing = 16.0,
  });

  /// Determines if this layout strategy is suitable for the current device
  ///
  /// Some layout strategies might be optimized for certain device types.
  /// This method allows the strategy to indicate whether it's appropriate
  /// for the current device based on screen size, orientation, etc.
  ///
  /// [context] - The build context, used to access MediaQuery
  ///
  /// Returns true if this strategy is suitable for the current device.
  bool isSuitableForDevice(BuildContext context) {
    // Default implementation assumes suitable for all devices
    return true;
  }
}

/// Extension for applying layout strategies to widgets directly
extension LayoutStrategyExtension on Widget {
  /// Wraps this widget in a concept container using the provided layout strategy
  ///
  /// This is a convenience method that makes it easier to apply layout strategies
  /// inline in widget tree construction.
  ///
  /// Example:
  /// ```dart
  /// Text('Hello')
  ///   .withConceptLayout(layoutStrategy, 'User', context)
  /// ```
  Widget withConceptLayout(
    LayoutStrategy strategy,
    String conceptType,
    BuildContext context, {
    bool fillWidth = true,
    bool fillHeight = false,
  }) {
    return strategy.buildConceptContainer(
      context: context,
      conceptType: conceptType,
      child: this,
      fillWidth: fillWidth,
      fillHeight: fillHeight,
    );
  }
}
