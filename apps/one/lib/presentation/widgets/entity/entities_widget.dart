import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'bookmark_manager.dart';
import 'entity_collection_view.dart';

/// Widget for displaying a collection of entities
class EntitiesWidget extends StatefulWidget {
  /// The entities to display
  final Entities entities;

  /// Optional callback when an entity is selected
  final void Function(Entity entity)? onEntitySelected;

  /// Optional bookmark manager to create bookmarks from entities
  final BookmarkManager? bookmarkManager;

  /// Optional callback when a bookmark is created
  final void Function(Bookmark bookmark)? onBookmarkCreated;

  /// Constructor for EntitiesWidget
  const EntitiesWidget({
    super.key,
    required this.entities,
    this.onEntitySelected,
    this.bookmarkManager,
    this.onBookmarkCreated,
  });

  @override
  State<EntitiesWidget> createState() => _EntitiesWidgetState();
}

class _EntitiesWidgetState extends State<EntitiesWidget> {
  late ViewMode _currentViewMode;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _currentViewMode = ViewMode.cards;
  }

  // Filter entities based on search query
  bool _filterEntity(dynamic entity) {
    if (_searchQuery == null || _searchQuery!.isEmpty) {
      return true;
    }

    final query = _searchQuery!.toLowerCase();
    final entityObj = entity as Entity;

    // Check entity code
    if (entityObj.code.toLowerCase().contains(query)) {
      return true;
    }

    // Check concept
    try {
      if (entityObj.concept.code.toLowerCase().contains(query)) {
        return true;
      }
    } catch (e) {
      // If we can't access concept, just continue
    }

    // Check common attributes
    try {
      for (var attrCode in ['name', 'title', 'description', 'id']) {
        final value = entityObj.getAttribute(attrCode);
        if (value != null && value.toString().toLowerCase().contains(query)) {
          return true;
        }
      }
    } catch (e) {
      // If we can't access attributes, just continue
    }

    return false;
  }

  // Group entities by concept
  String _groupByConceptCode(dynamic entity) {
    final entityObj = entity as Entity;
    try {
      return entityObj.concept.code;
    } catch (e) {
      return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search entities...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLowest,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        // Entity collection view
        Expanded(
          child: EntityCollectionView(
            entities: widget.entities,
            viewMode: _currentViewMode,
            onEntitySelected: widget.onEntitySelected,
            filter: _filterEntity,
            groupBy: _groupByConceptCode,
          ),
        ),
      ],
    );
  }
}
