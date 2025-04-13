part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A collapsible sidebar for displaying and managing bookmarks
///
/// This component provides a complete UI for browsing, searching, and managing bookmarks.
/// It integrates with the Shell architecture through the bookmark service and adapts
/// its UI based on the selected disclosure level.
class BookmarkSidebar extends StatefulWidget {
  /// Whether the sidebar is initially collapsed
  final bool initiallyCollapsed;

  /// Callback when a bookmark is selected
  final Function(Bookmark)? onBookmarkSelected;

  /// The disclosure level for the sidebar
  final DisclosureLevel disclosureLevel;

  /// Style configuration for the sidebar
  final BookmarkSidebarStyle? style;

  /// The bookmark service for loading bookmarks
  final BookmarkService? bookmarkService;

  /// Constructor
  const BookmarkSidebar({
    Key? key,
    this.initiallyCollapsed = false,
    this.onBookmarkSelected,
    this.disclosureLevel = DisclosureLevel.basic,
    this.style,
    this.bookmarkService,
  }) : super(key: key);

  @override
  State<BookmarkSidebar> createState() => _BookmarkSidebarState();
}

class _BookmarkSidebarState extends State<BookmarkSidebar> {
  static const String _collapsedKey = 'shell_bookmark_sidebar_collapsed';

  /// Whether the sidebar is collapsed
  bool _isCollapsed = false;

  /// Controller for search text field
  final TextEditingController _searchController = TextEditingController();

  /// Current search query
  String _searchQuery = '';

  /// Reference to the bookmark service
  late BookmarkService _bookmarkService;

  @override
  void initState() {
    super.initState();

    // Initialize state
    _isCollapsed = widget.initiallyCollapsed;
    _loadCollapseState();

    // Set up search controller
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    // Get bookmark service from widget or create a new one
    _bookmarkService = widget.bookmarkService ?? BookmarkService();
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
    final effectiveStyle =
        widget.style ?? BookmarkSidebarStyle.fromTheme(theme);

    return FutureBuilder<List<Bookmark>>(
      future: _searchQuery.isEmpty
          ? _bookmarkService.getBookmarks()
          : _bookmarkService.searchBookmarks(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return SizedBox(
            width: _isCollapsed
                ? effectiveStyle.collapsedWidth
                : effectiveStyle.expandedWidth,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final allBookmarks = snapshot.data ?? [];

        // Group bookmarks by category
        final categorizedBookmarks = <BookmarkCategory, List<Bookmark>>{};
        for (final category in BookmarkCategory.values) {
          categorizedBookmarks[category] = [];
        }

        for (final bookmark in allBookmarks) {
          categorizedBookmarks[bookmark.category]!.add(bookmark);
        }

        // Display collapsed version if collapsed
        if (_isCollapsed) {
          return _buildCollapsedSidebar(
              context, effectiveStyle, categorizedBookmarks);
        }

        // Display expanded version
        return _buildExpandedSidebar(
            context, effectiveStyle, categorizedBookmarks, allBookmarks);
      },
    );
  }

  /// Build the collapsed version of the sidebar
  Widget _buildCollapsedSidebar(
    BuildContext context,
    BookmarkSidebarStyle style,
    Map<BookmarkCategory, List<Bookmark>> categorizedBookmarks,
  ) {
    return Container(
      width: style.collapsedWidth,
      color: style.backgroundColor,
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
                  color: style.iconColor,
                  onPressed: () {
                    _saveCollapseState(false);
                    // Will expand the sidebar
                  },
                ),
              ),

          const Spacer(),

          // Add button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createBookmark(context),
            tooltip: 'Add bookmark',
          ),
        ],
      ),
    );
  }

  /// Build the expanded version of the sidebar
  Widget _buildExpandedSidebar(
    BuildContext context,
    BookmarkSidebarStyle style,
    Map<BookmarkCategory, List<Bookmark>> categorizedBookmarks,
    List<Bookmark> allBookmarks,
  ) {
    return Container(
      width: style.expandedWidth,
      color: style.backgroundColor,
      child: Column(
        children: [
          // Header with search and collapse button
          Container(
            padding: style.headerPadding,
            color: style.headerBackgroundColor,
            child: Row(
              children: [
                Icon(Icons.bookmarks, color: style.iconColor),
                const SizedBox(width: 8),
                Text(
                  'Bookmarks',
                  style: style.headerTextStyle,
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

          // Search bar (shown at Basic+ disclosure levels)
          if (widget.disclosureLevel.isAtLeast(DisclosureLevel.basic))
            Padding(
              padding: style.searchBarPadding,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search bookmarks...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
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

          // Action buttons (shown at Intermediate+ disclosure levels)
          if (widget.disclosureLevel.isAtLeast(DisclosureLevel.intermediate))
            Padding(
              padding: style.buttonsPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add'),
                    onPressed: () => _createBookmark(context),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_download, size: 16),
                    label: const Text('Export'),
                    onPressed: () => _exportBookmarks(context),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_upload, size: 16),
                    label: const Text('Import'),
                    onPressed: () => _importBookmarks(context),
                  ),
                ],
              ),
            ),

          const Divider(height: 24),

          // Bookmarks by category
          Expanded(
            child: SingleChildScrollView(
              padding: style.contentPadding,
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
                            style: style.categoryTitleStyle,
                          ),
                        ),
                        for (final bookmark in allBookmarks)
                          BookmarkItem(
                            bookmark: bookmark,
                            onSelect: _handleBookmarkSelected,
                            onEdit: (bookmark) =>
                                _editBookmark(context, bookmark),
                            onDelete: (bookmark) =>
                                _deleteBookmark(context, bookmark),
                            onFavoriteToggle: _toggleFavorite,
                            disclosureLevel: widget.disclosureLevel,
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
                        _buildCategorySection(
                          context,
                          style,
                          category,
                          categorizedBookmarks[category]!,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a category section containing bookmarks
  Widget _buildCategorySection(
    BuildContext context,
    BookmarkSidebarStyle style,
    BookmarkCategory category,
    List<Bookmark> bookmarks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Padding(
          padding: style.categoryHeaderPadding,
          child: Row(
            children: [
              Icon(category.icon, size: 18, color: style.iconColor),
              const SizedBox(width: 8),
              Text(
                category.displayName,
                style: style.categoryTitleStyle,
              ),
              const SizedBox(width: 4),
              Text(
                '(${bookmarks.length})',
                style: style.categoryCountStyle,
              ),
            ],
          ),
        ),

        // Bookmark items for this category
        for (final bookmark in bookmarks)
          BookmarkItem(
            bookmark: bookmark,
            onSelect: _handleBookmarkSelected,
            onEdit:
                widget.disclosureLevel.isAtLeast(DisclosureLevel.intermediate)
                    ? (bookmark) => _editBookmark(context, bookmark)
                    : null,
            onDelete:
                widget.disclosureLevel.isAtLeast(DisclosureLevel.intermediate)
                    ? (bookmark) => _deleteBookmark(context, bookmark)
                    : null,
            onFavoriteToggle: _toggleFavorite,
            disclosureLevel: widget.disclosureLevel,
          ),

        const SizedBox(height: 16),
      ],
    );
  }

  /// Handle bookmark selection
  void _handleBookmarkSelected(Bookmark bookmark) {
    if (widget.onBookmarkSelected != null) {
      widget.onBookmarkSelected!(bookmark);
    }
  }

  /// Create a new bookmark
  Future<void> _createBookmark(BuildContext context) async {
    // Show a dialog to create a bookmark
    // This will be implemented in a separate file
    final newBookmark = await showDialog<Bookmark>(
      context: context,
      builder: (context) => const Text('Bookmark Dialog Placeholder'),
    );

    if (newBookmark != null) {
      await _bookmarkService.addBookmark(newBookmark);
      setState(() {});
    }
  }

  /// Edit an existing bookmark
  Future<void> _editBookmark(BuildContext context, Bookmark bookmark) async {
    // Show a dialog to edit a bookmark
    // This will be implemented in a separate file
    final editedBookmark = await showDialog<Bookmark>(
      context: context,
      builder: (context) => const Text('Bookmark Edit Dialog Placeholder'),
    );

    if (editedBookmark != null) {
      await _bookmarkService.updateBookmark(bookmark.id, editedBookmark);
      setState(() {});
    }
  }

  /// Delete a bookmark with confirmation
  Future<void> _deleteBookmark(BuildContext context, Bookmark bookmark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
      await _bookmarkService.removeBookmark(bookmark.id);
      setState(() {});
    }
  }

  /// Toggle a bookmark's favorite status
  Future<void> _toggleFavorite(Bookmark bookmark) async {
    await _bookmarkService.toggleFavorite(bookmark.id);
    setState(() {});
  }

  /// Export bookmarks to JSON
  Future<void> _exportBookmarks(BuildContext context) async {
    try {
      final jsonData = await _bookmarkService.exportBookmarks();

      // In a real app, this would trigger a file download
      // For now, just show the JSON in a dialog for demonstration
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting bookmarks: $e')),
      );
    }
  }

  /// Import bookmarks from JSON
  Future<void> _importBookmarks(BuildContext context) async {
    final controller = TextEditingController();

    final jsonData = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
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
        await _bookmarkService.importBookmarks(jsonData);
        setState(() {});
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

/// Style configuration for bookmark sidebar
class BookmarkSidebarStyle {
  /// Width when sidebar is collapsed
  final double collapsedWidth;

  /// Width when sidebar is expanded
  final double expandedWidth;

  /// Background color for the sidebar
  final Color backgroundColor;

  /// Background color for the header
  final Color headerBackgroundColor;

  /// Text style for the header
  final TextStyle headerTextStyle;

  /// Text style for category titles
  final TextStyle categoryTitleStyle;

  /// Text style for category counts
  final TextStyle categoryCountStyle;

  /// Color for icons
  final Color iconColor;

  /// Padding for the header
  final EdgeInsets headerPadding;

  /// Padding for the search bar
  final EdgeInsets searchBarPadding;

  /// Padding for action buttons
  final EdgeInsets buttonsPadding;

  /// Padding for content area
  final EdgeInsets contentPadding;

  /// Padding for category headers
  final EdgeInsets categoryHeaderPadding;

  /// Constructor
  const BookmarkSidebarStyle({
    required this.collapsedWidth,
    required this.expandedWidth,
    required this.backgroundColor,
    required this.headerBackgroundColor,
    required this.headerTextStyle,
    required this.categoryTitleStyle,
    required this.categoryCountStyle,
    required this.iconColor,
    required this.headerPadding,
    required this.searchBarPadding,
    required this.buttonsPadding,
    required this.contentPadding,
    required this.categoryHeaderPadding,
  });

  /// Create style from theme
  factory BookmarkSidebarStyle.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return BookmarkSidebarStyle(
      collapsedWidth: 50,
      expandedWidth: 300,
      backgroundColor:
          colorScheme.surfaceContainer.withValues(alpha: 128), // ~0.5 opacity
      headerBackgroundColor: colorScheme.surfaceContainerHighest,
      headerTextStyle: theme.textTheme.titleMedium!.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      categoryTitleStyle: theme.textTheme.titleSmall!.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      categoryCountStyle: theme.textTheme.bodySmall!.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      iconColor: colorScheme.primary,
      headerPadding: const EdgeInsets.all(16.0),
      searchBarPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      buttonsPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      contentPadding: const EdgeInsets.only(bottom: 16.0),
      categoryHeaderPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
    );
  }
}
