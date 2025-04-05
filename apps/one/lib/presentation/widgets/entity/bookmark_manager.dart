import 'dart:convert';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A bookmark entity representing a saved reference to an entity
class Bookmark extends Entity<Bookmark> {
  /// The bookmark title
  String? title;

  /// The URL path to the bookmarked entity
  String url;

  /// Constructor for Bookmark
  Bookmark({this.title, required this.url});

  @override
  String toString() {
    return title ?? 'Unnamed Bookmark: $url';
  }
}

/// Manager for handling bookmark operations
class BookmarkManager {
  static const String _bookmarkKey = 'bookmarks';

  /// Get all bookmarks
  Future<List<Bookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkStrings = prefs.getStringList(_bookmarkKey);
    if (bookmarkStrings == null) return [];

    return bookmarkStrings.map((bookmarkJson) {
      final bookmark = Map<String, dynamic>.from(json.decode(bookmarkJson));
      return Bookmark(url: bookmark['url'], title: bookmark['title']);
    }).toList();
  }

  /// Add a bookmark
  Future<void> addBookmark(Bookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.add(bookmark);
    await prefs.setStringList(
      _bookmarkKey,
      bookmarks
          .map(
            (bookmark) =>
                json.encode({'url': bookmark.url, 'title': bookmark.title}),
          )
          .toList(),
    );
  }

  /// Remove a bookmark by URL
  Future<void> removeBookmark(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((bookmark) => bookmark.url == url);
    await prefs.setStringList(
      _bookmarkKey,
      bookmarks
          .map(
            (bookmark) =>
                json.encode({'url': bookmark.url, 'title': bookmark.title}),
          )
          .toList(),
    );
  }
}
