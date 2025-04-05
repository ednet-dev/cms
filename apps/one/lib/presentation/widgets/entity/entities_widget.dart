import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'bookmark_manager.dart';
import 'entity_widget.dart';

/// Widget for displaying a list of entities with optional filtering
class EntitiesWidget extends StatefulWidget {
  /// The entities to display
  final Entities entities;

  /// Callback when an entity is selected
  final void Function(Entity entity) onEntitySelected;

  /// Bookmark manager for saving bookmarks
  final BookmarkManager bookmarkManager;

  /// Callback when a bookmark is created
  final void Function(Bookmark bookmark) onBookmarkCreated;

  /// Constructor for EntitiesWidget
  const EntitiesWidget({
    super.key,
    required this.entities,
    required this.onEntitySelected,
    required this.bookmarkManager,
    required this.onBookmarkCreated,
  });

  @override
  _EntitiesWidgetState createState() => _EntitiesWidgetState();
}

class _EntitiesWidgetState extends State<EntitiesWidget> {
  final List<FilterCriteria> _filters = [];
  List<Entity> _filteredEntities = [];

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _applyFilters();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreEntities();
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredEntities =
          widget.entities.where((entity) {
                for (final filter in _filters) {
                  if (!_matchesFilter(entity as Entity, filter)) {
                    return false;
                  }
                }
                return true;
              }).toList()
              as List<Entity>;
    });
  }

  bool _matchesFilter(Entity entity, FilterCriteria filter) {
    // Simplified filter logic - could be expanded based on your needs
    return true;
  }

  void _loadMoreEntities() {
    // Implement logic to load more entities if available
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredEntities.length,
      itemBuilder: (context, index) {
        final entity = _filteredEntities[index];
        return ListTile(
          title: Text(EntityTitleUtils.getTitle(entity)),
          subtitle: Text(entity.concept.code),
          onTap: () {
            widget.onEntitySelected(entity);
          },
        );
      },
    );
  }
}
