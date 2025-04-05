import 'package:flutter/material.dart';

import '../theme_constants.dart' hide ThemeTextStyles;
import '../text_styles.dart';
import 'theme_component.dart';

/// CLI theme component with terminal-like appearance
class CliThemeComponent implements ThemeComponent {
  /// Create a new CLI theme component
  CliThemeComponent();

  @override
  String get name => ThemeNames.cli;

  @override
  ThemeData get lightTheme => _buildLightTheme();

  @override
  ThemeData get darkTheme => _buildDarkTheme();

  @override
  ThemeData getTheme(bool isDarkMode) => isDarkMode ? darkTheme : lightTheme;

  /// Build the dark CLI theme
  ThemeData _buildDarkTheme() {
    final textTheme = _buildCliTextTheme(ThemeColors.darkPrimary);

    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: ThemeColors.darkPrimary,
        secondary: ThemeColors.darkSecondary,
        surface: ThemeColors.darkSurface,
        onSurface: ThemeColors.darkOnSurface,
        background: ThemeColors.darkBackground,
        onBackground: ThemeColors.darkOnBackground,
        error: ThemeColors.darkError,
        onError: ThemeColors.darkOnError,
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
        elevation: 0,
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        labelStyle: TextStyle(color: ThemeColors.darkPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.darkPrimary,
          foregroundColor: ThemeColors.darkBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeColors.darkPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      iconTheme: IconThemeData(color: ThemeColors.darkPrimary),
      visualDensity: VisualDensity.compact,
      useMaterial3: true,
    );
  }

  /// Build the light CLI theme
  ThemeData _buildLightTheme() {
    final textTheme = _buildCliTextTheme(ThemeColors.lightPrimary);

    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: ThemeColors.lightPrimary,
        secondary: ThemeColors.lightSecondary,
        surface: ThemeColors.lightSurface,
        onSurface: ThemeColors.lightOnSurface,
        background: ThemeColors.lightBackground,
        onBackground: ThemeColors.lightOnBackground,
        error: ThemeColors.lightError,
        onError: ThemeColors.lightOnError,
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
        elevation: 0,
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        labelStyle: TextStyle(color: ThemeColors.lightPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.lightPrimary,
          foregroundColor: ThemeColors.lightBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeColors.lightPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      iconTheme: IconThemeData(color: ThemeColors.lightPrimary),
      visualDensity: VisualDensity.compact,
      useMaterial3: true,
    );
  }

  /// Helper function to build CLI text theme
  TextTheme _buildCliTextTheme(Color color) {
    return TextTheme(
      displayLarge: ThemeTextStyles.buildCliTextStyle(
        color,
        24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: ThemeTextStyles.buildCliTextStyle(
        color,
        22,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: ThemeTextStyles.buildCliTextStyle(
        color,
        20,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: ThemeTextStyles.buildCliTextStyle(
        color,
        24,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: ThemeTextStyles.buildCliTextStyle(
        color,
        22,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: ThemeTextStyles.buildCliTextStyle(
        color,
        20,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: ThemeTextStyles.buildCliTextStyle(
        color,
        20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: ThemeTextStyles.buildCliTextStyle(
        color,
        18,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: ThemeTextStyles.buildCliTextStyle(
        color,
        16,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: ThemeTextStyles.buildCliTextStyle(color, 16),
      bodyMedium: ThemeTextStyles.buildCliTextStyle(color, 14),
      bodySmall: ThemeTextStyles.buildCliTextStyle(color, 12),
      labelLarge: ThemeTextStyles.buildCliTextStyle(color, 14),
      labelMedium: ThemeTextStyles.buildCliTextStyle(color, 12),
      labelSmall: ThemeTextStyles.buildCliTextStyle(color, 10),
    );
  }
}
