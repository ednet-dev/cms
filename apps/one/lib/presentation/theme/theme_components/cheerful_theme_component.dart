import 'package:flutter/material.dart';

import '../theme_constants.dart' hide ThemeTextStyles;
import '../text_styles.dart';
import 'theme_component.dart';

/// Cheerful theme component with vibrant colors
class CheerfulThemeComponent implements ThemeComponent {
  /// Create a new Cheerful theme component
  CheerfulThemeComponent();

  @override
  String get name => ThemeNames.cheerful;

  @override
  ThemeData get lightTheme => _buildLightTheme();

  @override
  ThemeData get darkTheme => _buildDarkTheme();

  @override
  ThemeData getTheme(bool isDarkMode) => isDarkMode ? darkTheme : lightTheme;

  /// Build the dark cheerful theme
  ThemeData _buildDarkTheme() {
    final textTheme = _buildTextTheme(Colors.white);

    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.yellow,
        accentColor: ThemeColors.cheerfulDarkAccent,
        brightness: Brightness.dark,
        backgroundColor: ThemeColors.cheerfulDarkBackground,
      ).copyWith(surface: ThemeColors.cheerfulDarkBackground),
      scaffoldBackgroundColor: ThemeColors.cheerfulDarkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.yellow[700],
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        actionsIconTheme: IconThemeData(color: Colors.black87),
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.cheerfulDarkAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]!),
        ),
        labelStyle: TextStyle(color: ThemeColors.cheerfulDarkAccent),
      ),
    );
  }

  /// Build the light cheerful theme
  ThemeData _buildLightTheme() {
    final textTheme = _buildTextTheme(Colors.black);

    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: ThemeColors.cheerfulLightAccent,
        brightness: Brightness.light,
        backgroundColor: ThemeColors.lightBackground,
      ).copyWith(surface: ThemeColors.lightSurface),
      scaffoldBackgroundColor: ThemeColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[700],
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[700]!),
        ),
        labelStyle: TextStyle(color: Colors.blue),
      ),
    );
  }

  /// Helper function to build standard text theme
  TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: ThemeTextStyles.buildStandardTextStyle(color, 24),
      displayMedium: ThemeTextStyles.buildStandardTextStyle(color, 22),
      displaySmall: ThemeTextStyles.buildStandardTextStyle(color, 20),
      headlineLarge: ThemeTextStyles.buildStandardTextStyle(color, 24),
      headlineMedium: ThemeTextStyles.buildStandardTextStyle(color, 22),
      headlineSmall: ThemeTextStyles.buildStandardTextStyle(color, 20),
      titleLarge: ThemeTextStyles.buildStandardTextStyle(color, 20),
      titleMedium: ThemeTextStyles.buildStandardTextStyle(color, 18),
      titleSmall: ThemeTextStyles.buildStandardTextStyle(color, 16),
      bodyLarge: ThemeTextStyles.buildStandardTextStyle(color, 16),
      bodyMedium: ThemeTextStyles.buildStandardTextStyle(color, 14),
      bodySmall: ThemeTextStyles.buildStandardTextStyle(color, 12),
      labelLarge: ThemeTextStyles.buildStandardTextStyle(color, 14),
      labelMedium: ThemeTextStyles.buildStandardTextStyle(color, 12),
      labelSmall: ThemeTextStyles.buildStandardTextStyle(color, 10),
    );
  }
}
