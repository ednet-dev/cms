import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';

/// Extensions for BuildContext for theme operations
extension ThemeContextExtensions on BuildContext {
  /// Get the theme provider
  ThemeProvider get themeProvider =>
      Provider.of<ThemeProvider>(this, listen: false);

  /// Get icon for a concept
  IconData conceptIcon(String conceptType) {
    return themeProvider.conceptIcon(conceptType);
  }

  /// Get color for a concept
  Color conceptColor(String conceptType, {String? role}) {
    return themeProvider.conceptColor(conceptType);
  }

  /// Get text style for a concept
  TextStyle conceptTextStyle(String conceptType, {String? role}) {
    return themeProvider.conceptTextStyle(conceptType, role: role);
  }
}
