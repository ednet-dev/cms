import 'dart:convert';
import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'bookmark_model.dart';
import '../filters/filter_criteria.dart';

/// Manager for handling bookmark operations with enhanced functionality
class BookmarkManager extends ChangeNotifier {
  static const String _bookmarkKey = 'enhanced_bookmarks';

  // In-memory cache of bookmarks
  List<Bookmark> _bookmarks = [];
  bool _isLoaded = false;

  /// Get all bookmarks
  Future<List<Bookmark>> getBookmarks() async {
    if (!_isLoaded) {
      await _loadBookmarks();
    }
    return _bookmarks;
  }

  /// Load bookmarks from storage
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings = prefs.getStringList(_bookmarkKey);

    if (bookmarkStrings == null) {
      _bookmarks = [];
    } else {
      _bookmarks =
          bookmarkStrings
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

  /// Save bookmarks to storage
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings =
        _bookmarks.map((bookmark) {
          return json.encode(bookmark.toJson());
        }).toList();

    await prefs.setStringList(_bookmarkKey, bookmarkStrings);
    notifyListeners();
  }

  /// Add a bookmark
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
  }

  /// Update a bookmark
  Future<void> updateBookmark(String id, Bookmark updatedBookmark) async {
    if (!_isLoaded) await _loadBookmarks();

    final index = _bookmarks.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookmarks[index] = updatedBookmark;
      await _saveBookmarks();
    }
  }

  /// Remove a bookmark by ID
  Future<void> removeBookmark(String id) async {
    if (!_isLoaded) await _loadBookmarks();

    _bookmarks.removeWhere((bookmark) => bookmark.id == id);
    await _saveBookmarks();
  }

  /// Get bookmarks by category
  Future<List<Bookmark>> getBookmarksByCategory(
    BookmarkCategory category,
  ) async {
    final allBookmarks = await getBookmarks();
    return allBookmarks
        .where((bookmark) => bookmark.category == category)
        .toList();
  }

  /// Search bookmarks using a string query
  Future<List<Bookmark>> searchBookmarks(String searchTerm) async {
    if (searchTerm.isEmpty) return await getBookmarks();

    final allBookmarks = await getBookmarks();
    final lowerSearch = searchTerm.toLowerCase();

    return allBookmarks.where((bookmark) {
      return bookmark.title.toLowerCase().contains(lowerSearch) ||
          (bookmark.description?.toLowerCase().contains(lowerSearch) ?? false);
    }).toList();
  }

  /// Search bookmarks using ednet_core FilterCriteria
  Future<List<Bookmark>> filterBookmarks(List<FilterCriteria> criteria) async {
    if (criteria.isEmpty) return await getBookmarks();

    final allBookmarks = await getBookmarks();

    return allBookmarks.where((bookmark) {
      // Apply all criteria (AND logic)
      return criteria.every((filterCriteria) {
        final attribute = filterCriteria.field.toLowerCase();
        final value = filterCriteria.value.toString().toLowerCase();

        switch (attribute) {
          case 'title':
            return _applyOperator(
              bookmark.title,
              filterCriteria.operator.name,
              value,
            );

          case 'url':
            return _applyOperator(
              bookmark.url,
              filterCriteria.operator.name,
              value,
            );

          case 'description':
            if (bookmark.description == null) return false;
            return _applyOperator(
              bookmark.description!,
              filterCriteria.operator.name,
              value,
            );

          case 'category':
            return _applyOperator(
              bookmark.category.name,
              filterCriteria.operator.name,
              value,
            );

          default:
            return false;
        }
      });
    }).toList();
  }

  /// Apply a filter operator to a string value
  bool _applyOperator(String fieldValue, String operator, String filterValue) {
    final lowerFieldValue = fieldValue.toLowerCase();

    switch (operator) {
      case '==':
        return lowerFieldValue == filterValue;
      case '!=':
        return lowerFieldValue != filterValue;
      case 'contains':
        return lowerFieldValue.contains(filterValue);
      case 'startsWith':
        return lowerFieldValue.startsWith(filterValue);
      case 'endsWith':
        return lowerFieldValue.endsWith(filterValue);
      default:
        return false;
    }
  }

  /// Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    _bookmarks = [];
    await _saveBookmarks();
  }

  /// Import bookmarks from JSON
  Future<void> importBookmarks(String jsonData) async {
    try {
      final List<dynamic> bookmarkList = json.decode(jsonData);
      final importedBookmarks =
          bookmarkList.map((item) {
            return Bookmark.fromJson(item);
          }).toList();

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
    } catch (e) {
      debugPrint('Error importing bookmarks: $e');
    }
  }

  /// Export bookmarks to JSON
  Future<String> exportBookmarks() async {
    if (!_isLoaded) await _loadBookmarks();

    final bookmarkList =
        _bookmarks.map((bookmark) => bookmark.toJson()).toList();
    return json.encode(bookmarkList);
  }

  /// Get total bookmark count
  Future<int> getBookmarkCount() async {
    final bookmarks = await getBookmarks();
    return bookmarks.length;
  }

  /// Move a bookmark to a different category
  Future<void> moveBookmarkToCategory(
    String id,
    BookmarkCategory category,
  ) async {
    if (!_isLoaded) await _loadBookmarks();

    final index = _bookmarks.indexWhere((b) => b.id == id);
    if (index != -1) {
      final updatedBookmark = _bookmarks[index].copyWith(category: category);
      _bookmarks[index] = updatedBookmark;
      await _saveBookmarks();
    }
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

  /// Add bookmark to favorites (moves to favorite category)
  Future<void> toggleFavorite(String id) async {
    if (!_isLoaded) await _loadBookmarks();

    final index = _bookmarks.indexWhere((b) => b.id == id);
    if (index != -1) {
      final bookmark = _bookmarks[index];
      final newCategory =
          bookmark.category == BookmarkCategory.favorite
              ? BookmarkCategory.general
              : BookmarkCategory.favorite;

      _bookmarks[index] = bookmark.copyWith(category: newCategory);
      await _saveBookmarks();
    }
  }
}
