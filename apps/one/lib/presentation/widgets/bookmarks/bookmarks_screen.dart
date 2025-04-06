import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookmark_model.dart';
import 'bookmark_manager.dart';
import 'bookmark_dialog.dart';
import 'bookmark_filter.dart';

/// A full screen for browsing and managing bookmarks
class BookmarksScreen extends StatefulWidget {
  /// Constructor for BookmarksScreen
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Bookmark>? _filteredBookmarks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: BookmarkCategory.values.length,
      vsync: this,
    );

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _filteredBookmarks =
            null; // Reset filtered bookmarks when search changes
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Handle bookmark filter application
  void _handleFiltersApplied(List<Bookmark> filteredBookmarks) {
    setState(() {
      _filteredBookmarks = filteredBookmarks;
      _searchQuery = ''; // Clear search when filters are applied
      _searchController.clear();
    });
  }

  /// Clear all active filters
  void _clearFilters() {
    setState(() {
      _filteredBookmarks = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookmarkManager = Provider.of<BookmarkManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          BookmarkFilterButton(onFiltersApplied: _handleFiltersApplied),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createBookmark(context, bookmarkManager),
            tooltip: 'Add bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => _importBookmarks(context, bookmarkManager),
            tooltip: 'Import bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportBookmarks(context, bookmarkManager),
            tooltip: 'Export bookmarks',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs:
              BookmarkCategory.values.map((category) {
                return Tab(
                  icon: Icon(category.icon),
                  text: category.displayName,
                );
              }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Search bar and filter indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
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
                  ),
                ),

                // Show indicator when filters are active
                if (_filteredBookmarks != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Filters applied (${_filteredBookmarks!.length} results)',
                          style: theme.textTheme.bodySmall,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear filters'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Tab content
          Expanded(child: _buildContent(bookmarkManager)),
        ],
      ),
    );
  }

  /// Build the main content based on search/filter state
  Widget _buildContent(BookmarkManager bookmarkManager) {
    // If we have filtered bookmarks, show them
    if (_filteredBookmarks != null) {
      return _buildBookmarkList(_filteredBookmarks!);
    }

    // If searching, show search results
    if (_searchQuery.isNotEmpty) {
      return _buildSearchResults(bookmarkManager);
    }

    // Otherwise show tabs
    return TabBarView(
      controller: _tabController,
      children:
          BookmarkCategory.values.map((category) {
            return _buildCategoryTab(category, bookmarkManager);
          }).toList(),
    );
  }

  /// Build a direct list of bookmarks
  Widget _buildBookmarkList(List<Bookmark> bookmarks) {
    if (bookmarks.isEmpty) {
      return const Center(
        child: Text('No bookmarks match the current filters'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return _buildBookmarkItem(bookmark, context.read<BookmarkManager>());
      },
    );
  }

  /// Build the search results view
  Widget _buildSearchResults(BookmarkManager bookmarkManager) {
    return FutureBuilder<List<Bookmark>>(
      future: bookmarkManager.searchBookmarks(_searchQuery),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookmarks = snapshot.data!;

        if (bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No bookmarks found for "$_searchQuery"',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarks[index];
            return _buildBookmarkItem(bookmark, bookmarkManager);
          },
        );
      },
    );
  }

  /// Build a tab for a specific category
  Widget _buildCategoryTab(
    BookmarkCategory category,
    BookmarkManager bookmarkManager,
  ) {
    return FutureBuilder<List<Bookmark>>(
      future: bookmarkManager.getBookmarksByCategory(category),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookmarks = snapshot.data!;

        if (bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No ${category.displayName} Bookmarks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Bookmark'),
                  onPressed: () => _createBookmark(context, bookmarkManager),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = bookmarks[index];
            return _buildBookmarkItem(bookmark, bookmarkManager);
          },
        );
      },
    );
  }

  /// Build an individual bookmark item
  Widget _buildBookmarkItem(
    Bookmark bookmark,
    BookmarkManager bookmarkManager,
  ) {
    final isFavorite = bookmark.category == BookmarkCategory.favorite;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            bookmark.displayIcon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          bookmark.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bookmark.description != null) ...[
              const SizedBox(height: 4),
              Text(bookmark.description!),
            ],
            const SizedBox(height: 4),
            Text(
              bookmark.url,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(bookmark.category.displayName),
                  avatar: Icon(bookmark.category.icon, size: 16),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Text(
                  'Created ${_formatDate(bookmark.createdAt)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
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
              icon: const Icon(Icons.edit_outlined),
              onPressed:
                  () => _editBookmark(context, bookmarkManager, bookmark),
              tooltip: 'Edit bookmark',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed:
                  () => _deleteBookmark(context, bookmarkManager, bookmark),
              tooltip: 'Delete bookmark',
            ),
          ],
        ),
        onTap: () => _navigateToBookmark(context, bookmark),
      ),
    );
  }

  /// Format a date for display
  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Navigate to a bookmark
  void _navigateToBookmark(BuildContext context, Bookmark bookmark) {
    // In a real app, this would trigger navigation to the bookmarked location
    // For now, just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigating to ${bookmark.title}')));

    // Close the screen
    Navigator.of(context).pop(bookmark);
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
}
