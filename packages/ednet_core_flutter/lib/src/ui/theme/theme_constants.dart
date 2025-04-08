part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Theme constants for EDNet Core Flutter
///
/// This file contains all theme-related constants that are used
/// throughout the application for consistent styling, with
/// support for the progressive disclosure UI pattern.

/// Color palette for the EDNet Core Flutter theme system
class ThemeColors {
  // Light mode colors
  static const Color lightPrimary = Colors.blueAccent;
  static const Color lightSecondary = Colors.lightBlue;
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Colors.white;
  static const Color lightOnBackground = Colors.black87;
  static const Color lightOnSurface = Colors.black87;
  static const Color lightError = Colors.redAccent;
  static const Color lightOnError = Colors.white;

  // Dark mode colors
  static const Color darkPrimary = Colors.greenAccent;
  static const Color darkSecondary = Colors.lightGreen;
  static const Color darkBackground = Colors.black;
  static const Color darkSurface = Colors.black;
  static const Color darkOnBackground = Colors.white70;
  static const Color darkOnSurface = Colors.white70;
  static const Color darkError = Colors.redAccent;
  static const Color darkOnError = Colors.black;

  // Cheerful theme colors
  static Color cheerfulDarkAccent = Colors.orange;
  static Color cheerfulDarkBackground = const Color(0xFF303030);
  static Color cheerfulLightAccent = Colors.blueAccent;

  // Disclosure level indicator colors
  static const Map<DisclosureLevel, Color> disclosureLevelColors = {
    DisclosureLevel.minimal: Colors.blue,
    DisclosureLevel.basic: Colors.green,
    DisclosureLevel.standard: Colors.teal,
    DisclosureLevel.intermediate: Colors.amber,
    DisclosureLevel.advanced: Colors.orange,
    DisclosureLevel.detailed: Colors.deepOrange,
    DisclosureLevel.complete: Colors.red,
    DisclosureLevel.debug: Colors.purple,
  };

  /// Returns the appropriate color for a given disclosure level
  static Color getDisclosureLevelColor(DisclosureLevel level) {
    return disclosureLevelColors[level] ?? lightPrimary;
  }
}

/// Text style constants for EDNet Core Flutter
class ThemeTextStyles {
  /// Builds a text style for CLI-inspired interfaces
  static TextStyle buildCliTextStyle(
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'monospace',
      letterSpacing: 0.2,
    );
  }

  /// Builds a standard text style
  static TextStyle buildStandardTextStyle(
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);
  }

  /// Builds a minimalistic text style
  static TextStyle buildMinimalisticTextStyle(
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
      height: 1.2,
    );
  }

  /// Returns a text style based on the theme name
  static TextStyle forThemeName(
    String themeName,
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    switch (themeName) {
      case ThemeNames.cli:
        return buildCliTextStyle(color, fontSize, fontWeight: fontWeight);
      case ThemeNames.minimalistic:
        return buildMinimalisticTextStyle(color, fontSize,
            fontWeight: fontWeight);
      case ThemeNames.corporate:
        return buildStandardTextStyle(color, fontSize, fontWeight: fontWeight);
      case ThemeNames.creative:
        return TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0.3,
          height: 1.3,
        );
      default:
        return buildStandardTextStyle(color, fontSize, fontWeight: fontWeight);
    }
  }

  /// Returns a text style appropriate for the given disclosure level
  static TextStyle forDisclosureLevel(
    DisclosureLevel level,
    BuildContext context, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    String? themeName,
  }) {
    final theme = Theme.of(context);
    Color textColor = color ?? ThemeColors.getDisclosureLevelColor(level);
    double textSize;
    FontWeight textWeight;

    switch (level) {
      case DisclosureLevel.minimal:
        textSize = fontSize ?? 14.0;
        textWeight = fontWeight ?? FontWeight.normal;
        break;
      case DisclosureLevel.basic:
        textSize = fontSize ?? 14.0;
        textWeight = fontWeight ?? FontWeight.normal;
        break;
      case DisclosureLevel.standard:
        textSize = fontSize ?? 15.0;
        textWeight = fontWeight ?? FontWeight.w400;
        break;
      case DisclosureLevel.intermediate:
        textSize = fontSize ?? 15.0;
        textWeight = fontWeight ?? FontWeight.w500;
        break;
      case DisclosureLevel.advanced:
        textSize = fontSize ?? 16.0;
        textWeight = fontWeight ?? FontWeight.w600;
        break;
      case DisclosureLevel.detailed:
        textSize = fontSize ?? 16.0;
        textWeight = fontWeight ?? FontWeight.w700;
        break;
      case DisclosureLevel.complete:
        textSize = fontSize ?? 18.0;
        textWeight = fontWeight ?? FontWeight.bold;
        break;
      case DisclosureLevel.debug:
        textSize = fontSize ?? 18.0;
        textWeight = fontWeight ?? FontWeight.bold;
        break;
    }

    // If a specific theme name is provided, use that theme's style
    if (themeName != null) {
      return forThemeName(themeName, textColor, textSize,
          fontWeight: textWeight);
    }

    // Otherwise, base on Material theme with customizations for disclosure level
    switch (level) {
      case DisclosureLevel.minimal:
        return theme.textTheme.bodyMedium!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
          letterSpacing: 0.4,
        );
      case DisclosureLevel.basic:
        return theme.textTheme.bodyLarge!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
        );
      case DisclosureLevel.standard:
        return theme.textTheme.bodyLarge!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
        );
      case DisclosureLevel.intermediate:
        return theme.textTheme.bodyLarge!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
        );
      case DisclosureLevel.advanced:
        return theme.textTheme.titleMedium!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
        );
      case DisclosureLevel.detailed:
        return theme.textTheme.titleMedium!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
        );
      case DisclosureLevel.complete:
        return theme.textTheme.titleLarge!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
        );
      case DisclosureLevel.debug:
        return theme.textTheme.titleLarge!.copyWith(
          color: textColor,
          fontSize: textSize,
          fontWeight: textWeight,
          fontStyle: FontStyle.italic,
        );
    }
  }

  /// Returns a semantic text style appropriate for domain model entities
  static TextStyle forSemanticType(
    String type,
    BuildContext context, {
    DisclosureLevel level = DisclosureLevel.standard,
    double? fontSize,
    FontWeight? fontWeight,
    String? themeName,
  }) {
    Color color = SemanticColors.forDomainType(type);
    return forDisclosureLevel(
      level,
      context,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      themeName: themeName,
    );
  }
}

/// Theme names for EDNet Core Flutter
class ThemeNames {
  static const String cheerful = 'Cheerful';
  static const String minimalistic = 'Minimalistic';
  static const String cli = 'CLI';
  static const String corporate = 'Corporate';
  static const String creative = 'Creative';
}

/// Theme modes for EDNet Core Flutter
class ThemeModes {
  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';
}

/// Semantic colors based on domain concepts
///
/// Maps domain-specific concepts to appropriate colors
class SemanticColors {
  static Color entity = Colors.blue;
  static Color concept = Colors.green;
  static Color attribute = Colors.orange;
  static Color relationship = Colors.purple;
  static Color model = Colors.teal;
  static Color domain = Colors.indigo;

  /// Returns a color based on a domain concept type
  static Color forDomainType(String type) {
    switch (type.toLowerCase()) {
      case 'entity':
        return entity;
      case 'concept':
        return concept;
      case 'attribute':
        return attribute;
      case 'relationship':
        return relationship;
      case 'model':
        return model;
      case 'domain':
        return domain;
      default:
        return Colors.grey;
    }
  }
}

/// Theme configuration for EDNet Core Flutter
///
/// Used by the Configuration Injector to apply theme settings
class ThemeConfiguration {
  final String themeName;
  final String themeMode;
  final bool useSemanticColors;
  final Map<String, dynamic>? customColors;

  const ThemeConfiguration({
    this.themeName = ThemeNames.minimalistic,
    this.themeMode = ThemeModes.system,
    this.useSemanticColors = true,
    this.customColors,
  });

  /// Creates a theme configuration from a map
  factory ThemeConfiguration.fromMap(Map<String, dynamic> map) {
    return ThemeConfiguration(
      themeName: map['themeName'] ?? ThemeNames.minimalistic,
      themeMode: map['themeMode'] ?? ThemeModes.system,
      useSemanticColors: map['useSemanticColors'] ?? true,
      customColors: map['customColors'],
    );
  }

  /// Converts the configuration to a map
  Map<String, dynamic> toMap() {
    return {
      'themeName': themeName,
      'themeMode': themeMode,
      'useSemanticColors': useSemanticColors,
      'customColors': customColors,
    };
  }
}
