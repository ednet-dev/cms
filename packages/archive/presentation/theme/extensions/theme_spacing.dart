import 'package:flutter/material.dart';

/// Extension for standard spacing values in the application theme
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
}
