import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

/// Provider for theme-related functionality
class ThemeProvider extends ChangeNotifier {
  /// The current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  /// Get the current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Light theme data
  ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  /// Dark theme data
  ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  /// Set the theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  /// Get color for a concept
  Color conceptColor(String conceptType) {
    final colorScheme =
        _themeMode == ThemeMode.dark
            ? darkTheme.colorScheme
            : lightTheme.colorScheme;

    switch (conceptType) {
      case 'Entity':
        return colorScheme.primary;
      case 'ValueObject':
        return colorScheme.secondary;
      case 'Aggregate':
        return colorScheme.tertiary;
      case 'Service':
        return colorScheme.primaryContainer;
      case 'Repository':
        return colorScheme.secondaryContainer;
      case 'Factory':
        return colorScheme.tertiaryContainer;
      case 'Domain':
        return colorScheme.surface;
      case 'Model':
        return colorScheme.surface;
      case 'Concept':
        return colorScheme.inverseSurface;
      case 'MappedValue':
        return colorScheme.secondary;
      case 'Toolbar':
        return colorScheme.primary.withOpacity(0.8);
      case 'Social':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  /// Get text style for a concept with optional role
  TextStyle conceptTextStyle(String conceptType, {String? role}) {
    final color = conceptColor(conceptType);

    // Base style
    var style = TextStyle(
      color: _themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
    );

    // Apply concept-specific styling
    switch (conceptType) {
      case 'Entity':
        style = style.copyWith(fontWeight: FontWeight.bold);
        break;
      case 'ValueObject':
        style = style.copyWith(fontStyle: FontStyle.italic);
        break;
      // Add more specific styling as needed
    }

    // Apply role-specific styling
    if (role != null) {
      switch (role) {
        case 'title':
          style = style.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          );
          break;
        case 'subtitle':
          style = style.copyWith(fontSize: 16, fontWeight: FontWeight.w500);
          break;
        case 'description':
          style = style.copyWith(
            fontSize: 14,
            color:
                _themeMode == ThemeMode.dark ? Colors.white70 : Colors.black54,
          );
          break;
      }
    }

    return style;
  }
}
