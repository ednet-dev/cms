part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A component that displays a single bookmark with appropriate UI based on disclosure level
///
/// This component provides:
/// - Selectable bookmark items
/// - Contextual actions based on disclosure level
/// - Integration with the bookmark service
class BookmarkItem extends StatelessWidget with ProgressiveDisclosure {
  /// The bookmark to display
  final Bookmark bookmark;

  /// Callback when bookmark is selected
  final void Function(Bookmark)? onSelect;

  /// Callback when bookmark is edited
  final void Function(Bookmark)? onEdit;

  /// Callback when bookmark is deleted
  final void Function(Bookmark)? onDelete;

  /// Callback when bookmark's favorite status is toggled
  final void Function(Bookmark)? onFavoriteToggle;

  /// The disclosure level for progressive UI complexity
  @override
  final DisclosureLevel disclosureLevel;

  /// Style configuration for the bookmark item
  final BookmarkItemStyle? style;

  /// Create a bookmark item
  const BookmarkItem({
    Key? key,
    required this.bookmark,
    this.onSelect,
    this.onEdit,
    this.onDelete,
    this.onFavoriteToggle,
    this.disclosureLevel = DisclosureLevel.basic,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? BookmarkItemStyle.fromTheme(theme);
    final isFavorite = bookmark.category == BookmarkCategory.favorite;

    // Basic content
    final title = Text(
      bookmark.title,
      style: effectiveStyle.titleStyle,
      overflow: TextOverflow.ellipsis,
    );

    // Different layouts based on disclosure level
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        // Minimal view just shows icon and title
        return ListTile(
          leading: Icon(bookmark.displayIcon, color: effectiveStyle.iconColor),
          title: title,
          onTap: onSelect != null ? () => onSelect!(bookmark) : null,
        );

      case DisclosureLevel.basic:
        // Basic view adds subtitle and favorite button
        return ListTile(
          leading: Icon(bookmark.displayIcon, color: effectiveStyle.iconColor),
          title: title,
          subtitle: Text(
            bookmark.url,
            style: effectiveStyle.subtitleStyle,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? effectiveStyle.favoriteColor
                  : effectiveStyle.iconColor,
            ),
            onPressed: onFavoriteToggle != null
                ? () => onFavoriteToggle!(bookmark)
                : null,
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
          onTap: onSelect != null ? () => onSelect!(bookmark) : null,
        );

      case DisclosureLevel.intermediate:
      case DisclosureLevel.advanced:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        // More detailed view with description and multiple actions
        return Card(
          margin: effectiveStyle.cardMargin,
          child: Padding(
            padding: effectiveStyle.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row with icon, title and actions
                Row(
                  children: [
                    Icon(bookmark.displayIcon, color: effectiveStyle.iconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: title,
                    ),
                    if (onFavoriteToggle != null)
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? effectiveStyle.favoriteColor
                              : effectiveStyle.iconColor,
                        ),
                        onPressed: () => onFavoriteToggle!(bookmark),
                        tooltip: isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                        iconSize: 20,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: effectiveStyle.iconColor),
                        onPressed: () => onDelete!(bookmark),
                        tooltip: 'Delete bookmark',
                        iconSize: 20,
                      ),
                    if (onEdit != null)
                      IconButton(
                        icon: Icon(Icons.edit, color: effectiveStyle.iconColor),
                        onPressed: () => onEdit!(bookmark),
                        tooltip: 'Edit bookmark',
                        iconSize: 20,
                      ),
                  ],
                ),

                // URL
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4, bottom: 4),
                  child: Text(
                    bookmark.url,
                    style: effectiveStyle.subtitleStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Description if available
                if (bookmark.description != null &&
                    bookmark.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 32, top: 4, bottom: 8),
                    child: Text(
                      bookmark.description!,
                      style: effectiveStyle.descriptionStyle,
                    ),
                  ),

                // Metadata in advanced levels
                if (disclosureLevel.isAtLeast(DisclosureLevel.advanced))
                  Padding(
                    padding: const EdgeInsets.only(left: 32, top: 4),
                    child: Text(
                      'Created: ${_formatDate(bookmark.createdAt)}',
                      style: effectiveStyle.metadataStyle,
                    ),
                  ),
              ],
            ),
          ),
        );

      default:
        // Default to basic for unhandled levels
        return ListTile(
          leading: Icon(bookmark.displayIcon, color: effectiveStyle.iconColor),
          title: title,
          subtitle: Text(bookmark.url),
          onTap: onSelect != null ? () => onSelect!(bookmark) : null,
        );
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 2) {
      return 'Yesterday, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Style configuration for bookmark items
class BookmarkItemStyle {
  /// Style for the bookmark title
  final TextStyle titleStyle;

  /// Style for the bookmark URL
  final TextStyle subtitleStyle;

  /// Style for the bookmark description
  final TextStyle descriptionStyle;

  /// Style for metadata text
  final TextStyle metadataStyle;

  /// Color for bookmark icons
  final Color iconColor;

  /// Color for the favorite icon when active
  final Color favoriteColor;

  /// Margin for the bookmark card
  final EdgeInsetsGeometry cardMargin;

  /// Padding for the bookmark card
  final EdgeInsetsGeometry cardPadding;

  /// Create a custom bookmark item style
  const BookmarkItemStyle({
    required this.titleStyle,
    required this.subtitleStyle,
    required this.descriptionStyle,
    required this.metadataStyle,
    required this.iconColor,
    required this.favoriteColor,
    required this.cardMargin,
    required this.cardPadding,
  });

  /// Create a bookmark item style from the current theme
  factory BookmarkItemStyle.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return BookmarkItemStyle(
      titleStyle: theme.textTheme.titleMedium!.copyWith(
        color: colorScheme.onSurface,
      ),
      subtitleStyle: theme.textTheme.bodySmall!.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      descriptionStyle: theme.textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      metadataStyle: theme.textTheme.bodySmall!.copyWith(
        color:
            colorScheme.onSurfaceVariant.withValues(alpha: 178), // ~0.7 opacity
        fontStyle: FontStyle.italic,
      ),
      iconColor: colorScheme.primary,
      favoriteColor: colorScheme.error,
      cardMargin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      cardPadding: const EdgeInsets.all(12.0),
    );
  }
}
