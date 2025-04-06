import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme_constants.dart' hide ThemeTextStyles;
import '../text_styles.dart';
import 'theme_component.dart';

/// Cheerful theme component with vibrant colors optimized for Material 3
/// with enhanced accessibility focus
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

  /// Build the dark cheerful theme with Material 3 design and accessibility focus
  ThemeData _buildDarkTheme() {
    final textTheme = _buildTextTheme(Colors.white);

    // Material 3 dark color scheme with cheerful accents - improved for contrast
    final colorScheme = ColorScheme.dark(
      // Primary amber with better contrast against dark backgrounds
      primary: Color(0xFFFFD54F),
      onPrimary: Color(0xFF000000), // Black for maximum contrast on primary
      primaryContainer: Color(
        0xFFBF9F00,
      ), // Darker amber for better distinction
      onPrimaryContainer: Color(0xFF000000), // Black for contrast
      // Secondary with improved contrast
      secondary: Color(0xFF4DD0E1), // Brighter cyan for better visibility
      onSecondary: Color(0xFF000000), // Black for maximum contrast
      secondaryContainer: Color(0xFF00838F), // Darker teal for container
      onSecondaryContainer: Color(0xFFFFFFFF), // White for contrast
      // Tertiary with better contrast
      tertiary: Color(0xFFFFAB91), // Deep orange accent
      onTertiary: Color(0xFF000000), // Black for contrast
      tertiaryContainer: Color(0xFFE64A19), // Deeper orange for container
      onTertiaryContainer: Color(0xFFFFFFFF), // White for contrast
      // Error with improved visibility
      error: Color(0xFFFF8A80), // Brighter red for better visibility
      onError: Color(0xFF000000), // Black for contrast
      // Surface colors with better distinction
      surface: Color(0xFF121212), // Dark surface
      onSurface: Color(0xFFFAFAFA), // Almost white for maximum contrast
      surfaceContainerHighest: Color(0xFF2D2D2D), // Higher contrast container
      onSurfaceVariant: Color(0xFFE0E0E0), // Light gray for variants
      // Better outline for focus and boundaries
      outline: Color(0xFFBDBDBD), // Lighter gray for better visibility
      outlineVariant: Color(0xFF9E9E9E), // Variant for borders

      surfaceTint: Color(0xFFFFD54F), // Surface tint consistent with primary
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // App bar theme with improved spacing and contrast
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false, // Left-aligned titles for better accessibility
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15, // Improved letter spacing
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.primary,
          size: 24, // Consistent icon sizing
        ),
        toolbarHeight: 64, // More comfortable toolbar height
        systemOverlayStyle:
            SystemUiOverlayStyle.light, // Light status bar icons
      ),

      // Text theme with improved readability and spacing
      textTheme: textTheme,

      // Card theme with improved spacing and borders
      cardTheme: CardTheme(
        elevation: 1, // Slight elevation for depth
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorScheme.surfaceContainerHighest,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        clipBehavior: Clip.antiAlias, // Clip for clean appearance
      ),

      // Input decoration with improved focus states and spacing
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 16, // Larger for better readability
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        isDense: false, // Not dense for better touch targets
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      // Elevated button with improved accessibility
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2, // Slight elevation for depth perception
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ), // Larger padding for touch
          minimumSize: Size(64, 48), // Minimum size for touch target
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined button with improved visibility
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ), // Thicker for visibility
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ), // Consistent with elevated
          minimumSize: Size(64, 48), // Consistent minimum size
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text button with improved touch target
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ), // Larger touch target
          minimumSize: Size(64, 40), // Minimum size for touch
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Floating action button with improved visibility
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 4, // More elevation for depth perception
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),

      // Checkbox with improved visibility and touch target
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(
          color: colorScheme.outline,
          width: 1.5,
        ), // Thicker border when unchecked
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        materialTapTargetSize:
            MaterialTapTargetSize.padded, // Larger tap target
      ),

      // Divider with better visibility
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(
          0.6,
        ), // More opaque for visibility
        thickness: 1,
        space: 24,
        indent: 8,
        endIndent: 8,
      ),

      // Switch with improved visibility and touch target
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colorScheme.outline;
        }),
        materialTapTargetSize:
            MaterialTapTargetSize.padded, // Larger tap target
      ),

      // Slider with improved visibility
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.3),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
        trackHeight: 4, // Thicker track for visibility
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 12,
        ), // Larger thumb for touch
      ),

      // Tooltip with better contrast
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: TextStyle(color: colorScheme.onInverseSurface, fontSize: 14),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Dialog theme with improved spacing
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
      ),
    );
  }

  /// Build the light cheerful theme with Material 3 design
  ThemeData _buildLightTheme() {
    final textTheme = _buildTextTheme(Colors.black);

    // Material 3 light color scheme with cheerful accents - improved for contrast
    final colorScheme = ColorScheme.light(
      // Primary blue with better contrast
      primary: Color(0xFF0D47A1), // Darker blue for better contrast
      onPrimary: Color(0xFFFFFFFF), // White for contrast
      primaryContainer: Color(0xFFBBDEFB), // Light blue container
      onPrimaryContainer: Color(0xFF0D47A1), // Dark text on light container
      // Secondary with good contrast
      secondary: Color(0xFF00796B), // Teal with better contrast ratio
      onSecondary: Color(0xFFFFFFFF), // White for contrast
      secondaryContainer: Color(0xFFB2DFDB), // Light teal container
      onSecondaryContainer: Color(0xFF004D40), // Dark text for contrast
      // Tertiary with accessible contrast
      tertiary: Color(0xFFC2185B), // Darker pink for better contrast
      onTertiary: Color(0xFFFFFFFF), // White for contrast
      tertiaryContainer: Color(0xFFF8BBD0), // Light pink container
      onTertiaryContainer: Color(0xFF880E4F), // Dark text for contrast
      // Error with good contrast
      error: Color(0xFFC62828), // Dark red for contrast with white
      onError: Color(0xFFFFFFFF), // White text
      // Surface colors with better distinction
      surface: Color(0xFFFAFAFA), // Very light surface
      onSurface: Color(0xFF212121), // Dark text for contrast
      surfaceContainerHighest: Color(0xFFEEEEEE), // Light container
      onSurfaceVariant: Color(
        0xFF555555,
      ), // Darker variant for better readability
      // Better outline colors
      outline: Color(0xFF757575), // Mid-gray for outlines
      outlineVariant: Color(0xFFBDBDBD), // Lighter variant for subtle borders

      surfaceTint: Color(0xFF0D47A1), // Surface tint matching primary
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // App bar theme with improved spacing and contrast
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false, // Left-aligned titles for better accessibility
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15, // Improved letter spacing
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.primary,
          size: 24, // Consistent icon sizing
        ),
        toolbarHeight: 64, // More comfortable toolbar height
        systemOverlayStyle: SystemUiOverlayStyle.dark, // Dark status bar icons
      ),

      // Text theme with improved readability
      textTheme: textTheme,

      // Card theme with improved spacing and borders
      cardTheme: CardTheme(
        elevation: 1, // Slight elevation for depth
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorScheme.surface,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shadowColor: colorScheme.shadow.withOpacity(0.3),
        clipBehavior: Clip.antiAlias, // Clip for clean appearance
      ),

      // Input decoration with improved focus states and spacing
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 16, // Larger for better readability
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        isDense: false, // Not dense for better touch targets
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      // Elevated button with improved accessibility
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2, // Slight elevation for depth perception
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ), // Larger padding for touch
          minimumSize: Size(64, 48), // Minimum size for touch target
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined button with improved visibility
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ), // Thicker for visibility
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ), // Consistent with elevated
          minimumSize: Size(64, 48), // Consistent minimum size
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text button with improved touch target
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ), // Larger touch target
          minimumSize: Size(64, 40), // Minimum size for touch
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Floating action button with improved visibility
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4, // More elevation for depth perception
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),

      // Checkbox with improved visibility and touch target
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(
          color: colorScheme.outline,
          width: 1.5,
        ), // Thicker border when unchecked
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        materialTapTargetSize:
            MaterialTapTargetSize.padded, // Larger tap target
      ),

      // Divider with better visibility
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.3),
        thickness: 1,
        space: 24,
        indent: 8,
        endIndent: 8,
      ),

      // Switch with improved visibility and touch target
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colorScheme.outline;
        }),
        materialTapTargetSize:
            MaterialTapTargetSize.padded, // Larger tap target
      ),

      // Slider with improved visibility
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.3),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
        trackHeight: 4, // Thicker track for visibility
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 12,
        ), // Larger thumb for touch
      ),

      // Tooltip with better contrast
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: TextStyle(color: colorScheme.onInverseSurface, fontSize: 14),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Dialog theme with improved spacing
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
      ),
    );
  }

  /// Helper function to build standard text theme with improved accessibility
  TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: ThemeTextStyles.buildStandardTextStyle(
        color,
        30, // Larger for better readability
        fontWeight: FontWeight.w700, // Bolder for emphasis
      ),
      displayMedium: ThemeTextStyles.buildStandardTextStyle(
        color,
        26,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: ThemeTextStyles.buildStandardTextStyle(
        color,
        22,
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
      bodyLarge: ThemeTextStyles.buildStandardTextStyle(
        color,
        16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: ThemeTextStyles.buildStandardTextStyle(
        color,
        14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: ThemeTextStyles.buildStandardTextStyle(
        color,
        12,
        fontWeight: FontWeight.w400,
      ),
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
        11, // Slightly larger than original 10 for readability
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
