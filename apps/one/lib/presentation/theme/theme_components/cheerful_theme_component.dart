import 'package:flutter/material.dart';

import '../theme_constants.dart' hide ThemeTextStyles;
import '../text_styles.dart';
import 'theme_component.dart';

/// Cheerful theme component with vibrant colors optimized for Material 3
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

  /// Build the dark cheerful theme with Material 3 design
  ThemeData _buildDarkTheme() {
    final textTheme = _buildTextTheme(Colors.white);

    // Material 3 dark color scheme with cheerful accents
    final colorScheme = ColorScheme.dark(
      primary: Color(0xFFFFD54F), // Amber accent
      onPrimary: Colors.black,
      primaryContainer: Color(0xFFFFB300),
      onPrimaryContainer: Colors.black,
      secondary: Color(0xFF80DEEA), // Cyan accent
      onSecondary: Colors.black,
      secondaryContainer: Color(0xFF00ACC1),
      onSecondaryContainer: Colors.white,
      tertiary: Color(0xFFFFAB91), // Deep orange accent
      onTertiary: Colors.black,
      tertiaryContainer: Color(0xFFFF8A65),
      onTertiaryContainer: Colors.black,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      surface: Color(0xFF121212),
      onSurface: Colors.white,
      surfaceContainerHighest: Color(0xFF2D2D2D),
      onSurfaceVariant: Color(0xFFE0E0E0),
      outline: Color(0xFF9E9E9E),
      surfaceTint: Color(0xFFFFD54F),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),

      // Text theme
      textTheme: textTheme,

      // Card theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surfaceContainerHighest,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 77),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 51),
        thickness: 1,
        space: 24,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
    );
  }

  /// Build the light cheerful theme with Material 3 design
  ThemeData _buildLightTheme() {
    final textTheme = _buildTextTheme(Colors.black);

    // Material 3 light color scheme with cheerful accents
    final colorScheme = ColorScheme.light(
      primary: Color(0xFF1E88E5), // Blue
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFBBDEFB),
      onPrimaryContainer: Color(0xFF0D47A1),
      secondary: Color(0xFF26A69A), // Teal
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFB2DFDB),
      onSecondaryContainer: Color(0xFF004D40),
      tertiary: Color(0xFFF06292), // Pink
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFF8BBD0),
      onTertiaryContainer: Color(0xFF880E4F),
      error: Color(0xFFB00020),
      onError: Colors.white,
      surface: Color(0xFFFAFAFA),
      onSurface: Color(0xFF212121),
      surfaceContainerHighest: Color(0xFFEEEEEE),
      onSurfaceVariant: Color(0xFF757575),
      outline: Color(0xFF9E9E9E),
      surfaceTint: Color(0xFF1E88E5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),

      // Text theme
      textTheme: textTheme,

      // Card theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surface,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shadowColor: colorScheme.shadow.withValues(alpha: 26),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 128),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 51),
        thickness: 1,
        space: 24,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
    );
  }

  /// Helper function to build standard text theme
  TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: ThemeTextStyles.buildStandardTextStyle(
        color,
        24,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: ThemeTextStyles.buildStandardTextStyle(
        color,
        22,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: ThemeTextStyles.buildStandardTextStyle(
        color,
        20,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: ThemeTextStyles.buildStandardTextStyle(
        color,
        24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: ThemeTextStyles.buildStandardTextStyle(
        color,
        22,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: ThemeTextStyles.buildStandardTextStyle(
        color,
        20,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: ThemeTextStyles.buildStandardTextStyle(
        color,
        20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: ThemeTextStyles.buildStandardTextStyle(
        color,
        18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: ThemeTextStyles.buildStandardTextStyle(
        color,
        16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: ThemeTextStyles.buildStandardTextStyle(color, 16),
      bodyMedium: ThemeTextStyles.buildStandardTextStyle(color, 14),
      bodySmall: ThemeTextStyles.buildStandardTextStyle(color, 12),
      labelLarge: ThemeTextStyles.buildStandardTextStyle(
        color,
        14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: ThemeTextStyles.buildStandardTextStyle(
        color,
        12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: ThemeTextStyles.buildStandardTextStyle(
        color,
        10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
