part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Abstract base class for all theme components in the Shell Architecture
///
/// Each theme component represents a specific theme style and provides both light and dark
/// theme variants. Theme components are integrated with the disclosure level system
/// to provide progressive disclosure of UI complexity.
abstract class ThemeComponent {
  /// Get the name of this theme component
  String get name;

  /// Get the light mode theme data
  ThemeData get lightTheme;

  /// Get the dark mode theme data
  ThemeData get darkTheme;

  /// Get theme data based on dark mode flag
  ThemeData getTheme(bool isDarkMode) => isDarkMode ? darkTheme : lightTheme;

  /// Get theme data based on dark mode flag and disclosure level
  ThemeData getThemeForDisclosureLevel(bool isDarkMode, DisclosureLevel level) {
    ThemeData baseTheme = getTheme(isDarkMode);
    return ShellTheme.withDisclosureLevel(baseTheme, level);
  }

  /// Get appropriate color scheme based on dark mode flag
  ColorScheme getColorScheme(bool isDarkMode) =>
      isDarkMode ? darkTheme.colorScheme : lightTheme.colorScheme;

  /// Get semantic color for a domain concept type
  Color getSemanticColor(String conceptType, bool isDarkMode) {
    final baseColor = SemanticColors.forDomainType(conceptType);
    final colorScheme = getColorScheme(isDarkMode);

    // Adjust the color based on the color scheme brightness
    if (colorScheme.brightness == Brightness.dark) {
      // Make colors brighter in dark mode
      return Color.lerp(baseColor, Colors.white, 0.2) ?? baseColor;
    }

    return baseColor;
  }

  /// Get text style for a domain concept with appropriate disclosure level
  TextStyle getSemanticTextStyle(
      BuildContext context, String conceptType, DisclosureLevel level,
      {bool isDarkMode = false}) {
    return ThemeTextStyles.forSemanticType(
      conceptType,
      context,
      level: level,
      themeName: name,
    );
  }
}
