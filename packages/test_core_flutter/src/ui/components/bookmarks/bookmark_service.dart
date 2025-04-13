part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Service responsible for managing bookmarks in the Shell Architecture
///
/// This service provides the following functionality:
/// - Storing and retrieving bookmarks
/// - Organizing bookmarks by category
/// - Searching and filtering bookmarks
/// - Persistence to SharedPreferences
/// - Integration with the Shell navigation system
/// - Messaging via UX Channels for bookmark changes
class BookmarkService extends ChangeNotifier {
  static const String _bookmarkKey = 'shell_bookmarks';

  /// UX channel for bookmark-related messages
  final UXChannel _bookmarkChannel = UXChannel(
    'bookmark_channel',
    name: 'Bookmark Message Channel',
  );

  /// In-memory cache of bookmarks
  List<Bookmark> _bookmarks = [];

  /// Flag indicating if bookmarks have been loaded from storage
  bool _isLoaded = false;

  /// Navigation service reference for location-based bookmarking
  final ShellNavigationService? _navigationService;

  /// Static singleton instance
  static final BookmarkService _instance = BookmarkService._internal();

  /// Factory constructor that returns a singleton instance
  factory BookmarkService({ShellNavigationService? navigationService}) {
    _instance._setupNavigationService(navigationService);
    return _instance;
  }

  /// Private constructor for singleton pattern
  BookmarkService._internal() : _navigationService = null {
    _setupMessageHandlers();
  }

  /// Set up the navigation service reference
  void _setupNavigationService(ShellNavigationService? navigationService) {
    if (navigationService != null) {
      // Set navigation service if provided
    }
  }

  /// Set up handlers for bookmark-related messages
  void _setupMessageHandlers() {
    _bookmarkChannel.onUXMessageType('add_bookmark', (message) async {
      final bookmarkData = message.payload['bookmark'] as Map<String, dynamic>;
      final bookmark = Bookmark.fromJson(bookmarkData);
      await addBookmark(bookmark);
    });

    _bookmarkChannel.onUXMessageType('remove_bookmark', (message) async {
      final id = message.payload['id'] as String;
      await removeBookmark(id);
    });

    _bookmarkChannel.onUXMessageType('update_bookmark', (message) async {
      final id = message.payload['id'] as String;
      final bookmarkData = message.payload['bookmark'] as Map<String, dynamic>;
      final bookmark = Bookmark.fromJson(bookmarkData);
      await updateBookmark(id, bookmark);
    });

    _bookmarkChannel.onUXMessageType('toggle_favorite', (message) async {
      final id = message.payload['id'] as String;
      await toggleFavorite(id);
    });

    _bookmarkChannel.onUXMessageType('clear_bookmarks', (message) async {
      await clearAllBookmarks();
    });
  }

  /// Get the bookmark UX channel
  UXChannel get bookmarkChannel => _bookmarkChannel;

  /// Get all bookmarks
  Future<List<Bookmark>> getBookmarks() async {
    if (!_isLoaded) {
      await _loadBookmarks();
    }
    return _bookmarks;
  }

  /// Add a new bookmark
  Future<void> addBookmark(Bookmark bookmark) async {
    if (!_isLoaded) await _loadBookmarks();

    // Check if bookmark with same URL already exists
    final existingIndex = _bookmarks.indexWhere((b) => b.url == bookmark.url);
    if (existingIndex != -1) {
      // Replace existing bookmark
      _bookmarks[existingIndex] = bookmark;
    } else {
      // Add new bookmark
      _bookmarks.add(bookmark);
    }

    await _saveBookmarks();

    // Send message about the new bookmark
    _sendBookmarkMessage('bookmark_added', {
      'bookmark': bookmark.toJson(),
    });
  }

  /// Update an existing bookmark
  Future<void> updateBookmark(String id, Bookmark updatedBookmark) async {
    if (!_isLoaded) await _loadBookmarks();

    final index = _bookmarks.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookmarks[index] = updatedBookmark;
      await _saveBookmarks();

      // Send message about the updated bookmark
      _sendBookmarkMessage('bookmark_updated', {
        'bookmark': updatedBookmark.toJson(),
      });
    }
  }

  /// Remove a bookmark by ID
  Future<void> removeBookmark(String id) async {
    if (!_isLoaded) await _loadBookmarks();

    final bookmark = await getBookmarkById(id);
    if (bookmark != null) {
      _bookmarks.removeWhere((b) => b.id == id);
      await _saveBookmarks();

      // Send message about the removed bookmark
      _sendBookmarkMessage('bookmark_removed', {
        'id': id,
        'bookmark': bookmark.toJson(),
      });
    }
  }

  /// Get bookmarks filtered by category
  Future<List<Bookmark>> getBookmarksByCategory(
    BookmarkCategory category,
  ) async {
    final allBookmarks = await getBookmarks();
    return allBookmarks
        .where((bookmark) => bookmark.category == category)
        .toList();
  }

  /// Search bookmarks using a text query
  Future<List<Bookmark>> searchBookmarks(String searchTerm) async {
    if (searchTerm.isEmpty) return getBookmarks();

    final allBookmarks = await getBookmarks();
    final lowerSearch = searchTerm.toLowerCase();

    return allBookmarks.where((bookmark) {
      return bookmark.title.toLowerCase().contains(lowerSearch) ||
          (bookmark.description?.toLowerCase().contains(lowerSearch) ?? false);
    }).toList();
  }

  /// Get a specific bookmark by ID
  Future<Bookmark?> getBookmarkById(String id) async {
    if (!_isLoaded) await _loadBookmarks();

    try {
      return _bookmarks.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Toggle a bookmark's favorite status
  Future<void> toggleFavorite(String id) async {
    if (!_isLoaded) await _loadBookmarks();

    final index = _bookmarks.indexWhere((b) => b.id == id);
    if (index != -1) {
      final bookmark = _bookmarks[index];
      final newCategory = bookmark.category == BookmarkCategory.favorite
          ? BookmarkCategory.general
          : BookmarkCategory.favorite;

      _bookmarks[index] = bookmark.copyWith(category: newCategory);
      await _saveBookmarks();

      // Send message about the favorite status change
      _sendBookmarkMessage('bookmark_favorite_toggled', {
        'id': id,
        'isFavorite': newCategory == BookmarkCategory.favorite,
      });
    }
  }

  /// Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    _bookmarks = [];
    await _saveBookmarks();

    // Send message about clearing all bookmarks
    _sendBookmarkMessage('bookmarks_cleared', {});
  }

  /// Export bookmarks to JSON
  Future<String> exportBookmarks() async {
    if (!_isLoaded) await _loadBookmarks();

    final bookmarkList =
        _bookmarks.map((bookmark) => bookmark.toJson()).toList();
    return json.encode(bookmarkList);
  }

  /// Import bookmarks from JSON
  Future<void> importBookmarks(String jsonData) async {
    try {
      final List<dynamic> bookmarkList = json.decode(jsonData);
      final importedBookmarks = bookmarkList
          .map((item) => Bookmark.fromJson(item as Map<String, dynamic>))
          .toList();

      if (!_isLoaded) await _loadBookmarks();

      // Add imported bookmarks
      for (final bookmark in importedBookmarks) {
        final existingIndex = _bookmarks.indexWhere(
          (b) => b.url == bookmark.url,
        );
        if (existingIndex != -1) {
          _bookmarks[existingIndex] = bookmark;
        } else {
          _bookmarks.add(bookmark);
        }
      }

      await _saveBookmarks();

      // Send message about importing bookmarks
      _sendBookmarkMessage('bookmarks_imported', {
        'count': importedBookmarks.length,
      });
    } catch (e) {
      debugPrint('Error importing bookmarks: $e');
      rethrow;
    }
  }

  /// Create a bookmark for the current location
  Future<Bookmark?> bookmarkCurrentLocation({
    String? title,
    String? description,
    BookmarkCategory category = BookmarkCategory.general,
  }) async {
    if (_navigationService == null) return null;

    final location = _navigationService!.currentLocation;
    // Get the current parameters but not using them directly in this implementation

    // Get active breadcrumb for title if not provided
    final activeItem = _navigationService!.breadcrumbService.activeBreadcrumb;
    final effectiveTitle = title ?? activeItem?.label ?? 'Unnamed Location';

    // Create the bookmark
    final bookmark = Bookmark(
      title: effectiveTitle,
      url: location,
      category: category,
      description: description,
      // Additional metadata could be added from parameters
    );

    // Save the bookmark
    await addBookmark(bookmark);
    return bookmark;
  }

  /// Load bookmarks from SharedPreferences
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings = prefs.getStringList(_bookmarkKey);

    if (bookmarkStrings == null) {
      _bookmarks = [];
    } else {
      _bookmarks = bookmarkStrings
          .map((bookmarkJson) {
            try {
              final Map<String, dynamic> bookmarkMap = json.decode(
                bookmarkJson,
              );
              return Bookmark.fromJson(bookmarkMap);
            } catch (e) {
              debugPrint('Error parsing bookmark: $e');
              return null;
            }
          })
          .whereType<Bookmark>()
          .toList();
    }

    _isLoaded = true;
  }

  /// Save bookmarks to SharedPreferences
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings =
        _bookmarks.map((bookmark) => json.encode(bookmark.toJson())).toList();

    await prefs.setStringList(_bookmarkKey, bookmarkStrings);
    notifyListeners();
  }

  /// Send a bookmark-related message on the UX channel
  void _sendBookmarkMessage(String type, Map<String, dynamic> payload) {
    _bookmarkChannel.sendUXMessage(UXMessage.create(
      type: type,
      payload: {
        ...payload,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      source: 'bookmark_service',
    ));
  }
}
