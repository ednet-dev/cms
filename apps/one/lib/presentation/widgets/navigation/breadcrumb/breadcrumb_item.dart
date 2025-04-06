import 'package:flutter/material.dart';

/// Individual segment in a breadcrumb trail
class BreadcrumbItem extends StatelessWidget {
  /// The label text to display for this breadcrumb segment
  final String label;

  /// Whether this is the currently active/selected segment
  final bool isActive;

  /// Callback when this segment is tapped
  final VoidCallback onTap;

  /// Whether to show a bookmark button (typically only for the active segment)
  final bool showBookmarkButton;

  /// Callback when the bookmark button is tapped
  final VoidCallback? onBookmark;

  /// Constructor for BreadcrumbItem
  const BreadcrumbItem({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.showBookmarkButton = false,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                isActive
                    ? theme.colorScheme.primaryContainer
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border:
                isActive ? Border.all(color: theme.colorScheme.primary) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color:
                      isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (showBookmarkButton && onBookmark != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.bookmark_add, size: 16),
                  tooltip: 'Bookmark this location',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  onPressed: onBookmark,
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
