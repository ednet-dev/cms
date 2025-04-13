part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Minimalistic theme component with clean, minimal design optimized for Material 3
/// with enhanced accessibility focus, integrated with disclosure levels
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
        return TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          height: 1.2,
        );
      case DisclosureLevel.basic:
        return TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          height: 1.2,
        );
      case DisclosureLevel.standard:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.2,
        );
      case DisclosureLevel.intermediate:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.2,
        );
      case DisclosureLevel.advanced:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.2,
        );
      case DisclosureLevel.detailed:
        return TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.2,
        );
      case DisclosureLevel.complete:
        return TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.2,
        );
      case DisclosureLevel.debug:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.2,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
        );
    }
  }

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

    // Build and return the dark theme
    return _buildMinimalisticTheme(colorScheme, textTheme, Brightness.dark);
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

    // Build and return the light theme
    return _buildMinimalisticTheme(colorScheme, textTheme, Brightness.light);
  }

  /// Common method to build minimalistic theme with given parameters
  ThemeData _buildMinimalisticTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
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

    // Get background color based on brightness
    final backgroundColor = brightness == Brightness.light
        ? ThemeColors.lightBackground
        : ThemeColors.darkBackground;

    // Create disclosure level color maps
    final primaryColors = <DisclosureLevel, Color>{
      DisclosureLevel.minimal:
          colorScheme.primary.withValues(alpha: 204), // 0.8
      DisclosureLevel.basic: colorScheme.primary.withValues(alpha: 217), // 0.85
      DisclosureLevel.standard:
          colorScheme.primary.withValues(alpha: 230), // 0.9
      DisclosureLevel.intermediate: colorScheme.primary,
      DisclosureLevel.advanced: colorScheme.primary,
      DisclosureLevel.detailed: colorScheme.primary,
      DisclosureLevel.complete: colorScheme.primary,
      DisclosureLevel.debug: colorScheme.error,
    };

    final secondaryColors = <DisclosureLevel, Color>{
      DisclosureLevel.minimal: colorScheme.secondary.withValues(alpha: 204),
      DisclosureLevel.basic: colorScheme.secondary.withValues(alpha: 217),
      DisclosureLevel.standard: colorScheme.secondary.withValues(alpha: 230),
      DisclosureLevel.intermediate: colorScheme.secondary,
      DisclosureLevel.advanced: colorScheme.secondary,
      DisclosureLevel.detailed: colorScheme.secondary,
      DisclosureLevel.complete: colorScheme.secondary,
      DisclosureLevel.debug: colorScheme.error,
    };

    final tertiaryColors = <DisclosureLevel, Color>{
      DisclosureLevel.minimal: colorScheme.primary.withValues(alpha: 179),
      DisclosureLevel.basic: colorScheme.primary.withValues(alpha: 179),
      DisclosureLevel.standard: colorScheme.primary.withValues(alpha: 179),
      DisclosureLevel.intermediate: colorScheme.primary.withValues(alpha: 179),
      DisclosureLevel.advanced: colorScheme.primary.withValues(alpha: 179),
      DisclosureLevel.detailed: colorScheme.primary.withValues(alpha: 179),
      DisclosureLevel.complete: colorScheme.primary.withValues(alpha: 179),
      DisclosureLevel.debug: colorScheme.error,
    };

    // Create text styles for disclosure levels
    final textStyles = <DisclosureLevel, TextStyle>{
      DisclosureLevel.minimal: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      DisclosureLevel.basic: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      DisclosureLevel.standard: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      DisclosureLevel.intermediate: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      DisclosureLevel.advanced: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      DisclosureLevel.detailed: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      DisclosureLevel.complete: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      DisclosureLevel.debug: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.2,
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
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: statusBarStyle,
        titleTextStyle: TextStyle(
          color: colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
        actionsIconTheme: IconThemeData(color: colorScheme.primary),
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
        color: backgroundColor,
        margin: EdgeInsets.zero,
      ),

      // Input decoration - clean lines
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.secondary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: colorScheme.primary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated button - subtle elevation
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor:
              brightness == Brightness.light ? Colors.white : backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Outlined button - thin border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Text button - clean
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(color: colorScheme.primary, size: 24),

      // Divider theme - subtle
      dividerTheme: DividerThemeData(
        color: colorScheme.primary.withValues(alpha: 51),
        thickness: 0.5,
        space: 32,
      ),

      // Checkbox theme - minimal
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(
            brightness == Brightness.light ? Colors.white : backgroundColor),
        side: BorderSide(color: colorScheme.primary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Switch theme - elegant
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.grey[400];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 77);
          }
          return brightness == Brightness.light
              ? Colors.grey[300]
              : Colors.grey[800];
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Slider theme - thin
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withValues(alpha: 51),
        thumbColor: colorScheme.primary,
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),

      // Bottom navigation - discreet
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.primary.withValues(alpha: 153),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      visualDensity: VisualDensity.standard,
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
        // For Minimalistic theme, we subtly adjust color intensity based on disclosure level
        primary: levelExtension.getPrimaryColorForLevel(level),
        secondary: levelExtension.getSecondaryColorForLevel(level),
        tertiary: levelExtension.getTertiaryColorForLevel(level),
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
      // Use the default implementation from ThemeComponent
      final baseColor = SemanticColors.forDomainType(conceptType);
      final colorScheme = getColorScheme(isDarkMode);

      // Adjust the color based on the color scheme brightness
      if (colorScheme.brightness == Brightness.dark) {
        // Make colors brighter in dark mode
        return Color.lerp(baseColor, Colors.white, 0.2) ?? baseColor;
      }

      return baseColor;
    }

    switch (conceptType.toLowerCase()) {
      case 'entity':
        return semanticColors.entity;
      case 'concept':
        return semanticColors.concept;
      case 'attribute':
        return semanticColors.attribute;
      case 'relationship':
        return semanticColors.relationship;
      case 'model':
        return semanticColors.model;
      case 'domain':
        return semanticColors.domain;
      default:
        // Use the default implementation from ThemeComponent
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
}
