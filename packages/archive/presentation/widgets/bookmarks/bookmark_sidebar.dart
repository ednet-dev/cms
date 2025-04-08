import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookmark_model.dart';
import 'bookmark_manager.dart';
import 'bookmark_category_section.dart';
import 'bookmark_dialog.dart';

/// A collapsible sidebar for displaying and managing bookmarks
class BookmarkSidebar extends StatefulWidget {
  /// Whether the sidebar is initially collapsed
  final bool initiallyCollapsed;

  /// Callback when a bookmark is selected
  final Function(Bookmark)? onBookmarkSelected;

  /// Constructor for BookmarkSidebar
  const BookmarkSidebar({
    super.key,
    this.initiallyCollapsed = false,
    this.onBookmarkSelected,
  });

  @override
  State<BookmarkSidebar> createState() => _BookmarkSidebarState();
}

class _BookmarkSidebarState extends State<BookmarkSidebar> {
  static const String _collapsedKey = 'bookmark_sidebar_collapsed';
  bool _isCollapsed = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed;
    _loadCollapseState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load the collapsed state from preferences
  Future<void> _loadCollapseState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCollapsed = prefs.getBool(_collapsedKey) ?? widget.initiallyCollapsed;
    });
  }

  /// Save the collapsed state to preferences
  Future<void> _saveCollapseState(bool isCollapsed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_collapsedKey, isCollapsed);
    setState(() {
      _isCollapsed = isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bookmarkManager = Provider.of<BookmarkManager>(context);

    return FutureBuilder<List<Bookmark>>(
      future:
          _searchQuery.isEmpty
              ? bookmarkManager.getBookmarks()
              : bookmarkManager.searchBookmarks(_searchQuery),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allBookmarks = snapshot.data ?? [];

        // Group bookmarks by category
        final Map<BookmarkCategory, List<Bookmark>> categorizedBookmarks = {};
        for (final category in BookmarkCategory.values) {
          categorizedBookmarks[category] = [];
        }

        for (final bookmark in allBookmarks) {
          categorizedBookmarks[bookmark.category]!.add(bookmark);
        }

        // Display collapsed version if collapsed
        if (_isCollapsed) {
          return Container(
            width: 50,
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: 255.0 * 0.5,
            ),
            child: Column(
              children: [
                // Expand button
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _saveCollapseState(false),
                  tooltip: 'Expand bookmarks sidebar',
                ),
                const Divider(),

                // Category icons (for quick access even when collapsed)
                for (final category in BookmarkCategory.values)
                  if (categorizedBookmarks[category]!.isNotEmpty)
                    Tooltip(
                      message: '${category.displayName} Bookmarks',
                      child: IconButton(
                        icon: Icon(category.icon),
                        color: colorScheme.primary,
                        onPressed: () {
                          _saveCollapseState(false);
                          // Delay to allow sidebar to expand
                          Future.delayed(const Duration(milliseconds: 100), () {
                            // TODO: Scroll to this category when expanded
                          });
                        },
                      ),
                    ),

                const Spacer(),

                // Add button
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _createBookmark(context, bookmarkManager),
                  tooltip: 'Add bookmark',
                ),
              ],
            ),
          );
        }

        // Full expanded sidebar
        return Container(
          width: 300,
          color: colorScheme.surfaceContainerHighest.withValues(
            alpha: 255.0 * 0.5,
          ),
          child: Column(
            children: [
              // Header with search and collapse button
              Container(
                padding: const EdgeInsets.all(16.0),
                color: colorScheme.surfaceContainerHighest,
                child: Row(
                  children: [
                    Icon(Icons.bookmarks, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Bookmarks',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _saveCollapseState(true),
                      tooltip: 'Collapse sidebar',
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search bookmarks...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    isDense: true,
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add'),
                      onPressed:
                          () => _createBookmark(context, bookmarkManager),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.file_download, size: 16),
                      label: const Text('Export'),
                      onPressed:
                          () => _exportBookmarks(context, bookmarkManager),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.file_upload, size: 16),
                      label: const Text('Import'),
                      onPressed:
                          () => _importBookmarks(context, bookmarkManager),
                    ),
                  ],
                ),
              ),

              const Divider(height: 24),

              // Bookmarks by category
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // If search is active, show results in a unified list
                      if (_searchQuery.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                'Search Results (${allBookmarks.length})',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            for (final bookmark in allBookmarks)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: _buildBookmarkItem(
                                  bookmark,
                                  bookmarkManager,
                                ),
                              ),
                          ],
                        )
                      // Otherwise show categorized bookmarks
                      else
                        for (final category in [
                          BookmarkCategory.favorite,
                          BookmarkCategory.recent,
                          ...BookmarkCategory.values.where(
                            (c) =>
                                c != BookmarkCategory.favorite &&
                                c != BookmarkCategory.recent,
                          ),
                        ])
                          if (categorizedBookmarks[category]!.isNotEmpty)
                            BookmarkCategorySection(
                              title: category.displayName,
                              icon: category.icon,
                              bookmarks: categorizedBookmarks[category]!,
                              onBookmarkSelected: _handleBookmarkSelected,
                              onBookmarkEdit:
                                  (bookmark) => _editBookmark(
                                    context,
                                    bookmarkManager,
                                    bookmark,
                                  ),
                              onBookmarkDelete:
                                  (bookmark) => _deleteBookmark(
                                    context,
                                    bookmarkManager,
                                    bookmark,
                                  ),
                              onBookmarkFavoriteToggle:
                                  (bookmark) => _toggleFavorite(
                                    bookmarkManager,
                                    bookmark,
                                  ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Handle bookmark selection
  void _handleBookmarkSelected(Bookmark bookmark) {
    if (widget.onBookmarkSelected != null) {
      widget.onBookmarkSelected!(bookmark);
    }
  }

  /// Create a new bookmark
  Future<void> _createBookmark(
    BuildContext context,
    BookmarkManager bookmarkManager,
  ) async {
    final newBookmark = await showBookmarkDialog(context);
    if (newBookmark != null) {
      await bookmarkManager.addBookmark(newBookmark);
    }
  }

  /// Edit an existing bookmark
  Future<void> _editBookmark(
    BuildContext context,
    BookmarkManager bookmarkManager,
    Bookmark bookmark,
  ) async {
    final editedBookmark = await showBookmarkDialog(
      context,
      bookmarkToEdit: bookmark,
    );
    if (editedBookmark != null) {
      await bookmarkManager.updateBookmark(bookmark.id, editedBookmark);
    }
  }

  /// Delete a bookmark with confirmation
  Future<void> _deleteBookmark(
    BuildContext context,
    BookmarkManager bookmarkManager,
    Bookmark bookmark,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Bookmark'),
            content: Text(
              'Are you sure you want to delete "${bookmark.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await bookmarkManager.removeBookmark(bookmark.id);
    }
  }

  /// Toggle a bookmark's favorite status
  Future<void> _toggleFavorite(
    BookmarkManager bookmarkManager,
    Bookmark bookmark,
  ) async {
    await bookmarkManager.toggleFavorite(bookmark.id);
  }

  /// Export bookmarks to JSON
  Future<void> _exportBookmarks(
    BuildContext context,
    BookmarkManager bookmarkManager,
  ) async {
    final jsonData = await bookmarkManager.exportBookmarks();

    // In a real app, this would trigger a file download
    // For now, just show the JSON in a dialog for demonstration
    if (context.mounted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Export Bookmarks'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Here is your bookmark data:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    width: double.maxFinite,
                    height: 200,
                    child: SingleChildScrollView(
                      child: SelectableText(jsonData),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
      );
    }
  }

  /// Import bookmarks from JSON
  Future<void> _importBookmarks(
    BuildContext context,
    BookmarkManager bookmarkManager,
  ) async {
    final controller = TextEditingController();

    final jsonData = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Import Bookmarks'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Paste your bookmark JSON data:'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(controller.text),
                child: const Text('Import'),
              ),
            ],
          ),
    );

    if (jsonData != null && jsonData.isNotEmpty) {
      try {
        await bookmarkManager.importBookmarks(jsonData);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bookmarks imported successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to import bookmarks: $e')),
          );
        }
      }
    }
  }

  /// Build an individual bookmark item for search results
  Widget _buildBookmarkItem(
    Bookmark bookmark,
    BookmarkManager bookmarkManager,
  ) {
    final isFavorite = bookmark.category == BookmarkCategory.favorite;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(bookmark.displayIcon),
        title: Text(bookmark.title),
        subtitle: Text(bookmark.url),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : null,
              ),
              onPressed: () => _toggleFavorite(bookmarkManager, bookmark),
              tooltip:
                  isFavorite ? 'Remove from favorites' : 'Add to favorites',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed:
                  () => _deleteBookmark(context, bookmarkManager, bookmark),
              tooltip: 'Delete bookmark',
            ),
          ],
        ),
        onTap: () => _handleBookmarkSelected(bookmark),
      ),
    );
  }
}
