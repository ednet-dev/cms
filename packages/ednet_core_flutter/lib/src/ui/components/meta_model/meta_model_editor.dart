part of ednet_core_flutter;

/// A comprehensive editor for EDNet meta-models supporting both entity instances
/// and meta model editing (concepts, attributes, etc.).
///
/// This component provides card-based visualization with CRUD operations for
/// domain models, concepts, attributes, and relationships.
class MetaModelEditor extends StatefulWidget {
  /// The shell app instance providing domain context
  final ShellApp shellApp;

  /// Optional specific domain to edit
  final Domain? domain;

  /// Optional specific model to edit
  final Model? model;

  /// Optional specific concept to edit
  final Concept? concept;

  /// Initial view mode for displaying models/concepts
  final EntityViewMode initialViewMode;

  /// Controls disclosure level for visualization
  final DisclosureLevel disclosureLevel;

  /// Whether to enable live editing capabilities
  final bool enableLiveEditing;

  /// Constructor
  const MetaModelEditor({
    Key? key,
    required this.shellApp,
    this.domain,
    this.model,
    this.concept,
    this.initialViewMode = EntityViewMode.cards,
    this.disclosureLevel = DisclosureLevel.standard,
    this.enableLiveEditing = true,
  }) : super(key: key);

  @override
  State<MetaModelEditor> createState() => _MetaModelEditorState();
}

class _MetaModelEditorState extends State<MetaModelEditor>
    with SingleTickerProviderStateMixin {
  /// Current domain being edited
  Domain? _activeDomain;

  /// Current model being edited
  Model? _activeModel;

  /// Current concept being edited
  Concept? _activeConcept;

  /// Current view mode
  late EntityViewMode _viewMode;

  /// Tab controller for navigation between editor sections
  late TabController _tabController;

  /// Search query for filtering
  String _searchQuery = '';

  /// Whether we're in edit mode
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _viewMode = widget.initialViewMode;
    _initializeEditor();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Initialize the editor with provided domain/model/concept
  void _initializeEditor() {
    setState(() {
      // Initialize active domain
      if (widget.domain != null) {
        _activeDomain = widget.domain;
      } else if (widget.shellApp.domain != null) {
        _activeDomain = widget.shellApp.domain;
      }

      // Initialize active model if domain is available
      if (_activeDomain != null) {
        if (widget.model != null) {
          _activeModel = widget.model;
        } else if (_activeDomain!.models.isNotEmpty) {
          _activeModel = _activeDomain!.models.first;
        }
      }

      // Initialize active concept if model is available
      if (_activeModel != null) {
        if (widget.concept != null) {
          _activeConcept = widget.concept;
        } else if (_activeModel!.concepts.isNotEmpty) {
          _activeConcept = _activeModel!.concepts.first;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_buildTitle()),
        actions: [
          // Toggle view mode
          IconButton(
            icon: Icon(_getViewModeIcon()),
            tooltip: 'Toggle view mode',
            onPressed: _toggleViewMode,
          ),

          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: _showSearchDialog,
          ),

          // Edit toggle
          if (widget.enableLiveEditing)
            IconButton(
              icon: Icon(_isEditing ? Icons.edit_off : Icons.edit),
              tooltip: _isEditing ? 'Exit edit mode' : 'Enter edit mode',
              onPressed: _toggleEditMode,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Domains'),
            Tab(text: 'Models'),
            Tab(text: 'Concepts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDomainView(),
          _buildModelView(),
          _buildConceptView(),
        ],
      ),
      floatingActionButton: widget.enableLiveEditing && _isEditing
          ? FloatingActionButton(
              onPressed: _addNewItem,
              tooltip: 'Add new item',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Build the title text based on active selections
  String _buildTitle() {
    if (_activeConcept != null) {
      return 'Concept: ${_activeConcept!.code}';
    } else if (_activeModel != null) {
      return 'Model: ${_activeModel!.code}';
    } else if (_activeDomain != null) {
      return 'Domain: ${_activeDomain!.code}';
    } else {
      return 'Meta Model Editor';
    }
  }

  /// Get icon for the current view mode
  IconData _getViewModeIcon() {
    switch (_viewMode) {
      case EntityViewMode.list:
        return Icons.grid_view;
      case EntityViewMode.cards:
        return Icons.view_list;
      case EntityViewMode.table:
        return Icons.table_chart;
      default:
        return Icons.grid_view;
    }
  }

  /// Toggle between view modes
  void _toggleViewMode() {
    setState(() {
      // Cycle through supported view modes
      switch (_viewMode) {
        case EntityViewMode.list:
          _viewMode = EntityViewMode.cards;
          break;
        case EntityViewMode.cards:
          _viewMode = EntityViewMode.table;
          break;
        case EntityViewMode.table:
          _viewMode = EntityViewMode.list;
          break;
        default:
          _viewMode = EntityViewMode.cards;
      }
    });
  }

  /// Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  /// Show search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter search term',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _searchQuery = '';
              });
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  /// Add a new item based on current tab
  void _addNewItem() {
    switch (_tabController.index) {
      case 0:
        _addNewDomain();
        break;
      case 1:
        _addNewModel();
        break;
      case 2:
        _addNewConcept();
        break;
    }
  }

  /// Add a new domain
  void _addNewDomain() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Domain'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Domain Code',
            hintText: 'Enter domain code (e.g., Customer)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement domain creation
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  /// Add a new model
  void _addNewModel() {
    if (_activeDomain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a domain first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Model'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Model Code',
            hintText: 'Enter model code (e.g., Order)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement model creation
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  /// Add a new concept
  void _addNewConcept() {
    if (_activeModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a model first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Concept'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Concept Code',
            hintText: 'Enter concept code (e.g., Customer)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement concept creation
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  /// Build the domain view
  Widget _buildDomainView() {
    final domains = widget.shellApp.domains;

    if (domains.isEmpty) {
      return const Center(
        child: Text('No domains available'),
      );
    }

    // Filter domains by search query if applicable
    final filteredDomains = _searchQuery.isEmpty
        ? domains
        : domains.where((d) =>
            d.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (d.description.toLowerCase().contains(_searchQuery.toLowerCase())));

    if (_viewMode == EntityViewMode.cards) {
      return _buildDomainCards(filteredDomains.toList());
    } else {
      return _buildDomainList(filteredDomains.toList());
    }
  }

  /// Build domain cards grid
  Widget _buildDomainCards(List<Domain> domains) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getResponsiveColumnCount(context),
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: domains.length,
        itemBuilder: (context, index) {
          return _buildDomainCard(domains[index]);
        },
      ),
    );
  }

  /// Build a single domain card
  Widget _buildDomainCard(Domain domain) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: domain == _activeDomain
              ? primaryColor
              : primaryColor.withOpacity(0.1),
          width: domain == _activeDomain ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => _selectDomain(domain),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and domain name
              Row(
                children: [
                  Icon(
                    Icons.domain,
                    color: primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      domain.code,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              if (domain.description.isNotEmpty)
                Expanded(
                  child: Text(
                    domain.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Stats row
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${domain.models.length} models',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${_getTotalConceptCount(domain)} concepts',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // Edit actions
              if (_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editDomain(domain),
                      tooltip: 'Edit',
                      color: primaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _deleteDomain(domain),
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

  /// Build domain list view
  Widget _buildDomainList(List<Domain> domains) {
    return ListView.builder(
      itemCount: domains.length,
      itemBuilder: (context, index) {
        final domain = domains[index];
        return ListTile(
          leading: const Icon(Icons.domain),
          title: Text(domain.code),
          subtitle: Text(
            domain.description.isNotEmpty
                ? domain.description
                : '${domain.models.length} models',
          ),
          selected: domain == _activeDomain,
          onTap: () => _selectDomain(domain),
          trailing: _isEditing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editDomain(domain),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteDomain(domain),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  /// Get total concept count for a domain
  int _getTotalConceptCount(Domain domain) {
    int count = 0;
    for (final model in domain.models) {
      count += model.concepts.length;
    }
    return count;
  }

  /// Select a domain for editing
  void _selectDomain(Domain domain) {
    setState(() {
      _activeDomain = domain;

      // Reset model and concept selection
      _activeModel = domain.models.isNotEmpty ? domain.models.first : null;
      _activeConcept = _activeModel?.concepts.isNotEmpty == true
          ? _activeModel!.concepts.first
          : null;

      // Switch to Models tab
      _tabController.animateTo(1);
    });
  }

  /// Edit a domain
  void _editDomain(Domain domain) {
    // TODO: Implement domain editing
  }

  /// Delete a domain
  void _deleteDomain(Domain domain) {
    // TODO: Implement domain deletion with confirmation
  }

  /// Build the model view
  Widget _buildModelView() {
    if (_activeDomain == null) {
      return const Center(
        child: Text('Select a domain first'),
      );
    }

    final models = _activeDomain!.models.toList();

    if (models.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No models in this domain'),
            if (_isEditing) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Model'),
                onPressed: _addNewModel,
              ),
            ],
          ],
        ),
      );
    }

    // Filter models by search query if applicable
    final filteredModels = _searchQuery.isEmpty
        ? models
        : models
            .where((m) =>
                m.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (m.description
                        ?.toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ??
                    false))
            .toList();

    if (_viewMode == EntityViewMode.cards) {
      return _buildModelCards(filteredModels);
    } else {
      return _buildModelList(filteredModels);
    }
  }

  /// Build model cards grid
  Widget _buildModelCards(List<Model> models) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getResponsiveColumnCount(context),
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: models.length,
        itemBuilder: (context, index) {
          return _buildModelCard(models[index]);
        },
      ),
    );
  }

  /// Build a single model card
  Widget _buildModelCard(Model model) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final entryCount = model.concepts.where((c) => c.entry).length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: model == _activeModel
              ? primaryColor
              : primaryColor.withOpacity(0.1),
          width: model == _activeModel ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => _selectModel(model),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and model name
              Row(
                children: [
                  Icon(
                    Icons.data_object,
                    color: primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      model.code,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Badges for entry/total
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${model.concepts.length} concepts',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: primaryColor,
                          ),
                    ),
                  ),
                  if (entryCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '$entryCount entries',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.green.shade700,
                            ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // Description or concept list
              Expanded(
                child:
                    model.description != null && model.description!.isNotEmpty
                        ? Text(
                            model.description!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            'Concepts: ${_getTopConceptNames(model).join(", ")}',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
              ),

              // Edit actions
              if (_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editModel(model),
                      tooltip: 'Edit',
                      color: primaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _deleteModel(model),
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

  /// Get top concept names for display
  List<String> _getTopConceptNames(Model model) {
    final concepts = model.concepts.toList();
    if (concepts.isEmpty) return ['No concepts'];

    // Prioritize entry concepts
    final entryConcepts = concepts.where((c) => c.entry).toList();
    if (entryConcepts.isNotEmpty) {
      return entryConcepts.take(3).map((c) => c.code).toList();
    }

    // Otherwise show first 3 concepts
    return concepts.take(3).map((c) => c.code).toList();
  }

  /// Build model list view
  Widget _buildModelList(List<Model> models) {
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models[index];
        final entryCount = model.concepts.where((c) => c.entry).length;

        return ListTile(
          leading: const Icon(Icons.data_object),
          title: Text(model.code),
          subtitle: Text(
            model.description ??
                '${model.concepts.length} concepts, $entryCount entries',
          ),
          selected: model == _activeModel,
          onTap: () => _selectModel(model),
          trailing: _isEditing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editModel(model),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteModel(model),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  /// Select a model for editing
  void _selectModel(Model model) {
    setState(() {
      _activeModel = model;

      // Reset concept selection
      _activeConcept = model.concepts.isNotEmpty ? model.concepts.first : null;

      // Switch to Concepts tab
      _tabController.animateTo(2);
    });
  }

  /// Edit a model
  void _editModel(Model model) {
    // TODO: Implement model editing
  }

  /// Delete a model
  void _deleteModel(Model model) {
    // TODO: Implement model deletion with confirmation
  }

  /// Build the concept view
  Widget _buildConceptView() {
    if (_activeModel == null) {
      return const Center(
        child: Text('Select a model first'),
      );
    }

    final concepts = _activeModel!.concepts.toList();

    if (concepts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No concepts in this model'),
            if (_isEditing) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Concept'),
                onPressed: _addNewConcept,
              ),
            ],
          ],
        ),
      );
    }

    // Filter concepts by search query if applicable
    final filteredConcepts = _searchQuery.isEmpty
        ? concepts
        : concepts
            .where((c) =>
                c.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();

    if (_viewMode == EntityViewMode.cards) {
      return _buildConceptCards(filteredConcepts);
    } else {
      return _buildConceptList(filteredConcepts);
    }
  }

  /// Build concept cards grid
  Widget _buildConceptCards(List<Concept> concepts) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getResponsiveColumnCount(context),
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: concepts.length,
        itemBuilder: (context, index) {
          return _buildConceptCard(concepts[index]);
        },
      ),
    );
  }

  /// Build a single concept card
  Widget _buildConceptCard(Concept concept) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final attributeCount = concept.attributes.length;
    final parentCount = concept.parents.length;
    final childCount = concept.children.length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: concept == _activeConcept
              ? primaryColor
              : primaryColor.withOpacity(0.1),
          width: concept == _activeConcept ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => _selectConcept(concept),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and concept name
              Row(
                children: [
                  Icon(
                    concept.entry ? Icons.stars : Icons.schema,
                    color: concept.entry ? Colors.amber : primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      concept.code,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Badges for entry/abstract
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    if (concept.entry)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'Entry',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.amber.shade900,
                                  ),
                        ),
                      ),
                    if (concept.abstract)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'Abstract',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.purple.shade700,
                                  ),
                        ),
                      ),
                  ],
                ),
              ),

              // Description
              if (concept.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    concept.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Structure counts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCountItem(
                        context, 'Attributes', attributeCount, Icons.view_list),
                    const SizedBox(height: 4),
                    _buildCountItem(
                        context, 'Parents', parentCount, Icons.arrow_upward),
                    const SizedBox(height: 4),
                    _buildCountItem(
                        context, 'Children', childCount, Icons.arrow_downward),
                  ],
                ),
              ),

              // Edit actions
              if (_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editConcept(concept),
                      tooltip: 'Edit',
                      color: primaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _deleteConcept(concept),
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

  /// Build a count item with icon
  Widget _buildCountItem(
      BuildContext context, String label, int count, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $count',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Build concept list view
  Widget _buildConceptList(List<Concept> concepts) {
    return ListView.builder(
      itemCount: concepts.length,
      itemBuilder: (context, index) {
        final concept = concepts[index];

        return ListTile(
          leading: Icon(
            concept.entry ? Icons.stars : Icons.schema,
            color: concept.entry ? Colors.amber : null,
          ),
          title: Text(concept.code),
          subtitle: Text(
            concept.description.isNotEmpty
                ? concept.description
                : '${concept.attributes.length} attributes',
          ),
          selected: concept == _activeConcept,
          onTap: () => _selectConcept(concept),
          trailing: _isEditing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editConcept(concept),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteConcept(concept),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  /// Select a concept for editing
  void _selectConcept(Concept concept) {
    setState(() {
      _activeConcept = concept;

      // TODO: Navigate to concept detail view
    });
  }

  /// Edit a concept
  void _editConcept(Concept concept) {
    // TODO: Implement concept editing
  }

  /// Delete a concept
  void _deleteConcept(Concept concept) {
    // TODO: Implement concept deletion with confirmation
  }

  /// Get the optimal number of columns based on screen width
  int _getResponsiveColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 960) return 2;
    if (width < 1280) return 3;
    return 4;
  }
}
