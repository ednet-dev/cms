import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import 'entity_widget.dart';

/// Enum defining different visualization modes for entity collections
enum ViewMode {
  /// Card-based grid layout
  cards,

  /// Table-based structured layout with columns
  table,

  /// Graph visualization showing relationships
  graph,

  /// Timeline showing chronological data
  timeline,
}

/// Widget for displaying collections of entities with multiple visualization options
class EntityCollectionView extends StatefulWidget {
  /// The collection of entities to display
  final Entities entities;

  /// The current view mode (cards, table, graph, timeline)
  final ViewMode viewMode;

  /// Optional callback when an entity is selected
  final Function(Entity entity)? onEntitySelected;

  /// Optional function to customize how entities are sorted
  final int Function(dynamic a, dynamic b)? sortComparator;

  /// Optional filter to apply to the collection
  final bool Function(dynamic entity)? filter;

  /// Optional grouping function to organize entities
  final String Function(dynamic entity)? groupBy;

  /// The constructor for EntityCollectionView
  const EntityCollectionView({
    super.key,
    required this.entities,
    this.viewMode = ViewMode.cards,
    this.onEntitySelected,
    this.sortComparator,
    this.filter,
    this.groupBy,
  });

  @override
  State<EntityCollectionView> createState() => _EntityCollectionViewState();
}

class _EntityCollectionViewState extends State<EntityCollectionView> {
  late ViewMode _currentViewMode;
  late List<dynamic> _displayedEntities;
  late Map<String, List<dynamic>> _groupedEntities;

  @override
  void initState() {
    super.initState();
    _currentViewMode = widget.viewMode;
    _prepareData();
  }

  @override
  void didUpdateWidget(EntityCollectionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entities != widget.entities ||
        oldWidget.filter != widget.filter ||
        oldWidget.sortComparator != widget.sortComparator ||
        oldWidget.groupBy != widget.groupBy) {
      _prepareData();
    }

    _currentViewMode = widget.viewMode;
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
    _groupedEntities = <String, List<dynamic>>{};

    if (widget.groupBy != null) {
      for (var entity in _displayedEntities) {
        final group = widget.groupBy!(entity);
        if (!_groupedEntities.containsKey(group)) {
          _groupedEntities[group] = [];
        }
        _groupedEntities[group]!.add(entity);
      }
    } else {
      // Single group if no grouping function
      _groupedEntities = {'All': _displayedEntities};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedEntities.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // View mode toggle and controls
        _buildViewControls(context),

        // Main content area
        Expanded(child: _buildContent()),
      ],
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
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 255.0 * 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No entities available',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 255.0 * 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no items to display in this collection',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 255.0 * 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewControls(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Collection info
          Text(
            '${_displayedEntities.length} ${_displayedEntities.length == 1 ? 'entity' : 'entities'}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 255.0 * 0.7),
            ),
          ),

          const Spacer(),

          // View mode toggle buttons
          SegmentedButton<ViewMode>(
            segments: const [
              ButtonSegment(
                value: ViewMode.cards,
                icon: Icon(Icons.grid_view),
                label: Text('Cards'),
              ),
              ButtonSegment(
                value: ViewMode.table,
                icon: Icon(Icons.table_chart),
                label: Text('Table'),
              ),
              ButtonSegment(
                value: ViewMode.graph,
                icon: Icon(Icons.account_tree),
                label: Text('Graph'),
              ),
              ButtonSegment(
                value: ViewMode.timeline,
                icon: Icon(Icons.timeline),
                label: Text('Timeline'),
              ),
            ],
            selected: {_currentViewMode},
            onSelectionChanged: (selected) {
              if (selected.isNotEmpty) {
                setState(() {
                  _currentViewMode = selected.first;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Select the appropriate visualization based on view mode
    switch (_currentViewMode) {
      case ViewMode.cards:
        return _buildCardsView();
      case ViewMode.table:
        return _buildTableView();
      case ViewMode.graph:
        return _buildGraphView();
      case ViewMode.timeline:
        return _buildTimelineView();
    }
  }

  Widget _buildCardsView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              _groupedEntities.entries.map((entry) {
                final groupName = entry.key;
                final entities = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group header if we have multiple groups
                    if (_groupedEntities.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                        child: Text(
                          groupName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                    // Card grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: entities.length,
                      itemBuilder: (context, index) {
                        final entity = entities[index] as Entity;
                        return InkWell(
                          onTap: () => widget.onEntitySelected?.call(entity),
                          child: Card(
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and concept
                                  Row(
                                    children: [
                                      Icon(
                                        _getIconForEntityType(
                                          entity.concept.code,
                                        ),
                                        size: 20,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          EntityTitleUtils.getTitle(entity),
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Concept badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      entity.concept.code,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),
                                  const Divider(),

                                  // Preview of important attributes
                                  Expanded(child: _buildEntityPreview(entity)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildEntityPreview(Entity entity) {
    final attributes = <Widget>[];

    // Try to show important attributes first
    try {
      // Get identifier attributes
      final identifierAttributes = entity.concept.identifierAttributes;

      // Get essential attributes (if defined in the concept)
      final essentialAttributes = entity.concept.essentialAttributes;

      // First show up to 2 identifier attributes
      for (var attribute in identifierAttributes.take(2)) {
        final value = entity.getAttribute(attribute.code);
        if (value != null) {
          attributes.add(_buildAttributeRow(attribute.code, value.toString()));
        }
      }

      // Then show up to 3 essential attributes (excluding identifiers)
      for (var attribute in essentialAttributes
          .where((a) => !identifierAttributes.contains(a))
          .take(3)) {
        final value = entity.getAttribute(attribute.code);
        if (value != null) {
          attributes.add(_buildAttributeRow(attribute.code, value.toString()));
        }
      }

      // If we don't have at least 3 attributes yet, show some non-identifier attributes
      if (attributes.length < 3) {
        final regularAttributes = entity.concept.attributes
            .whereType<Attribute>()
            .where((a) => !identifierAttributes.contains(a))
            .take(5 - attributes.length);

        for (var attribute in regularAttributes) {
          final value = entity.getAttribute(attribute.code);
          if (value != null) {
            attributes.add(
              _buildAttributeRow(attribute.code, value.toString()),
            );
          }
        }
      }
    } catch (e) {
      // If there's an error accessing the concept structure,
      // just show the entity code
      attributes.add(_buildAttributeRow('code', entity.code));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          attributes.isNotEmpty
              ? attributes
              : [_buildAttributeRow('(No attributes)', '')],
    );
  }

  Widget _buildAttributeRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 255.0 * 0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView() {
    // For now, we'll just show a placeholder implementation
    // The full implementation would involve creating a data table with
    // columns based on the entity concept's attributes
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.table_chart,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Table View Coming Soon',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This feature is under development',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphView() {
    // Placeholder for graph view
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_tree,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Graph View Coming Soon',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Visual relationship mapping is under development',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineView() {
    // Placeholder for timeline view
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timeline,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Timeline View Coming Soon',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Chronological visualization is under development',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to get an appropriate icon based on entity type
  IconData _getIconForEntityType(String type) {
    // Map common entity types to appropriate icons
    switch (type.toLowerCase()) {
      case 'user':
      case 'person':
      case 'customer':
      case 'employee':
        return Icons.person;
      case 'product':
      case 'item':
        return Icons.shopping_bag;
      case 'project':
      case 'task':
        return Icons.assignment;
      case 'document':
      case 'file':
        return Icons.description;
      case 'message':
      case 'comment':
        return Icons.message;
      case 'event':
      case 'meeting':
        return Icons.event;
      case 'location':
      case 'place':
        return Icons.location_on;
      case 'organization':
      case 'company':
        return Icons.business;
      case 'role':
        return Icons.assignment_ind;
      case 'status':
        return Icons.info;
      case 'theme':
        return Icons.palette;
      case 'application':
        return Icons.apps;
      case 'model':
        return Icons.schema;
      case 'concept':
        return Icons.category;
      case 'domain':
        return Icons.domain;
      default:
        return Icons.data_object;
    }
  }
}
