part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Cheerful theme component with vibrant colors optimized for Material 3
/// with enhanced accessibility focus, integrated with disclosure levels
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
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
          height: 1.3,
        );
      case DisclosureLevel.basic:
        return TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
          height: 1.3,
        );
      case DisclosureLevel.standard:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.3,
        );
      case DisclosureLevel.intermediate:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.3,
        );
      case DisclosureLevel.advanced:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
        );
      case DisclosureLevel.detailed:
        return TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
        );
      case DisclosureLevel.complete:
        return TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          height: 1.3,
        );
      case DisclosureLevel.debug:
        return TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.3,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
        );
    }
  }

  /// Build the dark cheerful theme with Material 3 design
  ThemeData _buildDarkTheme() {
    // Use dark amber as primary color for cheerful theme in dark mode
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFD54F),
      brightness: Brightness.dark,
      primary: const Color(0xFFFFD54F),
      onPrimary: const Color(0xFF1F1B08),
      primaryContainer: const Color(0xFF4D4536),
      onPrimaryContainer: const Color(0xFFFFF6DE),
      secondary: const Color(0xFF57CBFF), // Bright blue for accents
      onSecondary: const Color(0xFF0B2029),
      secondaryContainer: const Color(0xFF2E4E5F),
      onSecondaryContainer: const Color(0xFFDDF4FF),
      tertiary: const Color(0xFFFF8A65), // Coral for highlights
      onTertiary: const Color(0xFF291807),
      tertiaryContainer: const Color(0xFF5D3D2C),
      onTertiaryContainer: const Color(0xFFFFEEE8),
      error: const Color(0xFFFF8A80),
      onError: const Color(0xFF340D09),
      errorContainer: const Color(0xFF542320),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFEAEAEA),
      surfaceContainerHigh: const Color(0xFF323232),
      surfaceContainerLow: const Color(0xFF252525),
      surfaceContainerLowest: const Color(0xFF181818),
      surfaceBright: const Color(0xFF2E2E2E),
      surfaceDim: const Color(0xFF1C1C1C),
      surfaceContainer: const Color(0xFF2A2A2A),
      surfaceContainerHighest: const Color(0xFF3E3E3E),
      onSurfaceVariant: const Color(0xFFE7DCC9),
      outline: const Color(0xFF998D79),
      outlineVariant: const Color(0xFF665E4F),
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
      inverseSurface: const Color(0xFFE0E0E0),
      onInverseSurface: const Color(0xFF2C2C2C),
      inversePrimary: const Color(0xFF825C00),
      surfaceTint: const Color(0xFFFFD54F),
    );

    // Build and return the dark theme
    return _buildThemeFromColorScheme(colorScheme, Brightness.dark);
  }

  /// Build the light cheerful theme with Material 3 design
  ThemeData _buildLightTheme() {
    // Use amber as primary color for cheerful theme in light mode
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFB300), // Amber base
      brightness: Brightness.light,
      primary: const Color(0xFFFFB300),
      onPrimary: const Color(0xFF2E2800),
      primaryContainer: const Color(0xFFFFE082),
      onPrimaryContainer: const Color(0xFF291E00),
      secondary: const Color(0xFF0288D1), // Blue for accents
      onSecondary: const Color(0xFFFFFFFF),
      secondaryContainer: const Color(0xFFBBDEFB),
      onSecondaryContainer: const Color(0xFF001E2E),
      tertiary: const Color(0xFFE64A19), // Deep orange for highlights
      onTertiary: const Color(0xFFFFFFFF),
      tertiaryContainer: const Color(0xFFFFCCBC),
      onTertiaryContainer: const Color(0xFF341906),
      error: const Color(0xFFD32F2F),
      onError: const Color(0xFFFFFFFF),
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      surface: const Color(0xFFFFFBFF),
      onSurface: const Color(0xFF1A1C18),
      surfaceContainerHigh: const Color(0xFFEAE6DD),
      surfaceContainerLow: const Color(0xFFF6F2E8),
      surfaceContainerLowest: const Color(0xFFFBF8EF),
      surfaceBright: const Color(0xFFFFFBFF),
      surfaceDim: const Color(0xFFDED9D0),
      surfaceContainer: const Color(0xFFF0EBE2),
      surfaceContainerHighest: const Color(0xFFE4E1D8),
      onSurfaceVariant: const Color(0xFF4D4639),
      outline: const Color(0xFF807667),
      outlineVariant: const Color(0xFFD1C7B7),
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
      inverseSurface: const Color(0xFF2F312D),
      onInverseSurface: const Color(0xFFF0F1E9),
      inversePrimary: const Color(0xFFE5C32A),
      surfaceTint: const Color(0xFFFFB300),
    );

    // Build and return the light theme
    return _buildThemeFromColorScheme(colorScheme, Brightness.light);
  }

  /// Build theme from color scheme with additional customization
  ThemeData _buildThemeFromColorScheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
    // Get base text theme
    final textTheme = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

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

    // Build theme with Material 3 and our custom color scheme
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: statusBarStyle,
        iconTheme: IconThemeData(color: colorScheme.primary, size: 24),
        actionsIconTheme: IconThemeData(color: colorScheme.primary, size: 24),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        color: colorScheme.surface,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        deleteIconColor: colorScheme.onSurfaceVariant,
        disabledColor: colorScheme.surfaceContainerLowest,
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 1,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(64, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline, width: 1),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(64, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(64, 40),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surface,
        selectedTileColor: colorScheme.primaryContainer.withOpacity(0.3),
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.titleSmall,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.12);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        modalBackgroundColor: colorScheme.surface,
        modalBarrierColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        elevation: 4,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        textStyle: textTheme.labelSmall,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 1,
        selectedIconTheme: IconThemeData(color: colorScheme.primary, size: 24),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        useIndicator: true,
        indicatorColor: colorScheme.primaryContainer,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24.0),
      primaryIconTheme: IconThemeData(color: colorScheme.primary, size: 24.0),
      extensions: [
        DisclosureLevelThemeExtension.light(colorScheme),
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
        // Adjust the color intensity based on disclosure level
        primary: levelExtension.getPrimaryColorForLevel(level),
        secondary: levelExtension.getSecondaryColorForLevel(level),
        tertiary: levelExtension.getTertiaryColorForLevel(level),
      ),
      // You can also adjust other theme properties based on disclosure level
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

/// Extension to help with disclosure level
extension DisclosureLevelVisualDensity on DisclosureLevel {
  /// Convert disclosure level to visual density
  VisualDensity toVisualDensity() {
    switch (this) {
      case DisclosureLevel.minimal:
        return VisualDensity.compact;
      case DisclosureLevel.basic:
        return VisualDensity.comfortable;
      case DisclosureLevel.standard:
        return VisualDensity.standard;
      case DisclosureLevel.intermediate:
        return VisualDensity.standard;
      case DisclosureLevel.advanced:
        return VisualDensity.standard;
      case DisclosureLevel.detailed:
        return VisualDensity.comfortable;
      case DisclosureLevel.complete:
        return VisualDensity.comfortable;
      case DisclosureLevel.debug:
        return VisualDensity.comfortable;
    }
  }
}
