import 'package:flutter/material.dart';

import 'theme.dart';
import 'theme_constants.dart';

/// Service for managing themes in the application
///
/// This service centralizes theme-related operations such as selecting themes,
/// toggling between light and dark modes, and accessing theme-related data.
class ThemeService {
  /// Returns the default theme based on the device's brightness
  ThemeData getDefaultTheme(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return isDarkMode ? cliDarkTheme : cliLightTheme;
  }

  /// Returns a theme based on the provided name and mode
  ThemeData getThemeByName(String name, bool isDarkMode) {
    final mode = isDarkMode ? ThemeModes.dark : ThemeModes.light;
    return themes[mode]?[name] ?? (isDarkMode ? cliDarkTheme : cliLightTheme);
  }

  /// Returns a list of available theme names for the specified mode
  List<String> getAvailableThemeNames(bool isDarkMode) {
    final mode = isDarkMode ? ThemeModes.dark : ThemeModes.light;
    return themes[mode]?.keys.toList() ?? [];
  }

  /// Finds the name of a theme from its ThemeData
  String findThemeName(ThemeData themeData, bool isDarkMode) {
    final brightness = isDarkMode ? ThemeModes.dark : ThemeModes.light;
    final themeMap = themes[brightness]!;

    return themeMap.entries
        .firstWhere(
          (entry) => entry.value == themeData,
          orElse:
              () => MapEntry(
                ThemeNames.cli,
                isDarkMode ? cliDarkTheme : cliLightTheme,
              ),
        )
        .key;
  }

  /// Toggles between light and dark mode while preserving theme style
  ThemeData toggleBrightness(ThemeData currentTheme, bool currentIsDark) {
    // Find the current theme name
    final currentThemeName = findThemeName(currentTheme, currentIsDark);

    // Toggle to the opposite brightness
    final newIsDark = !currentIsDark;

    // Get the same theme style in the new brightness
    return getThemeByName(currentThemeName, newIsDark);
  }
}
