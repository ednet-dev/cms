part of ednet_core_flutter;

/// Enum defining different visualization modes for entity collections
enum EntityViewMode {
  /// List-based layout with detailed items
  list,

  /// Card-based grid layout
  cards,

  /// Table-based structured layout with columns
  table,

  /// Graph visualization showing relationships
  graph,

  /// Timeline showing chronological data
  timeline,
}

/// A comprehensive entity collection viewer with multiple visualization modes,
/// responsive layouts, and semantic rendering capabilities.
class SemanticEntityCollectionView extends StatefulWidget {
  /// The entities to display
  final Iterable<Entity> entities;

  /// Optional callback when an entity is selected
  final Function(Entity entity)? onEntitySelected;

  /// Optional callback when an entity is bookmarked
  final Function(Entity entity)? onEntityBookmarked;

  /// Optional function to customize how entities are sorted
  final int Function(Entity a, Entity b)? sortComparator;

  /// Optional filter to apply to the collection
  final bool Function(Entity entity)? filter;

  /// Optional grouping function to organize entities
  final String Function(Entity entity)? groupBy;

  /// The default view mode (cards, table, graph, timeline)
  final EntityViewMode initialViewMode;

  /// Whether to allow changing view modes
  final bool allowViewModeChange;

  /// Show a grid layout instead of a list on larger screens
  final bool useGridOnLargeScreens;

  /// Grid column count for desktop and larger screens
  final int gridColumns;

  /// Optional ScrollController to use instead of the internal one
  final ScrollController? scrollController;

  /// Whether to disable internal scrolling (when parent handles scrolling)
  final bool disableScrolling;

  /// The disclosure level for progressive UI
  final DisclosureLevel disclosureLevel;

  /// Whether to show entity attributes in preview
  final bool showAttributes;

  /// Maximum attributes to show in preview
  final int maxAttributesInPreview;

  /// Constructor for SemanticEntityCollectionView
  const SemanticEntityCollectionView({
    super.key,
    required this.entities,
    this.onEntitySelected,
    this.onEntityBookmarked,
    this.sortComparator,
    this.filter,
    this.groupBy,
    this.initialViewMode = EntityViewMode.list,
    this.allowViewModeChange = true,
    this.useGridOnLargeScreens = true,
    this.gridColumns = 2,
    this.scrollController,
    this.disableScrolling = false,
    this.disclosureLevel = DisclosureLevel.standard,
    this.showAttributes = true,
    this.maxAttributesInPreview = 3,
  });

  @override
  State<SemanticEntityCollectionView> createState() =>
      _SemanticEntityCollectionViewState();
}

class _SemanticEntityCollectionViewState
    extends State<SemanticEntityCollectionView> {
  late EntityViewMode _currentViewMode;
  late List<Entity> _displayedEntities;
  late Map<String, List<Entity>> _groupedEntities;

  // Create controller in initState
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _currentViewMode = widget.initialViewMode;
    _prepareData();

    // Use the provided controller or create our own if needed
    _scrollController = widget.scrollController;
    if (_scrollController == null && !widget.disableScrolling) {
      _scrollController = ScrollController();
    }
  }

  @override
  void didUpdateWidget(SemanticEntityCollectionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entities != widget.entities ||
        oldWidget.filter != widget.filter ||
        oldWidget.sortComparator != widget.sortComparator ||
        oldWidget.groupBy != widget.groupBy) {
      _prepareData();
    }

    // Handle scroll controller changes
    if (oldWidget.scrollController != widget.scrollController) {
      if (_scrollController != null &&
          _scrollController != oldWidget.scrollController) {
        _scrollController!.dispose();
      }

      _scrollController = widget.scrollController;
      if (_scrollController == null && !widget.disableScrolling) {
        _scrollController = ScrollController();
      }
    }
  }

  @override
  void dispose() {
    // Only dispose if we created our own controller
    if (_scrollController != null && widget.scrollController == null) {
      _scrollController!.dispose();
    }
    super.dispose();
  }

  void _prepareData() {
    // Start with all entities
    _displayedEntities = widget.entities.toList();

    // Apply filter if provided
    if (widget.filter != null) {
      _displayedEntities = _displayedEntities.where(widget.filter!).toList();
    }

    // Apply sorting if provided
    if (widget.sortComparator != null) {
      _displayedEntities.sort(widget.sortComparator!);
    }

    // Group entities if grouping function is provided
    _groupedEntities = <String, List<Entity>>{};

    if (widget.groupBy != null) {
      for (var entity in _displayedEntities) {
        final group = widget.groupBy!(entity);
        if (!_groupedEntities.containsKey(group)) {
          _groupedEntities[group] = [];
        }
        _groupedEntities[group]!.add(entity);
      }
    } else {
      // Group by concept if no custom grouping
      for (var entity in _displayedEntities) {
        final conceptCode = entity.concept.code;
        if (!_groupedEntities.containsKey(conceptCode)) {
          _groupedEntities[conceptCode] = [];
        }
        _groupedEntities[conceptCode]!.add(entity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedEntities.isEmpty) {
      return _buildEmptyState();
    }

    // Build the main view based on the current mode
    return Column(
      children: [
        // Show view mode controls if allowed
        if (widget.allowViewModeChange) _buildViewModeSelector(),

        // Main content
        Expanded(
          child: _buildEntitiesView(),
        ),
      ],
    );
  }

  Widget _buildViewModeSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(
            isSelected: EntityViewMode.values
                .map((mode) => mode == _currentViewMode)
                .toList(),
            onPressed: (index) {
              setState(() {
                _currentViewMode = EntityViewMode.values[index];
              });
            },
            children: [
              _buildViewModeButton(
                  EntityViewMode.list, Icons.view_list, 'List'),
              _buildViewModeButton(
                  EntityViewMode.cards, Icons.grid_view, 'Cards'),
              _buildViewModeButton(
                  EntityViewMode.table, Icons.table_chart, 'Table'),
              _buildViewModeButton(
                  EntityViewMode.graph, Icons.account_tree, 'Graph'),
              _buildViewModeButton(
                  EntityViewMode.timeline, Icons.timeline, 'Timeline'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(
      EntityViewMode mode, IconData icon, String label) {
    return Tooltip(
      message: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Icon(icon),
      ),
    );
  }

  Widget _buildEntitiesView() {
    // Select the view implementation based on current mode
    switch (_currentViewMode) {
      case EntityViewMode.list:
        return _buildListView();
      case EntityViewMode.cards:
        return _buildCardView();
      case EntityViewMode.table:
        return _buildTableView();
      case EntityViewMode.graph:
        return _buildGraphView();
      case EntityViewMode.timeline:
        return _buildTimelineView();
    }
  }

  Widget _buildListView() {
    final screenCategory = _getScreenCategory(context);
    final isLargeScreen =
        screenCategory.index >= ScreenSizeCategory.desktop.index;

    // If we should use grid on large screens and this is a large screen
    if (widget.useGridOnLargeScreens && isLargeScreen) {
      return _buildCardView();
    }

    // Choose between grouped list or flat list
    return widget.groupBy != null
        ? _buildGroupedListView()
        : _buildFlatListView();
  }

  Widget _buildGroupedListView() {
    final ScrollPhysics physics = widget.disableScrolling
        ? const NeverScrollableScrollPhysics()
        : const AlwaysScrollableScrollPhysics();

    return ListView.builder(
      controller: _scrollController,
      physics: physics,
      itemCount: _groupedEntities.keys.length,
      itemBuilder: (context, groupIndex) {
        final groupName = _groupedEntities.keys.elementAt(groupIndex);
        final entitiesInGroup = _groupedEntities[groupName] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                groupName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Entities in this group
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entitiesInGroup.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entity = entitiesInGroup[index];
                return _buildEntityListItem(entity);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlatListView() {
    final ScrollPhysics physics = widget.disableScrolling
        ? const NeverScrollableScrollPhysics()
        : const AlwaysScrollableScrollPhysics();

    return ListView.separated(
      controller: _scrollController,
      physics: physics,
      itemCount: _displayedEntities.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entity = _displayedEntities[index];
        return _buildEntityListItem(entity);
      },
    );
  }

  Widget _buildEntityListItem(Entity entity) {
    // Determine if this entity is special
    final isConcept = entity.concept.code.toLowerCase().contains('concept');
    final isAggregateRoot = entity.concept.entry;

    // Use the DomainListItem.forEntity factory for rich rendering
    return DomainListItem.forEntity(
      entity: entity,
      onTap: widget.onEntitySelected != null
          ? () => widget.onEntitySelected!(entity)
          : null,
      onSecondaryAction: widget.onEntityBookmarked != null
          ? () => widget.onEntityBookmarked!(entity)
          : null,
      secondaryActionIcon:
          widget.onEntityBookmarked != null ? Icons.bookmark_border : null,
      subtitle: _getEntitySubtitle(entity),
      importance: isAggregateRoot ? 0.8 : (isConcept ? 0.7 : 0.5),
      disclosureLevel: widget.disclosureLevel,
    );
  }

  Widget _buildCardView() {
    // Responsive grid layout
    return GridView.builder(
      controller: _scrollController,
      physics: widget.disableScrolling
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getGridColumnCount(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      padding: const EdgeInsets.all(16),
      itemCount: _displayedEntities.length,
      itemBuilder: (context, index) {
        final entity = _displayedEntities[index];
        return _buildEntityCard(entity);
      },
    );
  }

  int _getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return widget.gridColumns;
    if (width > 800) return widget.gridColumns - 1;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildEntityCard(Entity entity) {
    return DomainEntityCard.forEntity(
      entity: entity,
      onTap: widget.onEntitySelected != null
          ? () => widget.onEntitySelected!(entity)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            _getEntityDisplayName(entity),
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Show attributes if enabled
          if (widget.showAttributes) _buildEntityAttributes(entity),

          // Actions row at bottom
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onEntityBookmarked != null)
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () => widget.onEntityBookmarked!(entity),
                  tooltip: 'Bookmark',
                ),
              if (widget.onEntitySelected != null)
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => widget.onEntitySelected!(entity),
                  tooltip: 'View Details',
                ),
            ],
          ),
        ],
      ),
      disclosureLevel: widget.disclosureLevel,
    );
  }

  Widget _buildEntityAttributes(Entity entity) {
    final attributes = _getPrioritizedAttributes(entity);
    final displayAttributes =
        attributes.take(widget.maxAttributesInPreview).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayAttributes
          .map((attr) => _buildAttributeRow(entity, attr))
          .toList(),
    );
  }

  Widget _buildAttributeRow(Entity entity, Property attribute) {
    final value = entity.getAttribute(attribute.code);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${attribute.code}: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not set',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder for table view - implement based on needs
  Widget _buildTableView() {
    return Center(
      child: Text(
        'Table view coming soon',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  // Placeholder for graph view - implement based on needs
  Widget _buildGraphView() {
    return Center(
      child: Text(
        'Graph view coming soon',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  // Placeholder for timeline view - implement based on needs
  Widget _buildTimelineView() {
    return Center(
      child: Text(
        'Timeline view coming soon',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No entities available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'There are no items to display in this collection',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getEntityDisplayName(Entity entity) {
    // Try to find identifier attribute
    for (final attr in entity.concept.attributes) {
      if (attr.identifier == true) {
        final value = entity.getAttribute(attr.code);
        if (value != null) {
          return value.toString();
        }
      }
    }

    // If no identifier, use the name attribute
    final nameValue = entity.getAttribute('name');
    if (nameValue != null) {
      return nameValue.toString();
    }

    // Last resort is entity toString or OID
    return entity.toString();
  }

  String _getEntitySubtitle(Entity entity) {
    // Show a description attribute if available
    final descValue = entity.getAttribute('description');
    if (descValue != null) {
      return descValue.toString();
    }

    // Alternative attributes that could serve as subtitle
    final alternatives = ['summary', 'info', 'detail', 'type'];
    for (final attrName in alternatives) {
      final value = entity.getAttribute(attrName);
      if (value != null) {
        return value.toString();
      }
    }

    // Default to concept code
    return entity.concept.code;
  }

  List<Property> _getPrioritizedAttributes(Entity entity) {
    final attributes = entity.concept.attributes.toList();

    // Group by importance (identifier first, then others)
    final identifierAttrs = <Property>[];
    final otherAttrs = <Property>[];

    for (final attr in attributes) {
      if (attr.identifier == true) {
        identifierAttrs.add(attr);
      } else {
        otherAttrs.add(attr);
      }
    }

    // Prioritize based on common attribute names
    final priorityNames = ['name', 'title', 'description', 'code', 'id'];
    otherAttrs.sort((a, b) {
      final aIndex = priorityNames.indexOf(a.code.toLowerCase());
      final bIndex = priorityNames.indexOf(b.code.toLowerCase());

      if (aIndex >= 0 && bIndex >= 0) return aIndex - bIndex;
      if (aIndex >= 0) return -1;
      if (bIndex >= 0) return 1;

      return a.code.compareTo(b.code);
    });

    return [...identifierAttrs, ...otherAttrs];
  }

  ScreenSizeCategory _getScreenCategory(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1400) return ScreenSizeCategory.ultraWide;
    if (width >= 1200) return ScreenSizeCategory.largeDesktop;
    if (width >= 900) return ScreenSizeCategory.desktop;
    if (width >= 600) return ScreenSizeCategory.tablet;
    return ScreenSizeCategory.mobile;
  }
}
