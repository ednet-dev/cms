import 'package:flutter/material.dart';

/// Abstract base class for all theme components
///
/// Each theme component represents a specific theme style (CLI, Cheerful, Minimalistic)
/// and provides both light and dark theme variants.
abstract class ThemeComponent {
  /// Get the name of this theme component
  String get name;

  /// Get the light mode theme data
  ThemeData get lightTheme;

  /// Get the dark mode theme data
  ThemeData get darkTheme;

  /// Get theme data based on dark mode flag
  ThemeData getTheme(bool isDarkMode) => isDarkMode ? darkTheme : lightTheme;
}
