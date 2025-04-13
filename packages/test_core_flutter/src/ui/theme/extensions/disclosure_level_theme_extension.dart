part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Theme extension for disclosure level-specific styling
class DisclosureLevelThemeExtension
    extends ThemeExtension<DisclosureLevelThemeExtension> {
  /// Primary color map by disclosure level
  final Map<DisclosureLevel, Color> primaryColors;

  /// Secondary color map by disclosure level
  final Map<DisclosureLevel, Color> secondaryColors;

  /// Tertiary color map by disclosure level
  final Map<DisclosureLevel, Color> tertiaryColors;

  /// Text style map by disclosure level
  final Map<DisclosureLevel, TextStyle> textStyles;

  /// Size scaling factor map by disclosure level (for UI element sizing)
  final Map<DisclosureLevel, double> scalingFactors;

  /// Default constructor for DisclosureLevelThemeExtension
  const DisclosureLevelThemeExtension({
    required this.primaryColors,
    required this.secondaryColors,
    required this.tertiaryColors,
    required this.textStyles,
    required this.scalingFactors,
  });

  /// Factory constructor for light theme
  factory DisclosureLevelThemeExtension.light(ColorScheme colorScheme) {
    return DisclosureLevelThemeExtension(
      primaryColors: {
        DisclosureLevel.minimal: colorScheme.primary.withValues(alpha: 0.7),
        DisclosureLevel.basic: colorScheme.primary.withValues(alpha: 0.8),
        DisclosureLevel.standard: colorScheme.primary,
        DisclosureLevel.intermediate: colorScheme.primary,
        DisclosureLevel.advanced: colorScheme.primary,
        DisclosureLevel.detailed: colorScheme.primary,
        DisclosureLevel.complete: colorScheme.primary,
        DisclosureLevel.debug: colorScheme.error,
      },
      secondaryColors: {
        DisclosureLevel.minimal: colorScheme.secondary.withValues(alpha: 0.7),
        DisclosureLevel.basic: colorScheme.secondary.withValues(alpha: 0.8),
        DisclosureLevel.standard: colorScheme.secondary,
        DisclosureLevel.intermediate: colorScheme.secondary,
        DisclosureLevel.advanced: colorScheme.secondary,
        DisclosureLevel.detailed: colorScheme.secondary,
        DisclosureLevel.complete: colorScheme.secondary,
        DisclosureLevel.debug: colorScheme.tertiary,
      },
      tertiaryColors: {
        DisclosureLevel.minimal: colorScheme.tertiary.withValues(alpha: 0.7),
        DisclosureLevel.basic: colorScheme.tertiary.withValues(alpha: 0.8),
        DisclosureLevel.standard: colorScheme.tertiary,
        DisclosureLevel.intermediate: colorScheme.tertiary,
        DisclosureLevel.advanced: colorScheme.tertiary,
        DisclosureLevel.detailed: colorScheme.tertiary,
        DisclosureLevel.complete: colorScheme.tertiary,
        DisclosureLevel.debug: colorScheme.secondary,
      },
      textStyles: {
        DisclosureLevel.minimal: const TextStyle(fontSize: 14),
        DisclosureLevel.basic: const TextStyle(fontSize: 14),
        DisclosureLevel.standard: const TextStyle(fontSize: 16),
        DisclosureLevel.intermediate: const TextStyle(fontSize: 16),
        DisclosureLevel.advanced: const TextStyle(fontSize: 16),
        DisclosureLevel.detailed: const TextStyle(fontSize: 16),
        DisclosureLevel.complete: const TextStyle(fontSize: 16),
        DisclosureLevel.debug:
            const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      },
      scalingFactors: {
        DisclosureLevel.minimal: 0.8,
        DisclosureLevel.basic: 0.9,
        DisclosureLevel.standard: 1.0,
        DisclosureLevel.intermediate: 1.0,
        DisclosureLevel.advanced: 1.0,
        DisclosureLevel.detailed: 1.1,
        DisclosureLevel.complete: 1.2,
        DisclosureLevel.debug: 1.2,
      },
    );
  }

  /// Factory constructor for dark theme
  factory DisclosureLevelThemeExtension.dark(ColorScheme colorScheme) {
    return DisclosureLevelThemeExtension(
      primaryColors: {
        DisclosureLevel.minimal: colorScheme.primary.withValues(alpha: 0.7),
        DisclosureLevel.basic: colorScheme.primary.withValues(alpha: 0.8),
        DisclosureLevel.standard: colorScheme.primary,
        DisclosureLevel.intermediate: colorScheme.primary,
        DisclosureLevel.advanced: colorScheme.primary,
        DisclosureLevel.detailed: colorScheme.primary,
        DisclosureLevel.complete: colorScheme.primary,
        DisclosureLevel.debug: colorScheme.error,
      },
      secondaryColors: {
        DisclosureLevel.minimal: colorScheme.secondary.withValues(alpha: 0.7),
        DisclosureLevel.basic: colorScheme.secondary.withValues(alpha: 0.8),
        DisclosureLevel.standard: colorScheme.secondary,
        DisclosureLevel.intermediate: colorScheme.secondary,
        DisclosureLevel.advanced: colorScheme.secondary,
        DisclosureLevel.detailed: colorScheme.secondary,
        DisclosureLevel.complete: colorScheme.secondary,
        DisclosureLevel.debug: colorScheme.tertiary,
      },
      tertiaryColors: {
        DisclosureLevel.minimal: colorScheme.tertiary.withValues(alpha: 0.7),
        DisclosureLevel.basic: colorScheme.tertiary.withValues(alpha: 0.8),
        DisclosureLevel.standard: colorScheme.tertiary,
        DisclosureLevel.intermediate: colorScheme.tertiary,
        DisclosureLevel.advanced: colorScheme.tertiary,
        DisclosureLevel.detailed: colorScheme.tertiary,
        DisclosureLevel.complete: colorScheme.tertiary,
        DisclosureLevel.debug: colorScheme.secondary,
      },
      textStyles: {
        DisclosureLevel.minimal: const TextStyle(fontSize: 14),
        DisclosureLevel.basic: const TextStyle(fontSize: 14),
        DisclosureLevel.standard: const TextStyle(fontSize: 16),
        DisclosureLevel.intermediate: const TextStyle(fontSize: 16),
        DisclosureLevel.advanced: const TextStyle(fontSize: 16),
        DisclosureLevel.detailed: const TextStyle(fontSize: 16),
        DisclosureLevel.complete: const TextStyle(fontSize: 16),
        DisclosureLevel.debug:
            const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      },
      scalingFactors: {
        DisclosureLevel.minimal: 0.8,
        DisclosureLevel.basic: 0.9,
        DisclosureLevel.standard: 1.0,
        DisclosureLevel.intermediate: 1.0,
        DisclosureLevel.advanced: 1.0,
        DisclosureLevel.detailed: 1.1,
        DisclosureLevel.complete: 1.2,
        DisclosureLevel.debug: 1.2,
      },
    );
  }

  /// Get primary color for disclosure level
  Color getPrimaryColorForLevel(DisclosureLevel level) {
    return primaryColors[level] ?? primaryColors[DisclosureLevel.standard]!;
  }

  /// Get secondary color for disclosure level
  Color getSecondaryColorForLevel(DisclosureLevel level) {
    return secondaryColors[level] ?? secondaryColors[DisclosureLevel.standard]!;
  }

  /// Get tertiary color for disclosure level
  Color getTertiaryColorForLevel(DisclosureLevel level) {
    return tertiaryColors[level] ?? tertiaryColors[DisclosureLevel.standard]!;
  }

  /// Get text style for disclosure level
  TextStyle getTextStyleForLevel(DisclosureLevel level) {
    return textStyles[level] ?? textStyles[DisclosureLevel.standard]!;
  }

  /// Get scaling factor for disclosure level
  double getScalingFactorForLevel(DisclosureLevel level) {
    return scalingFactors[level] ?? scalingFactors[DisclosureLevel.standard]!;
  }

  @override
  ThemeExtension<DisclosureLevelThemeExtension> copyWith({
    Map<DisclosureLevel, Color>? primaryColors,
    Map<DisclosureLevel, Color>? secondaryColors,
    Map<DisclosureLevel, Color>? tertiaryColors,
    Map<DisclosureLevel, TextStyle>? textStyles,
    Map<DisclosureLevel, double>? scalingFactors,
  }) {
    return DisclosureLevelThemeExtension(
      primaryColors: primaryColors ?? this.primaryColors,
      secondaryColors: secondaryColors ?? this.secondaryColors,
      tertiaryColors: tertiaryColors ?? this.tertiaryColors,
      textStyles: textStyles ?? this.textStyles,
      scalingFactors: scalingFactors ?? this.scalingFactors,
    );
  }

  @override
  ThemeExtension<DisclosureLevelThemeExtension> lerp(
    covariant ThemeExtension<DisclosureLevelThemeExtension>? other,
    double t,
  ) {
    if (other is! DisclosureLevelThemeExtension) {
      return this;
    }

    return DisclosureLevelThemeExtension(
      primaryColors: _lerpColorMap(primaryColors, other.primaryColors, t),
      secondaryColors: _lerpColorMap(secondaryColors, other.secondaryColors, t),
      tertiaryColors: _lerpColorMap(tertiaryColors, other.tertiaryColors, t),
      textStyles: _lerpTextStyleMap(textStyles, other.textStyles, t),
      scalingFactors: _lerpDoubleMap(scalingFactors, other.scalingFactors, t),
    );
  }

  // Helper method to lerp between color maps
  Map<DisclosureLevel, Color> _lerpColorMap(
    Map<DisclosureLevel, Color> a,
    Map<DisclosureLevel, Color> b,
    double t,
  ) {
    final result = <DisclosureLevel, Color>{};

    for (final level in DisclosureLevel.values) {
      final aColor = a[level];
      final bColor = b[level];

      if (aColor != null && bColor != null) {
        result[level] = Color.lerp(aColor, bColor, t)!;
      } else if (aColor != null) {
        result[level] = aColor;
      } else if (bColor != null) {
        result[level] = bColor;
      }
    }

    return result;
  }

  // Helper method to lerp between text style maps
  Map<DisclosureLevel, TextStyle> _lerpTextStyleMap(
    Map<DisclosureLevel, TextStyle> a,
    Map<DisclosureLevel, TextStyle> b,
    double t,
  ) {
    final result = <DisclosureLevel, TextStyle>{};

    for (final level in DisclosureLevel.values) {
      final aStyle = a[level];
      final bStyle = b[level];

      if (aStyle != null && bStyle != null) {
        result[level] = TextStyle.lerp(aStyle, bStyle, t)!;
      } else if (aStyle != null) {
        result[level] = aStyle;
      } else if (bStyle != null) {
        result[level] = bStyle;
      }
    }

    return result;
  }

  // Helper method to lerp between double maps
  Map<DisclosureLevel, double> _lerpDoubleMap(
    Map<DisclosureLevel, double> a,
    Map<DisclosureLevel, double> b,
    double t,
  ) {
    final result = <DisclosureLevel, double>{};

    for (final level in DisclosureLevel.values) {
      final aValue = a[level];
      final bValue = b[level];

      if (aValue != null && bValue != null) {
        result[level] = lerpDouble(aValue, bValue, t)!;
      } else if (aValue != null) {
        result[level] = aValue;
      } else if (bValue != null) {
        result[level] = bValue;
      }
    }

    return result;
  }
}
