part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A reusable card component for list items with consistent styling and progressive disclosure
///
/// This component provides a standardized way to display list items across the application
/// with proper theming, animations, and adaptable styling based on disclosure level.
/// It supports the Shell Architecture's separation of domain logic from presentation.
///
/// @deprecated Use [DomainListItem] instead. This component will be removed in a future release.
class ListItemCard extends StatelessWidget {
  /// The main title of the list item
  final String title;

  /// Optional subtitle or description
  final String? subtitle;

  /// Optional additional information text (like a count)
  final String? infoText;

  /// The leading icon to display
  final IconData icon;

  /// Optional badge text to show on the item
  final String? badgeText;

  /// Function called when the card is tapped
  final VoidCallback onTap;

  /// Optional icon for additional information
  final IconData? infoIcon;

  /// Optional custom widget to display in the trailing position
  final Widget? trailingWidget;

  /// Whether to show a chevron icon at the end
  final bool showChevron;

  /// Optional custom icon color
  final Color? iconColor;

  /// Optional custom icon background color
  final Color? iconBackgroundColor;

  /// The semantic concept type this card represents (entity, concept, etc.)
  final String semanticType;

  /// The current disclosure level for progressive UI
  final DisclosureLevel disclosureLevel;

  /// Additional properties for entity-specific rendering
  final Map<String, dynamic>? additionalProperties;

  /// Constructor for the ListItemCard
  const ListItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.infoText,
    required this.icon,
    this.badgeText,
    required this.onTap,
    this.infoIcon,
    this.trailingWidget,
    this.showChevron = true,
    this.iconColor,
    this.iconBackgroundColor,
    this.semanticType = 'entity',
    this.disclosureLevel = DisclosureLevel.standard,
    this.additionalProperties,
  });

  /// Create a ListItemCard configured for a specific entity type
  factory ListItemCard.forEntityType({
    required String entityType,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    String? infoText,
    IconData? icon,
    String? badgeText,
    IconData? infoIcon,
    Widget? trailingWidget,
    bool showChevron = true,
    Color? iconColor,
    Color? iconBackgroundColor,
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
    Map<String, dynamic>? additionalProperties,
  }) {
    // Select appropriate icon based on entity type if not specified
    IconData entityIcon = icon ?? _getIconForEntityType(entityType);

    return ListItemCard(
      title: title,
      subtitle: subtitle,
      infoText: infoText,
      icon: entityIcon,
      badgeText: badgeText,
      onTap: onTap,
      infoIcon: infoIcon,
      trailingWidget: trailingWidget,
      showChevron: showChevron,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      semanticType: entityType,
      disclosureLevel: disclosureLevel,
      additionalProperties: additionalProperties,
    );
  }

  /// Create a ListItemCard from a canonical model
  factory ListItemCard.fromCanonicalModel({
    required Map<String, dynamic> model,
    required VoidCallback onTap,
    required BuildContext context,
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
    Widget? trailingWidget,
    bool showChevron = true,
  }) {
    // Extract data from canonical model
    final String title = model['title'] ?? 'Untitled';
    final String? subtitle = model['description'];
    final String entityType = model['type'] ?? 'entity';
    final String? infoText = model['info'];
    final String? badgeText = model['badge'];

    // Get theme-appropriate colors
    final theme = Theme.of(context);
    final Color? iconColor =
        theme.extension<SemanticColorsExtension>()?.getColorForType(entityType);

    return ListItemCard.forEntityType(
      entityType: entityType,
      title: title,
      subtitle: subtitle,
      infoText: infoText,
      badgeText: badgeText,
      onTap: onTap,
      trailingWidget: trailingWidget,
      showChevron: showChevron,
      iconColor: iconColor,
      disclosureLevel: disclosureLevel,
      additionalProperties: model,
    );
  }

  /// Helper method to get appropriate icon for entity type
  static IconData _getIconForEntityType(String entityType) {
    switch (entityType.toLowerCase()) {
      case 'entity':
        return Icons.category;
      case 'concept':
        return Icons.hub;
      case 'attribute':
        return Icons.label;
      case 'relationship':
        return Icons.link;
      case 'model':
        return Icons.account_tree;
      case 'domain':
        return Icons.domain;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine the appropriate styling based on disclosure level
    final cardElevation = _getElevationForDisclosureLevel(disclosureLevel);
    final cardPadding = _getPaddingForDisclosureLevel(disclosureLevel);
    final titleStyle =
        _getTitleStyleForDisclosureLevel(context, disclosureLevel);
    final subtitleStyle =
        _getSubtitleStyleForDisclosureLevel(context, disclosureLevel);
    final iconSize = _getIconSizeForDisclosureLevel(disclosureLevel);

    // Get semantic colors for the entityType if available
    final semanticColor = _getSemanticColor(context);
    final effectiveIconColor =
        iconColor ?? semanticColor ?? colorScheme.primary;
    final effectiveIconBgColor = iconBackgroundColor ??
        (semanticColor?.withValues(alpha: 77) ??
            colorScheme.primaryContainer.withValues(alpha: 77));

    return Card(
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 4.0,
        bottom: 4.0,
      ),
      elevation: cardElevation,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              colorScheme.outlineVariant.withValues(alpha: 51), // 0.2 opacity
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading icon with a colored background
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: effectiveIconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: effectiveIconColor,
                  size: iconSize,
                ),
              ),
              const SizedBox(width: 16),

              // Content area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with optional badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: titleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badgeText != null &&
                            _shouldShowBadge(disclosureLevel)) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: semanticColor?.withValues(alpha: 51) ??
                                  colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badgeText!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: semanticColor ??
                                    colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Subtitle if provided and disclosure level permits
                    if (subtitle != null &&
                        _shouldShowSubtitle(disclosureLevel)) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: subtitleStyle,
                        maxLines: _getMaxLinesForSubtitle(disclosureLevel),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Info text with icon if provided and disclosure level permits
                    if (infoText != null &&
                        _shouldShowInfoText(disclosureLevel)) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            infoIcon ?? Icons.info_outline,
                            size: 14,
                            color: semanticColor?.withValues(alpha: 179) ??
                                colorScheme.secondary.withValues(alpha: 179),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            infoText!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: semanticColor?.withValues(alpha: 179) ??
                                  colorScheme.secondary.withValues(alpha: 179),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Additional properties based on disclosure level
                    ..._buildAdditionalProperties(context, disclosureLevel),
                  ],
                ),
              ),

              // Trailing widget or chevron
              trailingWidget ??
                  (showChevron
                      ? Icon(
                          Icons.chevron_right,
                          color: colorScheme.onSurface.withValues(alpha: 128),
                          size: 20,
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to adapt UI based on disclosure level

  double _getElevationForDisclosureLevel(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
        return 0;
      case DisclosureLevel.basic:
        return 0;
      case DisclosureLevel.standard:
        return 1;
      case DisclosureLevel.intermediate:
        return 1;
      case DisclosureLevel.advanced:
        return 2;
      case DisclosureLevel.detailed:
        return 2;
      case DisclosureLevel.complete:
        return 3;
      case DisclosureLevel.debug:
        return 0;
    }
  }

  EdgeInsets _getPaddingForDisclosureLevel(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
        return const EdgeInsets.all(8.0);
      case DisclosureLevel.basic:
        return const EdgeInsets.all(10.0);
      case DisclosureLevel.standard:
        return const EdgeInsets.all(12.0);
      case DisclosureLevel.intermediate:
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
        return const EdgeInsets.all(16.0);
      case DisclosureLevel.debug:
        return const EdgeInsets.all(12.0);
    }
  }

  TextStyle? _getTitleStyleForDisclosureLevel(
      BuildContext context, DisclosureLevel level) {
    final theme = Theme.of(context);

    switch (level) {
      case DisclosureLevel.minimal:
      case DisclosureLevel.basic:
        return theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        );
      case DisclosureLevel.standard:
      case DisclosureLevel.intermediate:
        return theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
        return theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
      case DisclosureLevel.debug:
        return theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.error,
        );
    }
  }

  TextStyle? _getSubtitleStyleForDisclosureLevel(
      BuildContext context, DisclosureLevel level) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (level) {
      case DisclosureLevel.minimal:
      case DisclosureLevel.basic:
        return theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 179),
        );
      case DisclosureLevel.standard:
      case DisclosureLevel.intermediate:
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        return theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 179),
        );
    }
  }

  double _getIconSizeForDisclosureLevel(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
        return 16;
      case DisclosureLevel.basic:
        return 20;
      case DisclosureLevel.standard:
        return 24;
      case DisclosureLevel.intermediate:
        return 24;
      case DisclosureLevel.advanced:
        return 28;
      case DisclosureLevel.detailed:
        return 28;
      case DisclosureLevel.complete:
        return 32;
      case DisclosureLevel.debug:
        return 24;
    }
  }

  bool _shouldShowBadge(DisclosureLevel level) {
    return level != DisclosureLevel.minimal;
  }

  bool _shouldShowSubtitle(DisclosureLevel level) {
    return level != DisclosureLevel.minimal;
  }

  bool _shouldShowInfoText(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
      case DisclosureLevel.basic:
        return false;
      case DisclosureLevel.standard:
      case DisclosureLevel.intermediate:
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        return true;
    }
  }

  int _getMaxLinesForSubtitle(DisclosureLevel level) {
    switch (level) {
      case DisclosureLevel.minimal:
        return 1;
      case DisclosureLevel.basic:
        return 1;
      case DisclosureLevel.standard:
        return 2;
      case DisclosureLevel.intermediate:
        return 2;
      case DisclosureLevel.advanced:
        return 3;
      case DisclosureLevel.detailed:
        return 3;
      case DisclosureLevel.complete:
        return 4;
      case DisclosureLevel.debug:
        return 5;
    }
  }

  Color? _getSemanticColor(BuildContext context) {
    if (semanticType.isEmpty) return null;

    final theme = Theme.of(context);
    final semanticColors = theme.extension<SemanticColorsExtension>();
    if (semanticColors == null) return null;

    switch (semanticType.toLowerCase()) {
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
        return null;
    }
  }

  List<Widget> _buildAdditionalProperties(
      BuildContext context, DisclosureLevel level) {
    // Only show additional properties for advanced disclosure levels
    if (level.index < DisclosureLevel.advanced.index ||
        additionalProperties == null) {
      return [];
    }

    final theme = Theme.of(context);
    final widgets = <Widget>[];

    // Generate additional property rows for debug and complete levels
    if (level == DisclosureLevel.debug || level == DisclosureLevel.complete) {
      additionalProperties!.forEach((key, value) {
        // Skip title, subtitle and info that are already displayed
        if (!['title', 'description', 'info', 'badge', 'type'].contains(key)) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Text(
                    '$key: ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      value?.toString() ?? 'null',
                      style: theme.textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }

    return widgets;
  }
}

/// Extension to SemanticColorsExtension to simplify color lookups
extension SemanticColorsTypeExtension on SemanticColorsExtension {
  /// Get color for a specific domain type
  Color? getColorForType(String type) {
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
        return null;
    }
  }
}
