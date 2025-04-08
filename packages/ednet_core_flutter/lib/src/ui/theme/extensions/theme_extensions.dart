part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Extensions for BuildContext for theme operations in the Shell Architecture
extension ThemeContextExtensions on BuildContext {
  /// Get theme data with the appropriate disclosure level
  ThemeData getThemeForDisclosureLevel(DisclosureLevel level) {
    final theme = Theme.of(this);
    final levelExtension = theme.extension<DisclosureLevelThemeExtension>();

    if (levelExtension == null) {
      return theme;
    }

    // Apply disclosure level-specific modifications
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: levelExtension.getPrimaryColorForLevel(level),
        secondary: levelExtension.getSecondaryColorForLevel(level),
        tertiary: levelExtension.getTertiaryColorForLevel(level),
      ),
      visualDensity: level.toVisualDensity(),
    );
  }

  /// Get the semantic colors extension from the current theme
  SemanticColorsExtension? get semanticColors {
    return Theme.of(this).extension<SemanticColorsExtension>();
  }

  /// Get the disclosure level theme extension from the current theme
  DisclosureLevelThemeExtension? get disclosureLevelTheme {
    return Theme.of(this).extension<DisclosureLevelThemeExtension>();
  }

  /// Get icon for a semantic concept
  IconData conceptIcon(String conceptType) {
    // Default icons for common domain concepts
    switch (conceptType.toLowerCase()) {
      case 'entity':
        return Icons.category;
      case 'concept':
        return Icons.bubble_chart;
      case 'attribute':
        return Icons.label;
      case 'relationship':
        return Icons.link;
      case 'model':
        return Icons.model_training;
      case 'domain':
        return Icons.domain;
      case 'project':
        return Icons.folder_special;
      case 'task':
        return Icons.task_alt;
      case 'person':
        return Icons.person;
      case 'team':
        return Icons.group;
      case 'resource':
        return Icons.inventory;
      case 'milestone':
        return Icons.flag;
      case 'budget':
        return Icons.attach_money;
      case 'initiative':
        return Icons.lightbulb_outline;
      case 'time':
        return Icons.schedule;
      default:
        return Icons.circle;
    }
  }

  /// Get color for a semantic concept
  Color conceptColor(String conceptType) {
    final semanticColorsExt = semanticColors;

    if (semanticColorsExt != null) {
      return semanticColorsExt.getColorForConceptType(conceptType);
    }

    // Fallback if extension is not available
    return SemanticColors.forDomainType(conceptType);
  }

  /// Get text style for a semantic concept with optional role
  TextStyle conceptTextStyle(String conceptType,
      {String? role, DisclosureLevel? level}) {
    final theme = Theme.of(this);
    final brightness = theme.brightness;
    final disclosureLevel = level ?? DisclosureLevel.standard;
    final color = conceptColor(conceptType);

    // Base style based on concept type
    var style = TextStyle(
      color: color,
      fontSize: 16,
    );

    // Apply concept-specific styling
    switch (conceptType.toLowerCase()) {
      case 'entity':
        style = style.copyWith(fontWeight: FontWeight.bold);
        break;
      case 'attribute':
        style = style.copyWith(fontStyle: FontStyle.italic);
        break;
      case 'relationship':
        style = style.copyWith(decoration: TextDecoration.underline);
        break;
    }

    // Apply role-specific styling
    if (role != null) {
      switch (role) {
        case 'title':
          style = style.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          );
          break;
        case 'subtitle':
          style = style.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          );
          break;
        case 'description':
          style = style.copyWith(
            fontSize: 14,
            color:
                brightness == Brightness.dark ? Colors.white70 : Colors.black54,
          );
          break;
        case 'emphasized':
          style = style.copyWith(fontWeight: FontWeight.bold);
          break;
        case 'deemphasized':
          style = style.copyWith(
            color:
                brightness == Brightness.dark ? Colors.white60 : Colors.black45,
          );
          break;
      }
    }

    // Apply disclosure level adjustment if the extension is available
    final disclosureLevelExt = disclosureLevelTheme;
    if (disclosureLevelExt != null) {
      final levelStyle =
          disclosureLevelExt.getTextStyleForLevel(disclosureLevel);
      style = style.copyWith(
        fontSize: levelStyle.fontSize,
        fontWeight: levelStyle.fontWeight,
      );
    } else {
      // Fallback disclosure level adjustments
      switch (disclosureLevel) {
        case DisclosureLevel.minimal:
          style = style.copyWith(fontSize: style.fontSize! * 0.85);
          break;
        case DisclosureLevel.detailed:
        case DisclosureLevel.complete:
          style = style.copyWith(fontSize: style.fontSize! * 1.1);
          break;
        case DisclosureLevel.debug:
          style = style.copyWith(
            fontSize: style.fontSize! * 1.1,
            fontStyle: FontStyle.italic,
          );
          break;
        default:
          // Keep original size
          break;
      }
    }

    return style;
  }

  /// Get decoration for a container based on semantic concept
  BoxDecoration conceptDecoration(String conceptType,
      {DisclosureLevel? level}) {
    final theme = Theme.of(this);
    final color = conceptColor(conceptType);
    final disclosureLevel = level ?? DisclosureLevel.standard;
    final borderRadius = BorderRadius.circular(8);

    // Base decoration
    var decoration = BoxDecoration(
      color: theme.cardColor,
      borderRadius: borderRadius,
      border: Border.all(color: theme.dividerColor),
    );

    // Apply concept-specific styling
    switch (conceptType.toLowerCase()) {
      case 'entity':
        decoration = BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: borderRadius,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        );
        break;
      case 'concept':
        decoration = BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: borderRadius,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        );
        break;
      case 'model':
        decoration = BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
        break;
      case 'domain':
        decoration = BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );
        break;
    }

    // Apply disclosure level adjustments
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        // Simpler decoration for minimal view
        decoration = decoration.copyWith(
          boxShadow: [],
          border: Border.all(
            color: decoration.border != null && decoration.border is Border
                ? (decoration.border as Border).top.color
                : theme.dividerColor,
            width: 0.5,
          ),
        );
        break;
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
        // Enhanced decoration for detailed view
        final List<BoxShadow> shadows = decoration.boxShadow ?? [];
        if (shadows.isNotEmpty) {
          decoration = decoration.copyWith(
            boxShadow: [
              for (var shadow in shadows) shadow.scale(1.5),
            ],
          );
        } else {
          decoration = decoration.copyWith(
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          );
        }
        break;
      case DisclosureLevel.debug:
        // Special decoration for debug view
        decoration = decoration.copyWith(
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
            width: 1,
            style: BorderStyle.solid,
          ),
        );
        break;
      default:
        // Keep original decoration
        break;
    }

    return decoration;
  }
}

/// Extension for BoxShadow scaling
extension BoxShadowScaling on BoxShadow {
  /// Create a scaled version of this shadow
  BoxShadow scale(double factor) {
    return BoxShadow(
      color: color,
      blurRadius: blurRadius * factor,
      spreadRadius: spreadRadius * factor,
      offset: Offset(offset.dx * factor, offset.dy * factor),
    );
  }
}
