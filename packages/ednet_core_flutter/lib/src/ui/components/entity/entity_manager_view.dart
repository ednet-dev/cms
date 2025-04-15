part of ednet_core_flutter;

/// A unified component that manages entity listing, creation, editing, and deletion
/// for a specific concept.
///
/// This component integrates the various visualization components and forms
/// into a cohesive interface, providing consistent navigation and interaction patterns.
class EntityManagerView extends StatefulWidget {
  /// The shell app instance
  final ShellApp shellApp;

  /// The concept code to manage entities for
  final String conceptCode;

  /// Initial view mode for entity collection
  final EntityViewMode initialViewMode;

  /// Whether to allow changing view mode
  final bool allowViewModeChange;

  /// Whether to show FAB for entity creation
  final bool showCreateFab;

  /// Optional custom actions for the app bar
  final List<Widget>? appBarActions;

  /// Optional custom title for the app bar
  final String? appBarTitle;

  /// Optional disclosure level override
  final DisclosureLevel? disclosureLevel;

  /// Constructor
  const EntityManagerView({
    Key? key,
    required this.shellApp,
    required this.conceptCode,
    this.initialViewMode = EntityViewMode.list,
    this.allowViewModeChange = true,
    this.showCreateFab = true,
    this.appBarActions,
    this.appBarTitle,
    this.disclosureLevel,
  }) : super(key: key);

  @override
  State<EntityManagerView> createState() => _EntityManagerViewState();
}

class _EntityManagerViewState extends State<EntityManagerView> {
  /// The concept we're managing
  Concept? _concept;

  /// Collection of entities
  List<Map<String, dynamic>> _entities = [];

  /// Loading status
  bool _isLoading = true;

  /// Error message if any
  String? _errorMessage;

  /// Current view mode
  late EntityViewMode _viewMode;

  @override
  void initState() {
    super.initState();
    _viewMode = widget.initialViewMode;
    _initializeConcept();
    _loadEntities();
  }

  @override
  void didUpdateWidget(EntityManagerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conceptCode != widget.conceptCode) {
      _initializeConcept();
      _loadEntities();
    }
  }

  /// Initialize the concept from the code
  void _initializeConcept() {
    // Find the concept in the domain
    _concept = widget.shellApp._findConcept(widget.conceptCode);
    if (_concept == null) {
      setState(() {
        _errorMessage = 'Concept "${widget.conceptCode}" not found in domain';
        _isLoading = false;
      });
    }
  }

  /// Load entities from the persistence layer
  Future<void> _loadEntities() async {
    if (_concept == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load entities from the shell app
      final entities = await widget.shellApp.loadEntities(widget.conceptCode);

      setState(() {
        _entities = entities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading entities: $e';
        _isLoading = false;
      });
    }
  }

  /// Create a new entity
  Future<void> _createEntity() async {
    if (_concept == null) return;

    // Navigate to entity creation form using extension method
    final result = await widget.shellApp.showEntityCreator(
      context,
      widget.conceptCode,
      disclosureLevel:
          widget.disclosureLevel ?? widget.shellApp.currentDisclosureLevel,
    );

    // Reload entities if entity was created successfully
    if (result == true) {
      _loadEntities();
    }
  }

  /// Edit an existing entity
  Future<void> _editEntity(Map<String, dynamic> entity) async {
    if (_concept == null) return;

    // Navigate to entity edit form using extension method
    final result = await widget.shellApp.showEntityEditor(
      context,
      widget.conceptCode,
      entity,
      disclosureLevel:
          widget.disclosureLevel ?? widget.shellApp.currentDisclosureLevel,
    );

    // Reload entities if entity was updated successfully
    if (result == true) {
      _loadEntities();
    }
  }

  /// Delete an entity
  Future<void> _deleteEntity(Map<String, dynamic> entity) async {
    if (_concept == null) return;

    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this entity?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) return;

    // Delete entity
    try {
      final success = await widget.shellApp.deleteEntity(
        widget.conceptCode,
        entity,
      );

      if (success) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entity deleted successfully')),
          );
        }

        // Reload entities
        _loadEntities();
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete entity')),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting entity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle ?? 'Manage ${widget.conceptCode}'),
        actions: [
          // View mode toggle
          if (widget.allowViewModeChange)
            IconButton(
              icon: Icon(_getViewModeIcon()),
              tooltip: 'Toggle view mode',
              onPressed: _toggleViewMode,
            ),

          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadEntities,
          ),

          // Custom actions
          if (widget.appBarActions != null) ...widget.appBarActions!,
        ],
      ),
      body: _buildBody(),
      floatingActionButton: widget.showCreateFab
          ? FloatingActionButton(
              onPressed: _createEntity,
              tooltip: 'Create ${widget.conceptCode}',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Get the icon for the current view mode
  IconData _getViewModeIcon() {
    switch (_viewMode) {
      case EntityViewMode.list:
        return Icons.grid_view;
      case EntityViewMode.cards:
        return Icons.view_list;
      case EntityViewMode.table:
        return Icons.table_chart;
      case EntityViewMode.graph:
        return Icons.account_tree;
      case EntityViewMode.timeline:
        return Icons.timeline;
      default:
        return Icons.grid_view;
    }
  }

  /// Toggle between view modes
  void _toggleViewMode() {
    setState(() {
      // Cycle through view modes
      switch (_viewMode) {
        case EntityViewMode.list:
          _viewMode = EntityViewMode.cards;
          break;
        case EntityViewMode.cards:
          _viewMode = EntityViewMode.table;
          break;
        case EntityViewMode.table:
          _viewMode = EntityViewMode.graph;
          break;
        case EntityViewMode.graph:
          _viewMode = EntityViewMode.timeline;
          break;
        case EntityViewMode.timeline:
          _viewMode = EntityViewMode.list;
          break;
      }
    });
  }

  /// Build the main body based on state
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_concept == null) {
      return const Center(child: Text('Concept not found'));
    }

    if (_entities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No entities found'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadEntities,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    // Choose the appropriate view based on mode
    switch (_viewMode) {
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
      default:
        return _buildListView();
    }
  }

  /// Build list view of entities
  Widget _buildListView() {
    return ListView.builder(
      itemCount: _entities.length,
      itemBuilder: (context, index) {
        final entity = _entities[index];
        return ListTile(
          title: Text(_getEntityTitle(entity)),
          subtitle: Text(_getEntitySubtitle(entity)),
          onTap: () => _editEntity(entity),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteEntity(entity),
          ),
        );
      },
    );
  }

  /// Build card view of entities
  Widget _buildCardView() {
    // Get responsive grid column count based on width
    int columnCount = _getResponsiveColumnCount(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _entities.length,
        itemBuilder: (context, index) {
          final entity = _entities[index];
          return _buildEntityCard(entity);
        },
      ),
    );
  }

  /// Build an individual entity card
  Widget _buildEntityCard(Map<String, dynamic> entity) {
    // Extract top attributes for display
    final displayAttributes = _getDisplayAttributes(entity);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: primaryColor.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => _editEntity(entity),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                _getEntityTitle(entity),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12.0),

              // Attributes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: displayAttributes.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key}:',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              _formatAttributeValue(entry.value),
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20.0),
                    onPressed: () => _editEntity(entity),
                    tooltip: 'Edit',
                    color: primaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20.0),
                    onPressed: () => _deleteEntity(entity),
                    tooltip: 'Delete',
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get the optimal number of columns based on screen width
  int _getResponsiveColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 960) return 2;
    if (width < 1280) return 3;
    return 4;
  }

  /// Get a map of key attributes to display on the card
  Map<String, dynamic> _getDisplayAttributes(Map<String, dynamic> entity) {
    final result = <String, dynamic>{};

    // If we have a concept, get attributes from it
    if (_concept != null) {
      // First add essential attributes
      for (var attribute in _concept!.essentialAttributes) {
        if (entity.containsKey(attribute.code) &&
            attribute.code != _getPrimaryAttributeCode()) {
          result[attribute.code] = entity[attribute.code];
          if (result.length >= 3) break; // Limit to top 3 essential attributes
        }
      }

      // If we have space, add non-essential attributes
      if (result.length < 3) {
        for (var attribute in _concept!.attributes.whereType<Attribute>()) {
          if (!attribute.essential &&
              entity.containsKey(attribute.code) &&
              attribute.code != _getPrimaryAttributeCode()) {
            result[attribute.code] = entity[attribute.code];
            if (result.length >= 3) break; // Limit to top 3 attributes total
          }
        }
      }
    }

    // Fallback if we couldn't determine attributes from the concept
    if (result.isEmpty) {
      // Add up to 3 attributes that aren't the primary attribute
      final primaryAttribute = _getPrimaryAttributeCode();
      int count = 0;

      entity.forEach((key, value) {
        if (key != primaryAttribute &&
            key != 'id' &&
            key != 'oid' &&
            count < 3) {
          result[key] = value;
          count++;
        }
      });
    }

    return result;
  }

  /// Format attribute value for display
  String _formatAttributeValue(dynamic value) {
    if (value == null) return 'N/A';
    if (value is bool) return value ? 'Yes' : 'No';
    if (value is DateTime) {
      return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
    }
    return value.toString();
  }

  /// Get the primary attribute code to use as title
  String _getPrimaryAttributeCode() {
    if (_concept == null) return 'id';

    // Check for title, name, or code attributes
    final commonTitleAttributes = ['title', 'name', 'code'];
    for (final attrCode in commonTitleAttributes) {
      if (_concept!.attributes.any((attr) => attr.code == attrCode)) {
        return attrCode;
      }
    }

    // Fall back to first identifier attribute
    final identifiers = _concept!.identifierAttributes;
    if (identifiers.isNotEmpty) {
      return identifiers.first.code;
    }

    // Fall back to first attribute
    if (_concept!.attributes.isNotEmpty) {
      return _concept!.attributes.first.code;
    }

    return 'id';
  }

  /// Build table view of entities
  Widget _buildTableView() {
    // TODO: Implement table view
    return const Center(child: Text('Table view not implemented yet'));
  }

  /// Build graph view of entities
  Widget _buildGraphView() {
    // TODO: Implement graph view
    return const Center(child: Text('Graph view not implemented yet'));
  }

  /// Build timeline view of entities
  Widget _buildTimelineView() {
    // TODO: Implement timeline view
    return const Center(child: Text('Timeline view not implemented yet'));
  }

  /// Get entity title for display
  String _getEntityTitle(Map<String, dynamic> entity) {
    // Try to use a common title attribute
    final commonTitleAttributes = ['title', 'name', 'code'];
    for (final attr in commonTitleAttributes) {
      if (entity.containsKey(attr) && entity[attr] != null) {
        return entity[attr].toString();
      }
    }

    // Try to use the first attribute
    if (entity.isNotEmpty) {
      final firstKey = entity.keys.first;
      return entity[firstKey].toString();
    }

    // Fallback
    return 'Entity ${entity['id'] ?? ''}';
  }

  /// Get entity subtitle for display
  String _getEntitySubtitle(Map<String, dynamic> entity) {
    // Use the second attribute as subtitle, skipping the title
    final title = _getEntityTitle(entity);
    final keys = entity.keys
        .where((k) => entity[k].toString() != title && k != 'id' && k != 'oid')
        .toList();

    if (keys.isNotEmpty) {
      return '${keys[0]}: ${entity[keys[0]]}';
    }

    return '';
  }
}
