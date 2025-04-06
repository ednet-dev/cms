import 'package:flutter/material.dart';

/// A reusable card component for list items with consistent styling
///
/// This component provides a standardized way to display list items
/// across the application with proper theming and animations.
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 4.0,
        bottom: 4.0,
      ),
      elevation: 1,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading icon with a colored background
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color:
                      iconBackgroundColor ??
                      colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? colorScheme.primary,
                  size: 24,
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (badgeText != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badgeText!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Subtitle if provided
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Info text with icon if provided
                    if (infoText != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            infoIcon ?? Icons.info_outline,
                            size: 14,
                            color: colorScheme.secondary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            infoText!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.secondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing widget or chevron
              trailingWidget ??
                  (showChevron
                      ? Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
