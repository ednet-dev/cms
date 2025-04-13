part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Bookmark categories to organize bookmarks
enum BookmarkCategory {
  domain(Icons.domain, 'Domain'),
  model(Icons.model_training, 'Model'),
  concept(Icons.category, 'Concept'),
  entity(Icons.inventory_2, 'Entity'),
  general(Icons.bookmark, 'General'),
  favorite(Icons.favorite, 'Favorite'),
  recent(Icons.history, 'Recent');

  /// Icon for this category
  final IconData icon;

  /// Display name for this category
  final String displayName;

  const BookmarkCategory(this.icon, this.displayName);
}

/// A bookmark that references entities or locations in the domain model
///
/// Bookmarks provide a way for users to save references to important
/// entities or views they want to return to later. Bookmarks can be
/// filtered by category and integrate with the navigation system.
class Bookmark with ProgressiveDisclosure {
  /// Unique identifier for this bookmark
  final String id;

  /// The display title of the bookmark
  final String title;

  /// The URL or path to the bookmarked item
  final String url;

  /// The category this bookmark belongs to
  final BookmarkCategory category;

  /// When the bookmark was created
  final DateTime createdAt;

  /// Icon to display with this bookmark
  final IconData? icon;

  /// Optional description of the bookmark
  final String? description;

  /// Optional reference to a domain
  final Domain? domain;

  /// Optional reference to a model
  final Model? model;

  /// Optional reference to a concept
  final Concept? concept;

  /// Optional reference to an entity
  final dynamic entity;

  /// The disclosure level at which this bookmark should be visible
  @override
  final DisclosureLevel disclosureLevel;

  /// Constructor
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
    this.disclosureLevel = DisclosureLevel.basic,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  /// Create a copy with modified properties
  Bookmark copyWith({
    String? title,
    String? url,
    BookmarkCategory? category,
    IconData? icon,
    String? description,
    DisclosureLevel? disclosureLevel,
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
      disclosureLevel: disclosureLevel ?? this.disclosureLevel,
    );
  }

  /// Display icon based on category or custom icon
  IconData get displayIcon => icon ?? category.icon;

  /// Serialize to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'category': category.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'description': description,
      'disclosureLevel': disclosureLevel.name,
      // Domain model entities are not serialized directly
    };
  }

  /// Create a bookmark from JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      category: _categoryFromString(json['category']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      description: json['description'],
      disclosureLevel: DisclosureLevel.values.firstWhere(
        (level) => level.name == json['disclosureLevel'],
        orElse: () => DisclosureLevel.basic,
      ),
    );
  }

  /// Helper to get category from string
  static BookmarkCategory _categoryFromString(String? name) {
    if (name == null) return BookmarkCategory.general;

    return BookmarkCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => BookmarkCategory.general,
    );
  }

  @override
  String toString() => title;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Bookmark && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
