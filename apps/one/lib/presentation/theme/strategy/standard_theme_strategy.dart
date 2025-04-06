import 'package:flutter/material.dart';
import '../theme.dart';
import '../theme_constants.dart';
import 'theme_strategy.dart';

/// Standard theme strategy implementation that provides semantic styling
/// based on domain concepts while respecting the application's theme system.
///
/// This is a concrete implementation of ThemeStrategy that maps domain
/// concepts to appropriate visual styling, connecting the theme aspect
/// of the "holy trinity" architecture.
class StandardThemeStrategy implements ThemeStrategy {
  @override
  String get id => 'standard';

  @override
  String get name => 'Standard Theme';

  @override
  String get category => 'light';

  /// The base theme data for this strategy
  final ThemeData _themeData;

  /// Constructor for StandardThemeStrategy
  ///
  /// [themeData] - The base theme data to use for this strategy
  StandardThemeStrategy({required ThemeData themeData})
    : _themeData = themeData;

  /// Factory constructor for creating a light theme strategy
  factory StandardThemeStrategy.light() {
    return StandardThemeStrategy(themeData: AppTheme.lightTheme);
  }

  /// Factory constructor for creating a dark theme strategy
  factory StandardThemeStrategy.dark() {
    return StandardThemeStrategy(themeData: AppTheme.darkTheme);
  }

  @override
  ThemeData get themeData => _themeData;

  @override
  Color getColorForConcept(String conceptType, {String? colorRole}) {
    // Map domain concepts to appropriate colors
    switch (conceptType) {
      case 'Entity':
        return _themeData.primaryColor;
      case 'Attribute':
        return _themeData.colorScheme.secondary;
      case 'Relationship':
        return _themeData.colorScheme.tertiary;
      case 'Event':
        return Colors.orange;
      case 'Command':
        return Colors.blue;
      case 'Error':
        return _themeData.colorScheme.error;
      case 'Warning':
        return Colors.amber;
      case 'Success':
        return Colors.green;
      case 'Domain':
        return _themeData.primaryColor;
      case 'Model':
        return _themeData.colorScheme.secondary;
      case 'Concept':
        return _themeData.colorScheme.tertiary;
      default:
        // If no specific mapping exists, use primary color
        return _themeData.primaryColor;
    }
  }

  @override
  TextStyle getTextStyleForConcept(String conceptType, {String? textRole}) {
    // Base text style from the theme
    TextStyle baseStyle = _themeData.textTheme.bodyMedium!;

    // Adjust style based on concept type
    switch (conceptType) {
      case 'Domain':
        baseStyle = _themeData.textTheme.headlineMedium!;
        break;
      case 'Model':
        baseStyle = _themeData.textTheme.headlineSmall!;
        break;
      case 'Concept':
        baseStyle = _themeData.textTheme.titleMedium!;
        break;
      case 'Entity':
        baseStyle = _themeData.textTheme.titleMedium!;
        break;
      case 'Attribute':
        baseStyle = _themeData.textTheme.bodyMedium!;
        break;
      case 'Relationship':
        baseStyle = _themeData.textTheme.bodyMedium!.copyWith(
          fontStyle: FontStyle.italic,
        );
        break;
      default:
        baseStyle = _themeData.textTheme.bodyMedium!;
    }

    // Further adjust based on text role
    if (textRole != null) {
      switch (textRole) {
        case 'title':
          return baseStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: baseStyle.fontSize! * 1.2,
          );
        case 'subtitle':
          return baseStyle.copyWith(
            fontWeight: FontWeight.w500,
            color: baseStyle.color?.withOpacity(0.8),
          );
        case 'description':
          return baseStyle.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: baseStyle.fontSize! * 0.9,
          );
        case 'emphasized':
          return baseStyle.copyWith(fontWeight: FontWeight.bold);
        case 'deemphasized':
          return baseStyle.copyWith(color: baseStyle.color?.withOpacity(0.6));
        default:
          return baseStyle;
      }
    }

    return baseStyle;
  }

  @override
  IconData getIconForConcept(String conceptType) {
    // Map domain concepts to appropriate icons
    switch (conceptType) {
      case 'Domain':
        return Icons.domain;
      case 'Model':
        return Icons.model_training;
      case 'Concept':
        return Icons.bubble_chart;
      case 'Entity':
        return Icons.category;
      case 'Attribute':
        return Icons.label;
      case 'Relationship':
        return Icons.link;
      case 'Event':
        return Icons.event;
      case 'Command':
        return Icons.arrow_forward;
      case 'Query':
        return Icons.search;
      case 'User':
        return Icons.person;
      case 'Group':
        return Icons.group;
      case 'Document':
        return Icons.description;
      case 'Settings':
        return Icons.settings;
      default:
        return Icons.circle;
    }
  }

  @override
  BoxDecoration getDecorationForConcept(
    String conceptType, {
    String? containerRole,
  }) {
    // Default decoration
    var decoration = BoxDecoration(
      color: _themeData.cardColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: _themeData.dividerColor, width: 1),
    );

    // Adjust based on concept type
    switch (conceptType) {
      case 'Domain':
        decoration = BoxDecoration(
          color: getColorForConcept('Domain').withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: getColorForConcept('Domain').withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: getColorForConcept('Domain').withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );
        break;
      case 'Model':
        decoration = BoxDecoration(
          color: getColorForConcept('Model').withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: getColorForConcept('Model').withOpacity(0.3),
            width: 1.5,
          ),
        );
        break;
      case 'Concept':
        decoration = BoxDecoration(
          color: getColorForConcept('Concept').withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: getColorForConcept('Concept').withOpacity(0.2),
            width: 1,
          ),
        );
        break;
      case 'Entity':
        decoration = BoxDecoration(
          color: getColorForConcept('Entity').withOpacity(0.05),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: getColorForConcept('Entity').withOpacity(0.2),
            width: 1,
          ),
        );
        break;
    }

    // Further adjust based on container role
    if (containerRole != null) {
      switch (containerRole) {
        case 'card':
          decoration = decoration.copyWith(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          );
          break;
        case 'panel':
          decoration = decoration.copyWith(
            borderRadius: BorderRadius.circular(4),
          );
          break;
        case 'selected':
          decoration = decoration.copyWith(
            border: Border.all(color: _themeData.colorScheme.primary, width: 2),
          );
          break;
      }
    }

    return decoration;
  }

  @override
  EdgeInsets getPaddingForConcept(String conceptType, {String? containerRole}) {
    // Default padding
    var padding = const EdgeInsets.all(16);

    // Adjust based on concept type
    switch (conceptType) {
      case 'Domain':
        padding = const EdgeInsets.all(24);
        break;
      case 'Model':
        padding = const EdgeInsets.all(20);
        break;
      case 'Concept':
        padding = const EdgeInsets.all(16);
        break;
      case 'Entity':
        padding = const EdgeInsets.all(12);
        break;
      case 'Attribute':
        padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8);
        break;
      case 'Relationship':
        padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8);
        break;
    }

    // Further adjust based on container role
    if (containerRole != null) {
      switch (containerRole) {
        case 'list-item':
          padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
          break;
        case 'compact':
          padding = const EdgeInsets.all(8);
          break;
        case 'expanded':
          padding = const EdgeInsets.all(24);
          break;
      }
    }

    return padding;
  }
}
