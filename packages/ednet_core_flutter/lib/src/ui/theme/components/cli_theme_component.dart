part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// CLI theme component with terminal-like appearance optimized for Material 3
/// with enhanced accessibility focus, integrated with disclosure levels
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

  @override
  ColorScheme getColorScheme(bool isDarkMode) =>
      getTheme(isDarkMode).colorScheme;

  @override
  TextStyle getSemanticTextStyle(
    BuildContext context,
    String conceptType,
    DisclosureLevel level, {
    bool isDarkMode = false,
  }) {
    final color = getSemanticColor(conceptType, isDarkMode);

    // Adjust style based on disclosure level
    switch (level) {
      case DisclosureLevel.minimal:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          12,
          fontWeight: FontWeight.w400,
        );
      case DisclosureLevel.basic:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          14,
          fontWeight: FontWeight.w400,
        );
      case DisclosureLevel.standard:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          16,
          fontWeight: FontWeight.w500,
        );
      case DisclosureLevel.intermediate:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          16,
          fontWeight: FontWeight.w500,
        );
      case DisclosureLevel.advanced:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          16,
          fontWeight: FontWeight.w600,
        );
      case DisclosureLevel.detailed:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          18,
          fontWeight: FontWeight.w600,
        );
      case DisclosureLevel.complete:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          18,
          fontWeight: FontWeight.w700,
        );
      case DisclosureLevel.debug:
        return ThemeTextStyles.buildCliTextStyle(
          color,
          16,
          fontWeight: FontWeight.w500,
        ).copyWith(
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
        );
    }
  }

  /// Build the dark CLI theme with Material 3 design
  ThemeData _buildDarkTheme() {
    final textTheme = _buildCliTextTheme(ThemeColors.darkPrimary);

    // Use consistent surface colors instead of background (deprecated)
    const surfaceColor = ThemeColors.darkBackground;

    const colorScheme = ColorScheme.dark(
      primary: ThemeColors.darkPrimary,
      secondary: ThemeColors.darkSecondary,
      surface: ThemeColors.darkSurface,
      onSurface: ThemeColors.darkOnSurface,
      // Use additional surface colors instead of background
      surfaceContainerHighest: surfaceColor,
      // No need for background/onBackground properties (deprecated)
      error: ThemeColors.darkError,
      onError: ThemeColors.darkOnError,
    );

    return _buildCliTheme(
        colorScheme, textTheme, surfaceColor, Brightness.dark);
  }

  /// Build the light CLI theme with Material 3 design
  ThemeData _buildLightTheme() {
    final textTheme = _buildCliTextTheme(ThemeColors.lightPrimary);

    // Use consistent surface colors instead of background (deprecated)
    const surfaceColor = ThemeColors.lightBackground;

    const colorScheme = ColorScheme.light(
      primary: ThemeColors.lightPrimary,
      secondary: ThemeColors.lightSecondary,
      surface: ThemeColors.lightSurface,
      onSurface: ThemeColors.lightOnSurface,
      // Use additional surface colors instead of background
      surfaceContainerHighest: surfaceColor,
      // No need for background/onBackground properties (deprecated)
      error: ThemeColors.lightError,
      onError: ThemeColors.lightOnError,
    );

    return _buildCliTheme(
        colorScheme, textTheme, surfaceColor, Brightness.light);
  }

  /// Common method to build CLI theme with given parameters
  ThemeData _buildCliTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    Color surfaceColor,
    Brightness brightness,
  ) {
    // Select status bar style based on theme brightness
    final statusBarStyle = brightness == Brightness.light
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: colorScheme.surface,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: colorScheme.surface,
            systemNavigationBarIconBrightness: Brightness.light,
          );

    // Create disclosure level color maps
    final primaryColors = <DisclosureLevel, Color>{
      DisclosureLevel.minimal:
          colorScheme.primary.withValues(alpha: 204), // 0.8
      DisclosureLevel.basic: colorScheme.primary.withValues(alpha: 217), // 0.85
      DisclosureLevel.standard:
          colorScheme.primary.withValues(alpha: 230), // 0.9
      DisclosureLevel.intermediate:
          colorScheme.primary.withValues(alpha: 242), // 0.95
      DisclosureLevel.advanced: colorScheme.primary,
      DisclosureLevel.detailed:
          colorScheme.primary.withRed(colorScheme.primary.r.toInt() + 10),
      DisclosureLevel.complete:
          colorScheme.primary.withBlue(colorScheme.primary.b.toInt() + 10),
      DisclosureLevel.debug: colorScheme.error,
    };

    final secondaryColors = <DisclosureLevel, Color>{
      DisclosureLevel.minimal: colorScheme.secondary.withValues(alpha: 204),
      DisclosureLevel.basic: colorScheme.secondary.withValues(alpha: 217),
      DisclosureLevel.standard: colorScheme.secondary.withValues(alpha: 230),
      DisclosureLevel.intermediate:
          colorScheme.secondary.withValues(alpha: 242),
      DisclosureLevel.advanced: colorScheme.secondary,
      DisclosureLevel.detailed: colorScheme.secondary,
      DisclosureLevel.complete: colorScheme.secondary,
      DisclosureLevel.debug: colorScheme.error,
    };

    // ColorScheme.tertiary is available in Material 3
    final tertiaryColors = <DisclosureLevel, Color>{
      DisclosureLevel.minimal: colorScheme.primary.withValues(alpha: 204),
      DisclosureLevel.basic: colorScheme.primary.withValues(alpha: 217),
      DisclosureLevel.standard: colorScheme.primary,
      DisclosureLevel.intermediate: colorScheme.primary,
      DisclosureLevel.advanced: colorScheme.primary,
      DisclosureLevel.detailed: colorScheme.primary,
      DisclosureLevel.complete: colorScheme.primary,
      DisclosureLevel.debug: colorScheme.error,
    };

    // Create text styles for disclosure levels
    final textStyles = <DisclosureLevel, TextStyle>{
      DisclosureLevel.minimal: const TextStyle(
        fontSize: 12,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
      ),
      DisclosureLevel.basic: const TextStyle(
        fontSize: 14,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
      ),
      DisclosureLevel.standard: const TextStyle(
        fontSize: 16,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
      ),
      DisclosureLevel.intermediate: const TextStyle(
        fontSize: 16,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
        fontWeight: FontWeight.w500,
      ),
      DisclosureLevel.advanced: const TextStyle(
        fontSize: 16,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
        fontWeight: FontWeight.w600,
      ),
      DisclosureLevel.detailed: const TextStyle(
        fontSize: 18,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
        fontWeight: FontWeight.w600,
      ),
      DisclosureLevel.complete: const TextStyle(
        fontSize: 18,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
        fontWeight: FontWeight.w700,
      ),
      DisclosureLevel.debug: const TextStyle(
        fontSize: 16,
        fontFamily: 'monospace',
        letterSpacing: 0.2,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
      ),
    };

    // Create scaling factors for disclosure levels
    final scalingFactors = <DisclosureLevel, double>{
      DisclosureLevel.minimal: 0.8,
      DisclosureLevel.basic: 0.9,
      DisclosureLevel.standard: 1.0,
      DisclosureLevel.intermediate: 1.0,
      DisclosureLevel.advanced: 1.0,
      DisclosureLevel.detailed: 1.1,
      DisclosureLevel.complete: 1.2,
      DisclosureLevel.debug: 1.2,
    };

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaceColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        titleTextStyle: TextStyle(
          color: colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
        actionsIconTheme: IconThemeData(color: colorScheme.primary),
        elevation: 0,
        systemOverlayStyle: statusBarStyle,
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        labelStyle: TextStyle(color: colorScheme.primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: surfaceColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // buttonTheme is legacy, but keep it for backward compatibility
      buttonTheme: ButtonThemeData(
        buttonColor: colorScheme.primary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      iconTheme: IconThemeData(color: colorScheme.primary),
      dividerTheme: DividerThemeData(
        color: colorScheme.primary.withValues(alpha: 77),
        thickness: 1,
        space: 16,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(surfaceColor),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 128);
          }
          return colorScheme.onSurface.withValues(alpha: 77);
        }),
      ),
      visualDensity: VisualDensity.compact,
      useMaterial3: true,
      extensions: [
        DisclosureLevelThemeExtension(
          primaryColors: primaryColors,
          secondaryColors: secondaryColors,
          tertiaryColors: tertiaryColors,
          textStyles: textStyles,
          scalingFactors: scalingFactors,
        ),
        SemanticColorsExtension(
          entity: SemanticColors.entity,
          concept: SemanticColors.concept,
          attribute: SemanticColors.attribute,
          relationship: SemanticColors.relationship,
          model: SemanticColors.model,
          domain: SemanticColors.domain,
          brightness: brightness,
        ),
      ],
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

  @override
  ThemeData getThemeForDisclosureLevel(bool isDarkMode, DisclosureLevel level) {
    final baseTheme = getTheme(isDarkMode);

    // Get the extension from the theme
    final levelExtension = baseTheme.extension<DisclosureLevelThemeExtension>();

    if (levelExtension == null) {
      return baseTheme;
    }

    // Apply disclosure level-specific styling
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        // For CLI theme, we adjust primary color intensity based on disclosure level
        primary: levelExtension.getPrimaryColorForLevel(level),
      ),
      // Adjust visual density based on disclosure level
      visualDensity: level.toVisualDensity(),
    );
  }

  @override
  Color getSemanticColor(String conceptType, bool isDarkMode) {
    final theme = getTheme(isDarkMode);
    final semanticColors = theme.extension<SemanticColorsExtension>();

    if (semanticColors == null) {
      return _getDefaultSemanticColor(conceptType, isDarkMode);
    }

    // For CLI theme, we use monochromatic variations of semantic colors
    Color baseColor;

    switch (conceptType.toLowerCase()) {
      case 'entity':
        baseColor = semanticColors.entity;
        break;
      case 'concept':
        baseColor = semanticColors.concept;
        break;
      case 'attribute':
        baseColor = semanticColors.attribute;
        break;
      case 'relationship':
        baseColor = semanticColors.relationship;
        break;
      case 'model':
        baseColor = semanticColors.model;
        break;
      case 'domain':
        baseColor = semanticColors.domain;
        break;
      default:
        baseColor = Colors.grey;
    }

    // Desaturate colors slightly for CLI theme's monochromatic feel
    final hslColor = HSLColor.fromColor(baseColor);
    return hslColor.withSaturation(hslColor.saturation * 0.8).toColor();
  }

  // Helper method for default semantic colors when extension is not available
  Color _getDefaultSemanticColor(String conceptType, bool isDarkMode) {
    final baseColor = SemanticColors.forDomainType(conceptType);
    final colorScheme = getColorScheme(isDarkMode);

    // Adjust the color based on the color scheme brightness
    if (colorScheme.brightness == Brightness.dark) {
      // Make colors brighter in dark mode
      return Color.lerp(baseColor, Colors.white, 0.2) ?? baseColor;
    }

    return baseColor;
  }
}
