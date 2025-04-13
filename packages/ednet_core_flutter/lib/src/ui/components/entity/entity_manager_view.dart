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

    final success = await widget.shellApp.createEntity(
      context,
      widget.conceptCode,
      disclosureLevel:
          widget.disclosureLevel ?? widget.shellApp.currentDisclosureLevel,
      onSuccess: () {
        // Reload entities after successful creation
        _loadEntities();
      },
    );

    if (!success) {
      // Only show error message if not shown by createEntity method
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create entity')),
      );
    }
  }

  /// View entity details
  void _viewEntityDetails(Map<String, dynamic> entity) {
    if (_concept == null) return;

    // Create an entity object from the data
    final entityObj = EntityFactory.createEntityFromData(_concept!, entity);

    // Navigate to entity details
    widget.shellApp.navigateToEntity(entityObj);
  }

  /// Edit an entity
  Future<void> _editEntity(Map<String, dynamic> entity) async {
    if (_concept == null) return;

    // Create an entity object from the data
    final entityObj = EntityFactory.createEntityFromData(_concept!, entity);

    // Show edit form
    final result = await widget.shellApp.showEntityEditForm(
      context,
      entityObj,
      initialData: entity,
      disclosureLevel:
          widget.disclosureLevel ?? widget.shellApp.currentDisclosureLevel,
      onSaved: (data) async {
        // Update entity
        final success =
            await widget.shellApp.saveEntity(widget.conceptCode, data);
        if (success) {
          // Reload entities
          _loadEntities();

          // Close dialog
          Navigator.of(context).pop(true);
        }
      },
    );

    if (result != true) {
      // Edit was canceled or failed
      debugPrint('Entity edit canceled or failed');
    }
  }

  /// Delete an entity
  Future<void> _deleteEntity(Map<String, dynamic> entity) async {
    if (_concept == null) return;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entity'),
        content:
            Text('Are you sure you want to delete this ${_concept!.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // TODO: Implement actual delete functionality when ShellApp provides it
    // For now, we'll just show a message
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete functionality not implemented yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle ?? 'Manage ${widget.conceptCode}'),
        actions: widget.appBarActions,
      ),
      body: _buildBody(),
      floatingActionButton: widget.showCreateFab ? _buildCreateFab() : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(_errorMessage!,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEntities,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_entities.isEmpty) {
      return _buildEmptyState();
    }

    return _buildEntityCollection();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No ${widget.conceptCode} entities found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (widget.showCreateFab)
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text('Create ${widget.conceptCode}'),
              onPressed: _createEntity,
            ),
        ],
      ),
    );
  }

  Widget _buildEntityCollection() {
    // Convert data maps to entity objects
    final entities = _entities
        .map((e) => EntityFactory.createEntityFromData(_concept!, e))
        .toList();

    // Create a semantic entity collection view
    return SemanticEntityCollectionView(
      entities: entities,
      initialViewMode: _viewMode,
      allowViewModeChange: widget.allowViewModeChange,
      onEntitySelected: (entity) {
        // Find the corresponding data map
        final index = entities.indexOf(entity);
        if (index >= 0) {
          _viewEntityDetails(_entities[index]);
        }
      },
      onEntityBookmarked: (entity) {
        // Find the corresponding data map
        final index = entities.indexOf(entity);
        if (index >= 0) {
          _editEntity(_entities[index]);
        }
      },
      disclosureLevel:
          widget.disclosureLevel ?? widget.shellApp.currentDisclosureLevel,
      showAttributes: true,
      maxAttributesInPreview: _getAttributeCount(),
    );
  }

  Widget _buildCreateFab() {
    return FloatingActionButton(
      onPressed: _createEntity,
      tooltip: 'Create ${widget.conceptCode}',
      child: const Icon(Icons.add),
    );
  }

  /// Get appropriate attribute count based on disclosure level
  int _getAttributeCount() {
    final level =
        widget.disclosureLevel ?? widget.shellApp.currentDisclosureLevel;

    switch (level) {
      case DisclosureLevel.minimal:
        return 0;
      case DisclosureLevel.basic:
        return 1;
      case DisclosureLevel.standard:
        return 3;
      case DisclosureLevel.intermediate:
        return 5;
      case DisclosureLevel.advanced:
        return 7;
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        return 10;
    }
  }
}
