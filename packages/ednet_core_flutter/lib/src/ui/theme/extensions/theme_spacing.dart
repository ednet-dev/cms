part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Extension for standard spacing values in the application theme
/// Enhanced with disclosure level support for progressive UI
extension ThemeSpacing on BuildContext {
  /// Very small spacing (4.0)
  double get spacingXs => 4.0;

  /// Small spacing (8.0)
  double get spacingS => 8.0;

  /// Medium spacing (16.0)
  double get spacingM => 16.0;

  /// Large spacing (24.0)
  double get spacingL => 24.0;

  /// Extra large spacing (32.0)
  double get spacingXl => 32.0;

  /// Double extra large spacing (48.0)
  double get spacingXxl => 48.0;

  /// Standard card padding (16.0)
  double get cardPadding => 16.0;

  /// Standard container padding (16.0)
  EdgeInsets get containerPadding => EdgeInsets.all(spacingM);

  /// Standard content spacing (8.0)
  double get contentSpacing => 8.0;

  /// Item spacing in list/grid (16.0)
  double get itemSpacing => 16.0;

  /// Section spacing (24.0)
  double get sectionSpacing => 24.0;

  /// Form field spacing (16.0)
  double get formFieldSpacing => 16.0;

  /// Semantic spacing based on concept type
  double semanticSpacing(String conceptType, {String? role}) {
    // Customize spacing based on concept and role if needed
    switch (conceptType) {
      case 'FormField':
        return 16.0;
      case 'Card':
        return 16.0;
      case 'List':
        return 8.0;
      case 'Grid':
        return 16.0;
      case 'Compact':
        return 8.0;
      case 'Spacious':
        return 24.0;
      default:
        return 16.0;
    }
  }

  /// Get spacing adjusted for the current disclosure level
  ///
  /// This helps to implement progressive disclosure by
  /// adjusting spacing based on complexity level
  double disclosureLevelSpacing(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
        return 8.0; // Tight spacing for minimal views
      case DisclosureLevel.basic:
        return 12.0; // Still compact for basic views
      case DisclosureLevel.standard:
        return 16.0; // Standard spacing
      case DisclosureLevel.intermediate:
        return 16.0; // Same as standard
      case DisclosureLevel.advanced:
        return 16.0; // Same as standard
      case DisclosureLevel.detailed:
        return 20.0; // More breathing room for detailed views
      case DisclosureLevel.complete:
        return 24.0; // Maximum spacing for complete views
      case DisclosureLevel.debug:
        return 24.0; // Same as complete
    }
  }

  /// Get card padding adjusted for the current disclosure level
  ///
  /// Cards have different padding based on the detail level
  EdgeInsets disclosureLevelCardPadding(DisclosureLevel level) {
    final padding = disclosureLevelSpacing(level);
    return EdgeInsets.all(padding);
  }

  /// Get spacing for a specific concept type at a specific disclosure level
  ///
  /// This combines semantic concept awareness with progressive disclosure
  double semanticDisclosureSpacing(String conceptType, DisclosureLevel level,
      {String? role}) {
    // First get the base semantic spacing
    final baseSpacing = semanticSpacing(conceptType, role: role);

    // Then adjust it based on disclosure level
    switch (level) {
      case DisclosureLevel.minimal:
        return baseSpacing * 0.75; // Reduce by 25%
      case DisclosureLevel.basic:
        return baseSpacing * 0.875; // Reduce by 12.5%
      case DisclosureLevel.standard:
        return baseSpacing; // No adjustment
      case DisclosureLevel.intermediate:
        return baseSpacing; // No adjustment
      case DisclosureLevel.advanced:
        return baseSpacing; // No adjustment
      case DisclosureLevel.detailed:
        return baseSpacing * 1.125; // Increase by 12.5%
      case DisclosureLevel.complete:
        return baseSpacing * 1.25; // Increase by 25%
      case DisclosureLevel.debug:
        return baseSpacing * 1.25; // Same as complete
    }
  }
}
