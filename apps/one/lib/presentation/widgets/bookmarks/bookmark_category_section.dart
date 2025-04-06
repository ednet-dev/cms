import 'package:flutter/material.dart';
import 'bookmark_model.dart';
import 'bookmark_item.dart';

/// Widget for displaying a category of bookmarks
class BookmarkCategorySection extends StatefulWidget {
  /// The category title
  final String title;

  /// The icon to display for this category
  final IconData icon;

  /// The bookmarks in this category
  final List<Bookmark> bookmarks;

  /// Callback when a bookmark is selected
  final Function(Bookmark) onBookmarkSelected;

  /// Callback when a bookmark should be edited
  final Function(Bookmark) onBookmarkEdit;

  /// Callback when a bookmark should be deleted
  final Function(Bookmark) onBookmarkDelete;

  /// Callback when a bookmark's favorite status should be toggled
  final Function(Bookmark) onBookmarkFavoriteToggle;

  /// Constructor for BookmarkCategorySection
  const BookmarkCategorySection({
    Key? key,
    required this.title,
    required this.icon,
    required this.bookmarks,
    required this.onBookmarkSelected,
    required this.onBookmarkEdit,
    required this.onBookmarkDelete,
    required this.onBookmarkFavoriteToggle,
  }) : super(key: key);

  @override
  State<BookmarkCategorySection> createState() =>
      _BookmarkCategorySectionState();
}

class _BookmarkCategorySectionState extends State<BookmarkCategorySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Don't render if no bookmarks in this category
    if (widget.bookmarks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.bookmarks.length.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),

        // Bookmarks list (if expanded)
        if (_isExpanded)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                for (final bookmark in widget.bookmarks)
                  BookmarkItem(
                    bookmark: bookmark,
                    isFavorite: bookmark.category == BookmarkCategory.favorite,
                    onPressed: () => widget.onBookmarkSelected(bookmark),
                    onEdit: () => widget.onBookmarkEdit(bookmark),
                    onDelete: () => widget.onBookmarkDelete(bookmark),
                    onToggleFavorite:
                        () => widget.onBookmarkFavoriteToggle(bookmark),
                  ),
                const SizedBox(height: 4),
              ],
            ),
          ),

        const Divider(),
      ],
    );
  }
}
