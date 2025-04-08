import 'package:flutter/material.dart';

import '../theme_constants.dart' hide ThemeTextStyles;
import '../text_styles.dart';
import 'theme_component.dart';

/// Minimalistic theme component with clean, minimal design optimized for Material 3
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

  /// Build the dark minimalistic theme with Material 3 design
  ThemeData _buildDarkTheme() {
    final textTheme = _buildMinimalisticTextTheme(ThemeColors.darkPrimary);

    // Create a subtle dark color palette
    final colorScheme = ColorScheme.dark(
      primary: ThemeColors.darkPrimary,
      secondary: ThemeColors.darkSecondary,
      tertiary: ThemeColors.darkPrimary.withValues(alpha: 179),
      surface: ThemeColors.darkSurface,
      onSurface: ThemeColors.darkOnSurface,
      surfaceContainerHighest: ThemeColors.darkBackground,
      error: ThemeColors.darkError,
      onError: Colors.white,
      outline: ThemeColors.darkPrimary.withValues(alpha: 102),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ThemeColors.darkBackground,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ThemeColors.darkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        iconTheme: IconThemeData(color: ThemeColors.darkPrimary),
        actionsIconTheme: IconThemeData(color: ThemeColors.darkPrimary),
      ),

      // Text theme
      textTheme: textTheme,

      // Card theme - extremely minimal
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outline, width: 0.5),
        ),
        color: ThemeColors.darkBackground,
        margin: EdgeInsets.zero,
      ),

      // Input decoration - clean lines
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ThemeColors.darkPrimary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ThemeColors.darkPrimary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ThemeColors.darkSecondary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: ThemeColors.darkPrimary),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated button - subtle elevation
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ThemeColors.darkPrimary,
          foregroundColor: ThemeColors.darkBackground,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Outlined button - thin border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeColors.darkPrimary,
          side: BorderSide(color: ThemeColors.darkPrimary, width: 1),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Text button - clean
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeColors.darkPrimary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(color: ThemeColors.darkPrimary, size: 24),

      // Divider theme - subtle
      dividerTheme: DividerThemeData(
        color: ThemeColors.darkPrimary.withValues(alpha: 51),
        thickness: 0.5,
        space: 32,
      ),

      // Checkbox theme - minimal
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.darkPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(ThemeColors.darkBackground),
        side: BorderSide(color: ThemeColors.darkPrimary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Switch theme - elegant
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.darkPrimary;
          }
          return Colors.grey[400];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.darkPrimary.withValues(alpha: 77);
          }
          return Colors.grey[800];
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Slider theme - thin
      sliderTheme: SliderThemeData(
        activeTrackColor: ThemeColors.darkPrimary,
        inactiveTrackColor: ThemeColors.darkPrimary.withValues(alpha: 51),
        thumbColor: ThemeColors.darkPrimary,
        trackHeight: 2,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      ),

      // Bottom navigation - discreet
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ThemeColors.darkBackground,
        selectedItemColor: ThemeColors.darkPrimary,
        unselectedItemColor: ThemeColors.darkPrimary.withValues(alpha: 153),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      visualDensity: VisualDensity.standard,
    );
  }

  /// Build the light minimalistic theme with Material 3 design
  ThemeData _buildLightTheme() {
    final textTheme = _buildMinimalisticTextTheme(ThemeColors.lightPrimary);

    // Create a subtle light color palette
    final colorScheme = ColorScheme.light(
      primary: ThemeColors.lightPrimary,
      secondary: ThemeColors.lightSecondary,
      tertiary: ThemeColors.lightPrimary.withValues(alpha: 179),
      surface: ThemeColors.lightSurface,
      onSurface: ThemeColors.lightOnSurface,
      surfaceContainerHighest: ThemeColors.lightBackground,
      error: ThemeColors.lightError,
      onError: Colors.white,
      outline: ThemeColors.lightPrimary.withValues(alpha: 102),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ThemeColors.lightBackground,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ThemeColors.lightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        iconTheme: IconThemeData(color: ThemeColors.lightPrimary),
        actionsIconTheme: IconThemeData(color: ThemeColors.lightPrimary),
      ),

      // Text theme
      textTheme: textTheme,

      // Card theme - extremely minimal
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outline, width: 0.5),
        ),
        color: ThemeColors.lightBackground,
        margin: EdgeInsets.zero,
      ),

      // Input decoration - clean lines
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ThemeColors.lightPrimary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ThemeColors.lightPrimary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ThemeColors.lightSecondary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: ThemeColors.lightPrimary),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated button - subtle elevation
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ThemeColors.lightPrimary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Outlined button - thin border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeColors.lightPrimary,
          side: BorderSide(color: ThemeColors.lightPrimary, width: 1),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Text button - clean
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeColors.lightPrimary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(color: ThemeColors.lightPrimary, size: 24),

      // Divider theme - subtle
      dividerTheme: DividerThemeData(
        color: ThemeColors.lightPrimary.withValues(alpha: 51),
        thickness: 0.5,
        space: 32,
      ),

      // Checkbox theme - minimal
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.lightPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: ThemeColors.lightPrimary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Switch theme - elegant
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.lightPrimary;
          }
          return Colors.grey[400];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeColors.lightPrimary.withValues(alpha: 77);
          }
          return Colors.grey[300];
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Slider theme - thin
      sliderTheme: SliderThemeData(
        activeTrackColor: ThemeColors.lightPrimary,
        inactiveTrackColor: ThemeColors.lightPrimary.withValues(alpha: 51),
        thumbColor: ThemeColors.lightPrimary,
        trackHeight: 2,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      ),

      // Bottom navigation - discreet
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ThemeColors.lightBackground,
        selectedItemColor: ThemeColors.lightPrimary,
        unselectedItemColor: ThemeColors.lightPrimary.withValues(alpha: 153),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      visualDensity: VisualDensity.standard,
    );
  }

  /// Helper function to build minimalistic text theme
  TextTheme _buildMinimalisticTextTheme(Color color) {
    return TextTheme(
      displayLarge: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        24,
        fontWeight: FontWeight.w300,
      ),
      displayMedium: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        22,
        fontWeight: FontWeight.w300,
      ),
      displaySmall: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        20,
        fontWeight: FontWeight.w300,
      ),
      headlineLarge: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        24,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        22,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        20,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        20,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        18,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 16),
      bodyMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 14),
      bodySmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 12),
      labelLarge: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: ThemeTextStyles.buildMinimalisticTextStyle(
        color,
        10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
