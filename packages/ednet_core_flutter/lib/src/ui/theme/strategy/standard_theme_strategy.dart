part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Standard implementation of the ThemeStrategy interface.
///
/// This class provides the default theme creation and customization logic for the
/// Shell Architecture.
class StandardThemeStrategy implements ThemeStrategy {
  @override
  ThemeData createLightTheme({
    required String themeName,
    required ThemeConfiguration config,
  }) {
    // Create a base light theme
    final baseTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: ThemeColors.lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: ThemeColors.lightPrimary,
        secondary: ThemeColors.lightSecondary,
        surface: ThemeColors.lightSurface,
        error: ThemeColors.lightError,
        onSurface: ThemeColors.lightOnSurface,
        onError: ThemeColors.lightOnError,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.lightPrimary,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: ThemeColors.lightBackground,
      cardTheme: const CardTheme(
        color: ThemeColors.lightSurface,
        elevation: 2.0,
      ),
    );

    // Apply custom theme configurations
    return createCustomTheme(
      baseTheme: baseTheme,
      config: config,
    );
  }

  @override
  ThemeData createDarkTheme({
    required String themeName,
    required ThemeConfiguration config,
  }) {
    // Create a base dark theme
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: ThemeColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: ThemeColors.darkPrimary,
        secondary: ThemeColors.darkSecondary,
        surface: ThemeColors.darkSurface,
        error: ThemeColors.darkError,
        onSurface: ThemeColors.darkOnSurface,
        onError: ThemeColors.darkOnError,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.darkPrimary,
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: ThemeColors.darkBackground,
      cardTheme: const CardTheme(
        color: ThemeColors.darkSurface,
        elevation: 4.0,
      ),
    );

    // Apply custom theme configurations
    return createCustomTheme(
      baseTheme: baseTheme,
      config: config,
    );
  }

  @override
  ThemeData createThemeWithDisclosureLevel({
    required ThemeData baseTheme,
    required DisclosureLevel disclosureLevel,
  }) {
    // Create extensions for disclosure level using the appropriate factory constructor
    final disclosureLevelExtension = baseTheme.brightness == Brightness.light
        ? DisclosureLevelThemeExtension.light(baseTheme.colorScheme)
        : DisclosureLevelThemeExtension.dark(baseTheme.colorScheme);

    // Apply the extension to the theme
    return baseTheme.copyWith(
      extensions: <ThemeExtension<dynamic>>[
        disclosureLevelExtension,
        ...baseTheme.extensions.values,
      ],
    );
  }

  @override
  ThemeData applySemanticColors({
    required ThemeData baseTheme,
    required SemanticColors semanticColors,
  }) {
    // Create semantic colors extension using the appropriate factory constructor
    final semanticColorsExtension = baseTheme.brightness == Brightness.light
        ? SemanticColorsExtension.light()
        : SemanticColorsExtension.dark();

    // Apply the extension to the theme
    return baseTheme.copyWith(
      extensions: <ThemeExtension<dynamic>>[
        semanticColorsExtension,
        ...baseTheme.extensions.values,
      ],
    );
  }

  @override
  ThemeData themeForDisclosureLevel({
    required ThemeData baseTheme,
    required DisclosureLevel disclosureLevel,
  }) {
    // Create a theme with the specified disclosure level
    return createThemeWithDisclosureLevel(
      baseTheme: baseTheme,
      disclosureLevel: disclosureLevel,
    );
  }

  @override
  ThemeData createCustomTheme({
    required ThemeData baseTheme,
    required ThemeConfiguration config,
  }) {
    var customTheme = baseTheme;

    // Apply theme-specific customizations
    switch (config.themeName) {
      case ThemeNames.cheerful:
        customTheme = _applyCheerfulThemeCustomizations(customTheme, config);
        break;
      case ThemeNames.minimalistic:
        customTheme =
            _applyMinimalisticThemeCustomizations(customTheme, config);
        break;
      case ThemeNames.cli:
        customTheme = _applyCliThemeCustomizations(customTheme, config);
        break;
      case ThemeNames.corporate:
        customTheme = _applyCorporateThemeCustomizations(customTheme, config);
        break;
      case ThemeNames.creative:
        customTheme = _applyCreativeThemeCustomizations(customTheme, config);
        break;
    }

    // Apply semantic colors if enabled
    if (config.useSemanticColors) {
      customTheme = applySemanticColors(
        baseTheme: customTheme,
        semanticColors: SemanticColors(),
      );
    }

    return customTheme;
  }

  // Private theme customization methods

  ThemeData _applyCheerfulThemeCustomizations(
      ThemeData theme, ThemeConfiguration config) {
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark
        ? ThemeColors.cheerfulDarkAccent
        : ThemeColors.cheerfulLightAccent;

    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: accentColor,
        secondary: accentColor.withValues(alpha: 204), // ~0.8 opacity
      ),
      textTheme: theme.textTheme.apply(
        bodyColor: isDark ? Colors.white : Colors.black87,
        displayColor: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: accentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  ThemeData _applyMinimalisticThemeCustomizations(
      ThemeData theme, ThemeConfiguration config) {
    return theme.copyWith(
      cardTheme: theme.cardTheme.copyWith(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color:
                theme.colorScheme.outline.withValues(alpha: 25), // ~0.1 opacity
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: theme.colorScheme.primary,
              width: 1,
            ),
          ),
        ),
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        thickness: 1,
        space: 1,
      ),
      iconTheme: theme.iconTheme.copyWith(
        size: 20,
      ),
    );
  }

  ThemeData _applyCliThemeCustomizations(
      ThemeData theme, ThemeConfiguration config) {
    return theme.copyWith(
      textTheme: theme.textTheme.apply(
        fontFamily: 'monospace',
      ),
      cardTheme: theme.cardTheme.copyWith(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color:
                theme.colorScheme.outline.withValues(alpha: 51), // ~0.2 opacity
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  ThemeData _applyCorporateThemeCustomizations(
      ThemeData theme, ThemeConfiguration config) {
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 4,
      ),
      cardTheme: theme.cardTheme.copyWith(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  ThemeData _applyCreativeThemeCustomizations(
      ThemeData theme, ThemeConfiguration config) {
    return theme.copyWith(
      cardTheme: theme.cardTheme.copyWith(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: theme.textTheme.apply(
        fontSizeDelta: 1,
      ),
    );
  }
}
