import 'package:flutter/material.dart';
import 'bookmark_model.dart';

/// Widget for displaying an individual bookmark
class BookmarkItem extends StatelessWidget {
  /// The bookmark to display
  final Bookmark bookmark;

  /// Callback when the bookmark is selected/clicked
  final VoidCallback? onPressed;

  /// Callback when the bookmark should be edited
  final VoidCallback? onEdit;

  /// Callback when the bookmark should be deleted
  final VoidCallback? onDelete;

  /// Callback when the bookmark favorite status should be toggled
  final VoidCallback? onToggleFavorite;

  /// Whether this bookmark is in the favorites category
  final bool isFavorite;

  /// Whether to show action buttons
  final bool showActions;

  /// Constructor for BookmarkItem
  const BookmarkItem({
    super.key,
    required this.bookmark,
    this.onPressed,
    this.onEdit,
    this.onDelete,
    this.onToggleFavorite,
    this.isFavorite = false,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icon based on category/type
              Icon(bookmark.displayIcon, color: colorScheme.primary, size: 22),

              const SizedBox(width: 12),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bookmark.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bookmark.description != null)
                      Text(
                        bookmark.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      bookmark.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Action buttons
              if (showActions) ...[
                // Favorite toggle button
                if (onToggleFavorite != null)
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          isFavorite
                              ? Colors.redAccent
                              : colorScheme.onSurfaceVariant,
                    ),
                    tooltip:
                        isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                    onPressed: onToggleFavorite,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                  ),

                // Edit button
                if (onEdit != null)
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    tooltip: 'Edit bookmark',
                    onPressed: onEdit,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                  ),

                // Delete button
                if (onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    tooltip: 'Delete bookmark',
                    onPressed: onDelete,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
