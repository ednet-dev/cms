import 'package:flutter/material.dart';

import '../theme_constants.dart' hide ThemeTextStyles;
import '../text_styles.dart';
import 'theme_component.dart';

/// Minimalistic theme component with clean, minimal design
class MinimalisticThemeComponent implements ThemeComponent {
  /// Create a new Minimalistic theme component
  MinimalisticThemeComponent();

  @override
  String get name => ThemeNames.minimalistic;

  @override
  ThemeData get lightTheme => _buildLightTheme();

  @override
  ThemeData get darkTheme => _buildDarkTheme();

  @override
  ThemeData getTheme(bool isDarkMode) => isDarkMode ? darkTheme : lightTheme;

  /// Build the dark minimalistic theme
  ThemeData _buildDarkTheme() {
    final textTheme = _buildMinimalisticTextTheme(ThemeColors.darkPrimary);

    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: ThemeColors.darkPrimary,
        secondary: ThemeColors.darkSecondary,
        surface: ThemeColors.darkSurface,
        onSurface: ThemeColors.darkOnSurface,
      ),
      scaffoldBackgroundColor: ThemeColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeColors.darkBackground,
        titleTextStyle: TextStyle(
          color: ThemeColors.darkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: ThemeColors.darkPrimary),
        actionsIconTheme: IconThemeData(color: ThemeColors.darkPrimary),
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.darkPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.darkSecondary),
        ),
        labelStyle: TextStyle(color: ThemeColors.darkPrimary),
      ),
    );
  }

  /// Build the light minimalistic theme
  ThemeData _buildLightTheme() {
    final textTheme = _buildMinimalisticTextTheme(ThemeColors.lightPrimary);

    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: ThemeColors.lightPrimary,
        secondary: ThemeColors.lightSecondary,
        background: ThemeColors.lightBackground,
        surface: ThemeColors.lightSurface,
        onBackground: ThemeColors.lightOnBackground,
        onSurface: ThemeColors.lightOnSurface,
      ),
      scaffoldBackgroundColor: ThemeColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeColors.lightBackground,
        titleTextStyle: TextStyle(
          color: ThemeColors.lightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: ThemeColors.lightPrimary),
        actionsIconTheme: IconThemeData(color: ThemeColors.lightPrimary),
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.lightPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.lightSecondary),
        ),
        labelStyle: TextStyle(color: ThemeColors.lightPrimary),
      ),
    );
  }

  /// Helper function to build minimalistic text theme
  TextTheme _buildMinimalisticTextTheme(Color color) {
    return TextTheme(
      displayLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 24),
      displayMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 22),
      displaySmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 20),
      headlineLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 24),
      headlineMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 22),
      headlineSmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 20),
      titleLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 20),
      titleMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 18),
      titleSmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 16),
      bodyLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 16),
      bodyMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 14),
      bodySmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 12),
      labelLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 14),
      labelMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 12),
      labelSmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 10),
    );
  }
}
