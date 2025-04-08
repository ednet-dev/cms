import 'package:flutter/material.dart';

/// ThemeStrategy defines how visual styling is applied to UI elements based on
/// their semantic concepts from the domain model.
///
/// This is part of the "holy trinity" architecture that separates:
/// 1. Layout strategy (how things are arranged)
/// 2. Theme strategy (how things look visually)
/// 3. Domain model (the underlying business concepts)
///
/// Theme strategies provide concept-aware visual styling that respects the
/// semantic meaning of domain concepts while allowing for visual customization.
abstract class ThemeStrategy {
  /// Unique identifier for this theme strategy
  ///
  /// Used to store user preferences and identify this strategy in the system.
  /// Should be a lowercase string with no spaces.
  String get id;

  /// Human-readable name for this theme strategy
  ///
  /// Displayed to users when selecting between theme strategies.
  String get name;

  /// Category this theme belongs to (e.g., "light", "dark", "high contrast")
  ///
  /// Used to group related theme strategies in selection interfaces.
  String get category;

  /// The ThemeData for this theme strategy
  ///
  /// This is the base theme data used by the application.
  ThemeData get themeData;

  /// Get the appropriate color for a concept
  ///
  /// Maps domain concepts to appropriate colors based on their semantic meaning.
  /// For example, "Error" concepts might be red, while "Success" might be green.
  ///
  /// [conceptType] - The type of concept from the domain model
  /// [colorRole] - Optional role for the color (e.g., "background", "text")
  ///
  /// Returns a Color appropriate for this concept
  Color getColorForConcept(String conceptType, {String? colorRole});

  /// Get the appropriate text style for a concept
  ///
  /// Maps domain concepts to appropriate text styles based on their importance
  /// and semantic meaning.
  ///
  /// [conceptType] - The type of concept from the domain model
  /// [textRole] - Optional role for the text (e.g., "title", "subtitle", "body")
  ///
  /// Returns a TextStyle appropriate for this concept
  TextStyle getTextStyleForConcept(String conceptType, {String? textRole});

  /// Get the appropriate icon for a concept
  ///
  /// Maps domain concepts to appropriate icons based on their semantic meaning.
  ///
  /// [conceptType] - The type of concept from the domain model
  ///
  /// Returns an IconData appropriate for this concept
  IconData getIconForConcept(String conceptType);

  /// Get the appropriate decoration for a container based on concept
  ///
  /// Maps domain concepts to appropriate decorations based on their semantic meaning.
  ///
  /// [conceptType] - The type of concept from the domain model
  /// [containerRole] - Optional role for the container (e.g., "card", "panel")
  ///
  /// Returns a BoxDecoration appropriate for this concept
  BoxDecoration getDecorationForConcept(
    String conceptType, {
    String? containerRole,
  });

  /// Get the appropriate padding for a container based on concept
  ///
  /// Maps domain concepts to appropriate padding based on their semantic meaning
  /// and importance.
  ///
  /// [conceptType] - The type of concept from the domain model
  /// [containerRole] - Optional role for the container (e.g., "card", "panel")
  ///
  /// Returns EdgeInsets appropriate for this concept
  EdgeInsets getPaddingForConcept(String conceptType, {String? containerRole});
}

/// Extension for making it easier to apply theme strategies to widgets
extension ThemeStrategyExtension on BuildContext {
  /// Get the theme strategy from the current context
  ///
  /// This is a convenience method to access the current theme strategy.
  /// It requires a ThemeProvider ancestor widget.
  ThemeStrategy get themeStrategy {
    // This will be implemented once we create the ThemeProvider
    // For now, it's just a placeholder
    throw UnimplementedError('ThemeProvider not yet implemented');
  }

  /// Get a color for a concept using the current theme strategy
  ///
  /// This is a convenience method to get an appropriate color for a concept.
  ///
  /// Example:
  /// ```dart
  /// final errorColor = context.conceptColor('Error');
  /// ```
  Color conceptColor(String conceptType, {String? role}) {
    return themeStrategy.getColorForConcept(conceptType, colorRole: role);
  }

  /// Get a text style for a concept using the current theme strategy
  ///
  /// This is a convenience method to get an appropriate text style for a concept.
  ///
  /// Example:
  /// ```dart
  /// final titleStyle = context.conceptTextStyle('User', role: 'title');
  /// ```
  TextStyle conceptTextStyle(String conceptType, {String? role}) {
    return themeStrategy.getTextStyleForConcept(conceptType, textRole: role);
  }
}
