import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import '../semantic_concept_container.dart';
import '../../theme/providers/theme_provider.dart';
import '../../theme/extensions/theme_spacing.dart';

import 'entity_widget.dart';

import 'dart:math';

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

  /// Optional ScrollController to use instead of the internal one
  final ScrollController? scrollController;

  /// Whether to disable internal scrolling (when parent handles scrolling)
  final bool disableScrolling;

  /// The constructor for EntityCollectionView
  const EntityCollectionView({
    super.key,
    required this.entities,
    this.viewMode = ViewMode.cards,
    this.onEntitySelected,
    this.sortComparator,
    this.filter,
    this.groupBy,
    this.scrollController,
    this.disableScrolling = false,
  });

  @override
  State<EntityCollectionView> createState() => _EntityCollectionViewState();
}

class _EntityCollectionViewState extends State<EntityCollectionView> {
  late ViewMode _currentViewMode;
  late List<dynamic> _displayedEntities;
  late Map<String, List<dynamic>> _groupedEntities;

  // Create controller in initState instead
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _currentViewMode = widget.viewMode;
    _prepareData();

    // Use the provided controller or create our own
    _scrollController = widget.scrollController ?? ScrollController();
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

  @override
  void dispose() {
    // Only dispose if we created our own controller
    if (widget.scrollController == null) {
      _scrollController.dispose();
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

    // Access the current screen size and orientation
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final bool isWideScreen = screenSize.width > 1200;

    // Dynamic layout based on available space
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate container role
        final String containerRole = _determineContainerRole(constraints);

        // Determine if this should be a workspace container
        final bool isFullWorkspace =
            isWideScreen || constraints.maxHeight > 600;

        // Determine layout type based on size and role
        if (isLandscape && isFullWorkspace) {
          // Full workspace layout (expansive UI)
          return _buildExpandedWorkspace(context, containerRole);
        } else if (isLandscape) {
          // Side-by-side compact layout
          return _buildSideBySideLayout(context);
        } else {
          // Vertical stack layout (most minimal)
          return _buildVerticalStackLayout(context);
        }
      },
    );
  }

  // Determine container role based on constraints and content
  String _determineContainerRole(BoxConstraints constraints) {
    // Default role is viewer
    String role = 'viewer';

    // Large height suggests a primary workspace
    if (constraints.maxHeight > 600) {
      role = 'primary-workspace';
    }
    // Medium height suggests a secondary workspace
    else if (constraints.maxHeight > 400) {
      role = 'secondary-workspace';
    }
    // Small height suggests a sidebar or supplemental role
    else if (constraints.maxHeight > 200) {
      role = 'sidebar';
    }

    return role;
  }

  // Build expanded workspace with contextual panels
  Widget _buildExpandedWorkspace(BuildContext context, String role) {
    return SemanticConceptContainer(
      conceptType: 'Workspace',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main content area (70%)
          Expanded(
            flex: 7,
            child: Column(
              children: [
                // Controls at the top
                _buildViewControls(context),

                // Content area with scrolling
                Expanded(child: _buildContent()),
              ],
            ),
          ),

          // Optional secondary panel (30%) for supplemental content
          // Only show if we're in a primary workspace
          if (role == 'primary-workspace')
            Expanded(
              flex: 3,
              child: SemanticConceptContainer(
                conceptType: 'InfoPanel',
                padding: EdgeInsets.all(context.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collection Details',
                      style: context.conceptTextStyle(
                        'InfoPanel',
                        role: 'title',
                      ),
                    ),
                    SizedBox(height: context.spacingM),
                    // Collection stats
                    _buildCollectionStats(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build collection stats widget
  Widget _buildCollectionStats() {
    final String conceptType =
        _displayedEntities.isNotEmpty
            ? (_displayedEntities.first as Entity).concept.code
            : 'Unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow('Total Items', '${_displayedEntities.length}'),
        _buildStatRow('Type', conceptType),
        _buildStatRow('Groups', '${_groupedEntities.length}'),
        _buildStatRow('View', firstLetterUpper(_currentViewMode.name)),
      ],
    );
  }

  // Helper to build stat row
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacingS),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(width: context.spacingS),
          Text(value),
        ],
      ),
    );
  }

  // Build side-by-side compact layout
  Widget _buildSideBySideLayout(BuildContext context) {
    return Column(
      children: [
        // Controls at the top
        _buildViewControls(context),

        // Main content with side-by-side layout if space permits
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                // Side-by-side layout
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // List/navigation panel
                    SizedBox(
                      width: 300,
                      child: SemanticConceptContainer(
                        conceptType: 'EntityList',
                        padding: EdgeInsets.all(context.spacingS),
                        child: _buildEntityList(),
                      ),
                    ),

                    // Vertical divider
                    VerticalDivider(width: 1),

                    // Main content area
                    Expanded(child: _buildContent()),
                  ],
                );
              } else {
                // Single panel when width is limited
                return _buildContent();
              }
            },
          ),
        ),
      ],
    );
  }

  // Build vertical stack (most minimal layout)
  Widget _buildVerticalStackLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Controls at the top (compact for mobile)
        _buildViewControls(context),

        // Content area with fixed or expanding height
        Expanded(child: _buildContent()),
      ],
    );
  }

  // Simple entity list for navigation panel
  Widget _buildEntityList() {
    return ListView(
      children:
          _displayedEntities.map((item) {
            final Entity entity = item as Entity;
            final String title = EntityTitleUtils.getTitle(entity);

            return ListTile(
              title: Text(title, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                entity.concept.code,
                style: TextStyle(fontSize: 12),
              ),
              leading: Icon(context.conceptIcon(entity.concept.code)),
              onTap: () => widget.onEntitySelected?.call(entity),
            );
          }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return SemanticConceptContainer(
      conceptType: 'EmptyState',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: context.conceptColor('EmptyState'),
            ),
            const SizedBox(height: 16),
            Text(
              'No entities available',
              style: context.conceptTextStyle('EmptyState', role: 'title'),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no items to display in this collection',
              style: context.conceptTextStyle(
                'EmptyState',
                role: 'description',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewControls(BuildContext context) {
    // Get theme colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingM,
        vertical: context.spacingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Collection info with badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacingS,
              vertical: context.spacingXs,
            ),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(context.spacingXs),
            ),
            child: Row(
              children: [
                Icon(Icons.data_object, size: 16, color: primaryColor),
                SizedBox(width: context.spacingXs),
                Text(
                  '${_displayedEntities.length} ${_displayedEntities.length == 1 ? 'entity' : 'entities'}',
                  style: context
                      .conceptTextStyle('ControlBar', role: 'info')
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
            ),
          ),

          // Compact view mode toggle
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(context.spacingXs),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildViewModeButton(ViewMode.cards, Icons.grid_view, 'Cards'),
                _buildViewModeButton(
                  ViewMode.table,
                  Icons.table_chart,
                  'Table',
                ),
                _buildViewModeButton(
                  ViewMode.graph,
                  Icons.account_tree,
                  'Graph',
                ),
                _buildViewModeButton(
                  ViewMode.timeline,
                  Icons.timeline,
                  'Timeline',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build view mode buttons
  Widget _buildViewModeButton(ViewMode mode, IconData icon, String tooltip) {
    final bool isSelected = _currentViewMode == mode;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          setState(() {
            _currentViewMode = mode;
          });
        },
        borderRadius: BorderRadius.circular(context.spacingXs),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacingS,
            vertical: context.spacingXs,
          ),
          decoration: BoxDecoration(
            color:
                isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(context.spacingXs),
          ),
          child: Icon(
            icon,
            size: 18,
            color:
                isSelected
                    ? primaryColor
                    : Theme.of(context).iconTheme.color?.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Define content for current view mode
    Widget Function() contentBuilder;
    String conceptType;

    switch (_currentViewMode) {
      case ViewMode.cards:
        contentBuilder = () => _buildCardsView();
        conceptType = 'CardCollection';
        break;
      case ViewMode.table:
        contentBuilder = () => _buildTableView();
        conceptType = 'TableCollection';
        break;
      case ViewMode.graph:
        contentBuilder = () => _buildGraphView();
        conceptType = 'GraphCollection';
        break;
      case ViewMode.timeline:
        contentBuilder = () => _buildTimelineView();
        conceptType = 'TimelineCollection';
        break;
    }

    // Wrap with SemanticConceptContainer
    Widget semanticContent = SemanticConceptContainer(
      conceptType: conceptType,
      child: contentBuilder(),
    );

    // Handle scrolling based on disableScrolling property and controller availability
    if (widget.disableScrolling) {
      // When parent handles scrolling, just return the content directly
      return semanticContent;
    } else {
      // Determine if we need PrimaryScrollController or our own
      final bool usePrimaryController = widget.scrollController == null;

      // Use correct ScrollController
      return Builder(
        builder: (context) {
          // Get the primary controller if needed and available
          final ScrollController effectiveController =
              widget.scrollController ?? _scrollController;

          // Wrap with scrollable and scrollbar
          return Scrollbar(
            controller: effectiveController,
            thumbVisibility: true,
            radius: const Radius.circular(8),
            thickness: 6,
            child: SingleChildScrollView(
              controller: effectiveController,
              primary: usePrimaryController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: semanticContent,
            ),
          );
        },
      );
    }
  }

  Widget _buildCardsView() {
    // Direct non-scrollable content container with ResponsiveGridView
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children:
          _groupedEntities.entries.map((entry) {
            final groupName = entry.key;
            final entities = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group header if we have multiple groups
                if (_groupedEntities.length > 1)
                  SemanticConceptContainer(
                    conceptType: 'GroupHeader',
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacingM,
                      vertical: context.spacingS,
                    ),
                    child: Text(
                      groupName,
                      style: context.conceptTextStyle(
                        'GroupHeader',
                        role: 'title',
                      ),
                    ),
                  ),

                // Responsive card grid with fixed height per row
                SemanticConceptContainer(
                  conceptType: 'CardGrid',
                  padding: EdgeInsets.all(context.spacingM),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double availableWidth = constraints.maxWidth;

                      // Responsive column calculation:
                      // - Small screens: 1 column (<600px)
                      // - Medium screens: 2 columns (600-900px)
                      // - Large screens: 3 columns (>900px)
                      int columns;
                      if (availableWidth < 600) {
                        columns = 1;
                      } else if (availableWidth < 900) {
                        columns = 2;
                      } else {
                        columns = 3;
                      }

                      // Fixed minimum card width and height
                      final double minCardWidth = 280.0;
                      final double itemSpacing = context.itemSpacing;

                      // Calculate card width (with a minimum)
                      final double cardWidth = max(
                        minCardWidth,
                        (availableWidth - (itemSpacing * (columns - 1))) /
                            columns,
                      );

                      // Fixed height for cards (aspect ratio)
                      final double cardHeight = cardWidth * 0.65;

                      return Wrap(
                        spacing: itemSpacing,
                        runSpacing: itemSpacing,
                        alignment: WrapAlignment.start,
                        children:
                            entities.map((entity) {
                              return SizedBox(
                                width: cardWidth,
                                height: cardHeight,
                                child: _buildEntityCard(entity as Entity),
                              );
                            }).toList(),
                      );
                    },
                  ),
                ),

                // Add spacing between groups
                if (_groupedEntities.length > 1)
                  SizedBox(height: context.sectionSpacing),
              ],
            );
          }).toList(),
    );
  }

  // Helper for building individual entity cards with modern design
  Widget _buildEntityCard(Entity entity) {
    // Get concept type
    String conceptType;
    try {
      conceptType = entity.concept.code;
    } catch (e) {
      conceptType = 'Entity';
    }

    // Get the entity title
    final String title = EntityTitleUtils.getTitle(entity);

    // Get color based on concept
    final Color primaryColor = context.conceptColor(conceptType);
    final Color bgColor = Theme.of(context).cardColor;
    final Color borderColor = primaryColor.withOpacity(0.3);

    // Modern card with sharper contours
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onEntitySelected?.call(entity),
        borderRadius: BorderRadius.circular(context.spacingS),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(context.spacingS),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colored header with title
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacingM,
                  vertical: context.spacingS,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(color: borderColor, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      context.conceptIcon(conceptType),
                      size: 18,
                      color: primaryColor,
                    ),
                    SizedBox(width: context.spacingS),
                    Expanded(
                      child: Text(
                        title,
                        style: context
                            .conceptTextStyle(conceptType, role: 'title')
                            .copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Tag/badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacingS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(context.spacingXs),
                      ),
                      child: Text(
                        entity.concept.code,
                        style: context
                            .conceptTextStyle(conceptType, role: 'label')
                            .copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Attribute content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(context.spacingM),
                  child: _buildEntityPreview(entity),
                ),
              ),
            ],
          ),
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
    // Modern attribute row with better styling
    return Container(
      margin: EdgeInsets.only(bottom: context.spacingXs),
      padding: EdgeInsets.symmetric(vertical: context.spacingXs),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Attribute name with emphasis
          Text(
            '$name:',
            style: context
                .conceptTextStyle('Attribute', role: 'name')
                .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          SizedBox(width: context.spacingS),

          // Attribute value
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: context
                  .conceptTextStyle('Attribute', role: 'value')
                  .copyWith(fontSize: 12),
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
    return SemanticConceptContainer(
      conceptType: 'Placeholder',
      child: Center(
        child: Card(
          margin: EdgeInsets.all(context.spacingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.spacingS),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.spacingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.table_chart,
                  size: 48,
                  color: context.conceptColor('Primary'),
                ),
                SizedBox(height: context.spacingM),
                Text(
                  'Table View Coming Soon',
                  style: context.conceptTextStyle('Placeholder', role: 'title'),
                ),
                SizedBox(height: context.spacingS),
                Text(
                  'This feature is under development',
                  style: context.conceptTextStyle(
                    'Placeholder',
                    role: 'description',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraphView() {
    // Placeholder for graph view
    return SemanticConceptContainer(
      conceptType: 'Placeholder',
      child: Center(
        child: Card(
          margin: EdgeInsets.all(context.spacingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.spacingS),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.spacingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_tree,
                  size: 48,
                  color: context.conceptColor('Primary'),
                ),
                SizedBox(height: context.spacingM),
                Text(
                  'Graph View Coming Soon',
                  style: context.conceptTextStyle('Placeholder', role: 'title'),
                ),
                SizedBox(height: context.spacingS),
                Text(
                  'Visual relationship mapping is under development',
                  style: context.conceptTextStyle(
                    'Placeholder',
                    role: 'description',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineView() {
    // Placeholder for timeline view
    return SemanticConceptContainer(
      conceptType: 'Placeholder',
      child: Center(
        child: Card(
          margin: EdgeInsets.all(context.spacingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.spacingS),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.spacingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timeline,
                  size: 48,
                  color: context.conceptColor('Primary'),
                ),
                SizedBox(height: context.spacingM),
                Text(
                  'Timeline View Coming Soon',
                  style: context.conceptTextStyle('Placeholder', role: 'title'),
                ),
                SizedBox(height: context.spacingS),
                Text(
                  'Chronological visualization is under development',
                  style: context.conceptTextStyle(
                    'Placeholder',
                    role: 'description',
                  ),
                ),
              ],
            ),
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
