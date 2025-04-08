import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';
import 'theme_constants.dart';

/// Service for managing application themes
class ThemeService {
  static const String _themeKey = 'app_theme_mode';
  static const String _themeStyleKey = 'app_theme_style';
  static const String _themeLightValue = 'light';
  static const String _themeDarkValue = 'dark';

  /// Current theme mode
  ThemeMode _currentThemeMode = ThemeMode.system;

  /// Current theme style name
  String _currentThemeStyle = ThemeNames.cli;

  /// Get the current theme mode
  ThemeMode get currentThemeMode => _currentThemeMode;

  /// Get the current theme style name
  String get currentThemeStyle => _currentThemeStyle;

  /// Get the light theme data for the current style
  ThemeData get lightTheme => AppTheme.getLightTheme(style: _currentThemeStyle);

  /// Get the dark theme data for the current style
  ThemeData get darkTheme => AppTheme.getDarkTheme(style: _currentThemeStyle);

  /// Initialize the theme service by loading the saved theme preference
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(_themeKey);
    final savedThemeStyle = prefs.getString(_themeStyleKey) ?? ThemeNames.cli;

    _currentThemeStyle = savedThemeStyle;

    if (savedThemeMode == _themeLightValue) {
      _currentThemeMode = ThemeMode.light;
    } else if (savedThemeMode == _themeDarkValue) {
      _currentThemeMode = ThemeMode.dark;
    } else {
      _currentThemeMode = ThemeMode.system;
    }
  }

  /// Set the theme mode and save the preference
  Future<void> setThemeMode(ThemeMode mode) async {
    _currentThemeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.light) {
      await prefs.setString(_themeKey, _themeLightValue);
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(_themeKey, _themeDarkValue);
    } else {
      await prefs.remove(_themeKey);
    }
  }

  /// Set the theme style and save the preference
  Future<void> setThemeStyle(String styleName) async {
    if (themes[ThemeModes.light]?.containsKey(styleName) == true) {
      _currentThemeStyle = styleName;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeStyleKey, styleName);
    }
  }

  /// Toggle between light and dark theme modes
  Future<void> toggleThemeMode() async {
    if (_currentThemeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Returns a theme based on the provided style name and dark mode flag
  ThemeData getThemeByName(String name, bool isDarkMode) {
    return isDarkMode
        ? AppTheme.getDarkTheme(style: name)
        : AppTheme.getLightTheme(style: name);
  }

  /// Returns a list of available theme style names
  List<String> getAvailableThemeStyles() {
    return themes[ThemeModes.light]?.keys.toList() ?? [];
  }

  /// Returns the default theme based on the device's brightness
  ThemeData getDefaultTheme(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return getThemeByName(_currentThemeStyle, isDarkMode);
  }

  /// Toggles between light and dark version of a theme
  ThemeData toggleBrightness(ThemeData currentTheme, bool isDarkMode) {
    return isDarkMode
        ? AppTheme.getLightTheme(style: _currentThemeStyle)
        : AppTheme.getDarkTheme(style: _currentThemeStyle);
  }
}
