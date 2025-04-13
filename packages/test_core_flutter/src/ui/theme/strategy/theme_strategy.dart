part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A strategy for applying themes in the Shell Architecture.
///
/// ThemeStrategy implementations are responsible for determining how themes
/// are created, customized, and applied across the application.
abstract class ThemeStrategy {
  /// Creates theme data for the light theme
  ThemeData createLightTheme({
    required String themeName,
    required ThemeConfiguration config,
  });

  /// Creates theme data for the dark theme
  ThemeData createDarkTheme({
    required String themeName,
    required ThemeConfiguration config,
  });

  /// Creates a theme with disclosure level customizations
  ThemeData createThemeWithDisclosureLevel({
    required ThemeData baseTheme,
    required DisclosureLevel disclosureLevel,
  });

  /// Applies semantic colors to a theme
  ThemeData applySemanticColors({
    required ThemeData baseTheme,
    required SemanticColors semanticColors,
  });

  /// Gets a theme for a specific disclosure level
  ThemeData themeForDisclosureLevel({
    required ThemeData baseTheme,
    required DisclosureLevel disclosureLevel,
  });

  /// Creates a custom theme with the provided configuration
  ThemeData createCustomTheme({
    required ThemeData baseTheme,
    required ThemeConfiguration config,
  });
}
