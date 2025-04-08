import 'package:flutter/material.dart';

import '../theme_constants.dart' hide ThemeTextStyles;
import '../text_styles.dart';
import 'theme_component.dart';

/// CLI theme component with terminal-like appearance optimized for Material 3
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

  /// Build the dark CLI theme with Material 3 design
  ThemeData _buildDarkTheme() {
    final textTheme = _buildCliTextTheme(ThemeColors.darkPrimary);

    // Use consistent surface colors instead of background (deprecated)
    final surfaceColor = ThemeColors.darkBackground;

    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: ThemeColors.darkPrimary,
        secondary: ThemeColors.darkSecondary,
        surface: ThemeColors.darkSurface,
        onSurface: ThemeColors.darkOnSurface,
        // Use additional surface colors instead of background
        surfaceContainerHighest: surfaceColor,
        // No need for background/onBackground properties (deprecated)
        error: ThemeColors.darkError,
        onError: ThemeColors.darkOnError,
      ),
      scaffoldBackgroundColor: surfaceColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        titleTextStyle: TextStyle(
          color: ThemeColors.darkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
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
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.darkPrimary,
          foregroundColor: surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeColors.darkPrimary,
          side: BorderSide(color: ThemeColors.darkPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeColors.darkPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          textStyle: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // buttonTheme is legacy, but keep it for backward compatibility
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeColors.darkPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      iconTheme: IconThemeData(color: ThemeColors.darkPrimary),
      dividerTheme: DividerThemeData(
        color: ThemeColors.darkPrimary.withValues(alpha: 77),
        thickness: 1,
        space: 16,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.darkPrimary;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(surfaceColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.darkPrimary;
          }
          return ThemeColors.darkOnSurface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.darkPrimary.withValues(alpha: 128);
          }
          return ThemeColors.darkOnSurface.withValues(alpha: 77);
        }),
      ),
      visualDensity: VisualDensity.compact,
      useMaterial3: true,
    );
  }

  /// Build the light CLI theme with Material 3 design
  ThemeData _buildLightTheme() {
    final textTheme = _buildCliTextTheme(ThemeColors.lightPrimary);

    // Use consistent surface colors instead of background (deprecated)
    final surfaceColor = ThemeColors.lightBackground;

    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: ThemeColors.lightPrimary,
        secondary: ThemeColors.lightSecondary,
        surface: ThemeColors.lightSurface,
        onSurface: ThemeColors.lightOnSurface,
        // Use additional surface colors instead of background
        surfaceContainerHighest: surfaceColor,
        // No need for background/onBackground properties (deprecated)
        error: ThemeColors.lightError,
        onError: ThemeColors.lightOnError,
      ),
      scaffoldBackgroundColor: surfaceColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        titleTextStyle: TextStyle(
          color: ThemeColors.lightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
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
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.lightPrimary,
          foregroundColor: surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeColors.lightPrimary,
          side: BorderSide(color: ThemeColors.lightPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeColors.lightPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          textStyle: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // buttonTheme is legacy, but keep it for backward compatibility
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeColors.lightPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      iconTheme: IconThemeData(color: ThemeColors.lightPrimary),
      dividerTheme: DividerThemeData(
        color: ThemeColors.lightPrimary.withValues(alpha: 77),
        thickness: 1,
        space: 16,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.lightPrimary;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(surfaceColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.lightPrimary;
          }
          return ThemeColors.lightOnSurface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.lightPrimary.withValues(alpha: 128);
          }
          return ThemeColors.lightOnSurface.withValues(alpha: 77);
        }),
      ),
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
