import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:flutter/material.dart';

/// Enhanced Bookmark class with additional metadata
class Bookmark {
  /// Unique identifier for the bookmark
  final String id;

  /// The bookmark title
  final String title;

  /// The URL path to the bookmarked entity
  final String url;

  /// Optional category for grouping bookmarks
  final BookmarkCategory category;

  /// When the bookmark was created
  final DateTime createdAt;

  /// The icon to display with this bookmark
  final IconData? icon;

  /// Optional description
  final String? description;

  /// Optional domain information
  final ednet.Domain? domain;

  /// Optional model information
  final ednet.Model? model;

  /// Optional concept information
  final ednet.Concept? concept;

  /// Optional entity information
  final dynamic entity;

  /// Constructor for Bookmark
  Bookmark({
    String? id,
    required this.title,
    required this.url,
    this.category = BookmarkCategory.general,
    DateTime? createdAt,
    this.icon,
    this.description,
    this.domain,
    this.model,
    this.concept,
    this.entity,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  /// Create a copy of this bookmark with specified attributes changed
  Bookmark copyWith({
    String? title,
    String? url,
    BookmarkCategory? category,
    IconData? icon,
    String? description,
  }) {
    return Bookmark(
      id: id,
      title: title ?? this.title,
      url: url ?? this.url,
      category: category ?? this.category,
      createdAt: createdAt,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      domain: domain,
      model: model,
      concept: concept,
      entity: entity,
    );
  }

  /// Convert bookmark to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'category': category.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'description': description,
      // We don't store the icon, domain, model, concept or entity
      // Those will be re-created from the URL when needed
    };
  }

  /// Create bookmark from JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      category: _categoryFromString(json['category']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      description: json['description'],
    );
  }

  /// Get a bookmark category from string
  static BookmarkCategory _categoryFromString(String? name) {
    if (name == null) return BookmarkCategory.general;

    return BookmarkCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => BookmarkCategory.general,
    );
  }

  /// Get appropriate icon based on category
  IconData get displayIcon {
    if (icon != null) return icon!;

    return category.icon;
  }

  @override
  String toString() => title;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bookmark && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Categories for bookmarks
enum BookmarkCategory {
  domain(Icons.domain, 'Domain'),
  model(Icons.model_training, 'Model'),
  concept(Icons.category, 'Concept'),
  entity(Icons.inventory_2, 'Entity'),
  general(Icons.bookmark, 'General'),
  favorite(Icons.favorite, 'Favorite'),
  recent(Icons.history, 'Recent');

  /// The icon for this category
  final IconData icon;

  /// Display name for this category
  final String displayName;

  const BookmarkCategory(this.icon, this.displayName);
}
