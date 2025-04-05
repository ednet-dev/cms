import 'package:flutter/material.dart';

/// State for the theme bloc containing theme data and mode information
class ThemeState {
  /// The current theme data
  final ThemeData themeData;

  /// Flag indicating if dark mode is enabled
  final bool isDarkMode;

  /// The name of the current theme style
  final String themeName;

  /// Creates a new theme state with the specified parameters
  ThemeState({
    required this.themeData,
    required this.isDarkMode,
    required this.themeName,
  });
}
