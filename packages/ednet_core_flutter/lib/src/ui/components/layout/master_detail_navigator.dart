part of ednet_core_flutter;

/// A master-detail navigator that provides a hierarchical navigation pattern for domain models.
///
/// IMPORTANT: This is a prototype implementation that needs to be updated to match
/// the actual ednet_core and Flutter classes. The exact implementation will need
/// to be integrated with the proper domain model classes from ednet_core.
///
/// TODO: Update class to use actual domain model classes and fix imports
///
/// This widget implements a left-to-right navigation flow for domain models:
/// - Domains are accessible from the header
/// - Models within the selected domain are shown on the left side
/// - Concepts/aggregate roots within the selected model appear next
/// - Entity details and their morphology attributes (with constraint validation) appear on the right
///
/// As users navigate deeper into relationships, the UI shifts left to maintain focus on the currently
/// selected entity while preserving context.
class MasterDetailNavigator extends StatefulWidget {
  /// The shell app providing domain model access
  final ShellApp shellApp;

  /// Initial model to display, if any
  final Model? initialModel;

  /// Initial concept to display, if any
  final Concept? initialConcept;

  /// Initial entity to display, if any
  final Entity? initialEntity;

  /// Whether to show the domain selector in the header
  final bool showDomainSelector;

  /// Disclosure level for progressive disclosure
  final DisclosureLevel disclosureLevel;

  /// Constructor
  const MasterDetailNavigator({
    Key? key,
    required this.shellApp,
    this.initialModel,
    this.initialConcept,
    this.initialEntity,
    this.showDomainSelector = true,
    this.disclosureLevel = DisclosureLevel.intermediate,
  }) : super(key: key);

  @override
  State<MasterDetailNavigator> createState() => _MasterDetailNavigatorState();
}

class _MasterDetailNavigatorState extends State<MasterDetailNavigator> {
  /// Currently selected domain
  late Domain _currentDomain;

  /// Currently selected model
  Model? _selectedModel;

  /// Currently selected concept
  Concept? _selectedConcept;

  /// Currently selected entity
  Entity? _selectedEntity;

  /// Currently selected relationship
  RelationDefinition? _selectedRelation;

  /// Navigation history for breadcrumb
  final List<_NavigationHistoryItem> _navigationHistory = [];

  /// Scroll controllers for each level
  final ScrollController _modelScrollController = ScrollController();
  final ScrollController _conceptScrollController = ScrollController();
  final ScrollController _entityScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize with the shell app's domain
    _currentDomain = widget.shellApp.domain;

    // Set initial selections if provided
    _selectedModel = widget.initialModel;
    _selectedConcept = widget.initialConcept;
    _selectedEntity = widget.initialEntity;

    // Build initial navigation history
    _buildInitialNavigationHistory();
  }

  /// Builds the initial navigation history based on provided initial selections
  void _buildInitialNavigationHistory() {
    if (widget.initialModel != null) {
      _navigationHistory.add(_NavigationHistoryItem(
        type: _NavigationType.model,
        label: widget.initialModel!.code,
        model: widget.initialModel,
      ));
    }

    if (widget.initialConcept != null) {
      _navigationHistory.add(_NavigationHistoryItem(
        type: _NavigationType.concept,
        label: widget.initialConcept!.code,
        concept: widget.initialConcept,
      ));
    }

    if (widget.initialEntity != null) {
      _navigationHistory.add(_NavigationHistoryItem(
        type: _NavigationType.entity,
        label: widget.initialEntity!.code,
        entity: widget.initialEntity,
      ));
    }
  }

  @override
  void dispose() {
    _modelScrollController.dispose();
    _conceptScrollController.dispose();
    _entityScrollController.dispose();
    super.dispose();
  }

  /// Selects a model and updates the navigation
  void _selectModel(Model model) {
    setState(() {
      _selectedModel = model;
      _selectedConcept = null;
      _selectedEntity = null;
      _selectedRelation = null;

      // Clear navigation history after model
      _navigationHistory
          .removeWhere((item) => item.type != _NavigationType.model);
      if (_navigationHistory.isEmpty ||
          _navigationHistory.last.model != model) {
        _navigationHistory.add(_NavigationHistoryItem(
          type: _NavigationType.model,
          label: model.code,
          model: model,
        ));
      }
    });
  }

  /// Selects a concept and updates the navigation
  void _selectConcept(Concept concept) {
    setState(() {
      _selectedConcept = concept;
      _selectedEntity = null;
      _selectedRelation = null;

      // Clear navigation history after concept
      _navigationHistory.removeWhere((item) =>
          item.type != _NavigationType.model &&
          item.type != _NavigationType.concept);

      if (_navigationHistory.isEmpty ||
          _navigationHistory.last.concept != concept) {
        _navigationHistory.add(_NavigationHistoryItem(
          type: _NavigationType.concept,
          label: concept.code,
          concept: concept,
        ));
      }
    });
  }

  /// Selects an entity and updates the navigation
  void _selectEntity(Entity entity) {
    setState(() {
      _selectedEntity = entity;
      _selectedRelation = null;

      // Clear navigation history after entity
      _navigationHistory.removeWhere((item) =>
          item.type != _NavigationType.model &&
          item.type != _NavigationType.concept &&
          item.type != _NavigationType.entity);

      if (_navigationHistory.isEmpty ||
          _navigationHistory.last.entity != entity) {
        _navigationHistory.add(_NavigationHistoryItem(
          type: _NavigationType.entity,
          label: entity.code,
          entity: entity,
        ));
      }
    });
  }

  /// Selects a relationship and navigates to it
  void _selectRelation(RelationDefinition relation, Entity parentEntity) {
    setState(() {
      _selectedRelation = relation;

      // Add to navigation history
      _navigationHistory.add(_NavigationHistoryItem(
        type: _NavigationType.relation,
        label: relation.code,
        relation: relation,
        parentEntity: parentEntity,
      ));
    });

    // Navigate to related entities (this would actually load the related entities)
    // This is placeholder logic - in a real implementation, you would load the related entities
    // For now, this just shifts the UI focus
  }

  /// Navigate to a history item
  void _navigateToHistoryItem(_NavigationHistoryItem item) {
    setState(() {
      // Find the index of the item in history
      final index = _navigationHistory.indexOf(item);

      // Remove all items after this one
      if (index >= 0 && index < _navigationHistory.length - 1) {
        _navigationHistory.removeRange(index + 1, _navigationHistory.length);
      }

      // Set the appropriate selections based on the item type
      switch (item.type) {
        case _NavigationType.model:
          _selectedModel = item.model;
          _selectedConcept = null;
          _selectedEntity = null;
          _selectedRelation = null;
          break;

        case _NavigationType.concept:
          _selectedConcept = item.concept;
          _selectedEntity = null;
          _selectedRelation = null;
          break;

        case _NavigationType.entity:
          _selectedEntity = item.entity;
          _selectedRelation = null;
          break;

        case _NavigationType.relation:
          _selectedRelation = item.relation;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with domain selector if enabled
        if (widget.showDomainSelector) _buildDomainHeader(),

        // Breadcrumb navigation
        _buildBreadcrumbNavigation(),

        // Main content area with master-detail layout
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Models column (always visible)
              _buildModelsColumn(),

              // Concept column (visible when a model is selected)
              if (_selectedModel != null) _buildConceptsColumn(),

              // Entity details column (visible when a concept is selected)
              if (_selectedConcept != null) _buildEntitiesColumn(),

              // Entity attribute details (visible when an entity is selected)
              if (_selectedEntity != null) _buildEntityDetailsColumn(),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the domain selector header
  Widget _buildDomainHeader() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Text(
            'Domain: ${_currentDomain.code}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          const Spacer(),
          // Add domain switching dropdown if multiple domains available
          // This is a placeholder - would be implemented with actual domains list
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch Domain',
            onPressed: () {
              // Show domain selection dialog/dropdown
            },
          ),
        ],
      ),
    );
  }

  /// Builds breadcrumb navigation
  Widget _buildBreadcrumbNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8.0,
        children: [
          for (var i = 0; i < _navigationHistory.length; i++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Breadcrumb item
                InkWell(
                  onTap: () => _navigateToHistoryItem(_navigationHistory[i]),
                  child: Chip(
                    label: Text(_navigationHistory[i].label),
                  ),
                ),

                // Separator, except for last item
                if (i < _navigationHistory.length - 1)
                  const Icon(Icons.chevron_right, size: 16),
              ],
            ),
        ],
      ),
    );
  }

  /// Builds the models column
  Widget _buildModelsColumn() {
    final models = _currentDomain.models.toList();

    return SizedBox(
      width: 200,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(
                'Models',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _modelScrollController,
                itemCount: models.length,
                itemBuilder: (context, index) {
                  final model = models[index];
                  return ListTile(
                    title: Text(model.code),
                    selected: _selectedModel == model,
                    onTap: () => _selectModel(model),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the concepts column
  Widget _buildConceptsColumn() {
    final concepts = _selectedModel?.concepts.toList() ?? [];

    return SizedBox(
      width: 220,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(
                'Concepts in ${_selectedModel?.code}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _conceptScrollController,
                itemCount: concepts.length,
                itemBuilder: (context, index) {
                  final concept = concepts[index];
                  return ListTile(
                    title: Text(concept.code),
                    subtitle: concept.entry ? const Text('Entry') : null,
                    selected: _selectedConcept == concept,
                    onTap: () => _selectConcept(concept),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the entities column for a selected concept
  Widget _buildEntitiesColumn() {
    // This would fetch entities for the selected concept
    // For this example, we're using placeholders
    final entities = <Entity>[]; // This would be populated from repository

    return SizedBox(
      width: 240,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(
                '${_selectedConcept?.code} Entities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: entities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          const Text('No entities available'),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Create New'),
                            onPressed: () {
                              // Show entity creation form
                            },
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _entityScrollController,
                      itemCount: entities.length,
                      itemBuilder: (context, index) {
                        final entity = entities[index];
                        return ListTile(
                          title: Text(entity.code),
                          selected: _selectedEntity == entity,
                          onTap: () => _selectEntity(entity),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the entity details column with morphology attributes
  Widget _buildEntityDetailsColumn() {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedEntity?.code ?? 'Entity Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit Entity',
                    onPressed: () {
                      // Show edit form
                    },
                  ),
                ],
              ),
            ),

            // Tabs for morphology and relationships
            _buildEntityDetailsTabs(),
          ],
        ),
      ),
    );
  }

  /// Builds tabs for morphology attributes and relationships
  Widget _buildEntityDetailsTabs() {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: 'Attributes'),
                Tab(text: 'Relationships'),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Morphology attributes tab - this is where constraint validation happens
                  _buildConstraintValidatedAttributes(),

                  // Relationships tab
                  _buildEntityRelationships(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the constraint validated form for entity attributes
  Widget _buildConstraintValidatedAttributes() {
    if (_selectedEntity == null) {
      return const Center(child: Text('No entity selected'));
    }

    // Use ConstraintValidatedForm for attribute editing with constraints
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: ConstraintValidatedForm(
        concept: _selectedEntity!.concept,
        initialData: _getEntityData(_selectedEntity!),
        validateOnChange: true,
        showConstraintIndicators: true,
        title: 'Attributes',
        submitButtonText: 'Save Changes',
        disclosureLevel: widget.disclosureLevel,
        onSubmit: (Map<String, dynamic> data) async {
          // Update entity with new data
          // This would call the appropriate repository method
          return true; // Return success/failure
        },
      ),
    );
  }

  /// Get entity data as a Map<String, dynamic>
  Map<String, dynamic> _getEntityData(Entity entity) {
    // Implementation depends on the Entity class implementation
    // For now, return a simple map with the entity code
    final data = <String, dynamic>{'code': entity.code};

    // Add all attributes from the entity
    // In a real implementation, you would get these from the actual entity
    for (final attr in entity.concept.attributes) {
      // Add a placeholder value for each attribute
      data[attr.code] = '';
    }

    return data;
  }

  /// Builds the entity relationships list
  Widget _buildEntityRelationships() {
    if (_selectedEntity == null) {
      return const Center(child: Text('No entity selected'));
    }

    // Get parent-child relationships defined in the concept
    final relationDefs =
        _getConceptRelations(_selectedEntity!.concept);

    if (relationDefs.isEmpty) {
      return const Center(child: Text('No relationships defined'));
    }

    return ListView.builder(
      itemCount: relationDefs.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final relation = relationDefs[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(relation.code),
            subtitle: Text(relation.isParent
                ? 'Parent: ${relation.destinationConcept.code}'
                : 'Child: ${relation.destinationConcept.code}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _selectRelation(relation, _selectedEntity!),
          ),
        );
      },
    );
  }

  /// Get parent-child relationships for a concept
  List<RelationDefinition> _getConceptRelations(Concept concept) {
    // This is a placeholder method
    // In a real implementation, you would get the relations from the concept
    return [];
  }
}

/// Navigation history item for breadcrumb trail
class _NavigationHistoryItem {
  /// Type of navigation item
  final _NavigationType type;

  /// Display label
  final String label;

  /// Model reference (for model items)
  final Model? model;

  /// Concept reference (for concept items)
  final Concept? concept;

  /// Entity reference (for entity items)
  final Entity? entity;

  /// Relation reference (for relation items)
  final RelationDefinition? relation;

  /// Parent entity for relations
  final Entity? parentEntity;

  /// Constructor
  _NavigationHistoryItem({
    required this.type,
    required this.label,
    this.model,
    this.concept,
    this.entity,
    this.relation,
    this.parentEntity,
  });
}

/// Navigation item types
enum _NavigationType {
  model,
  concept,
  entity,
  relation,
}

/// Relation definition class - simpler version for demonstration
class RelationDefinition {
  final String code;
  final Concept concept;
  final Concept destinationConcept;
  final bool isParent;

  RelationDefinition({
    required this.code,
    required this.concept,
    required this.destinationConcept,
    this.isParent = false,
  });
}
