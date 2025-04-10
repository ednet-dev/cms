part of ednet_core_flutter;

/// A domain interpreter shell that provides runtime interpretation of EDNet domain models
/// with customizable UX representations.
///
/// The [ShellApp] serves as the central hub connecting generated domain models with
/// their visual representations. It provides a framework for progressive disclosure
/// of UI elements and allows for comprehensive customization.
///
/// This architecture follows the principles of:
/// - Domain-Driven Design: Domain models remain pure, UI concerns handled by adapters
/// - Progressive Disclosure: UI complexity adapts to user needs and expertise
/// - Adapter Pattern: Customizable UI representations for domain entities
/// - Enterprise Integration Patterns: Leveraging Channel Adapters, Filters, and Aggregators
///
/// Example usage:
/// ```dart
/// // Initialize the shell with your domain model
/// final shell = ShellApp(domainModel: myGeneratedDomainModel);
///
/// // Register custom adapters for entity types
/// shell.registerAdapter<ProjectEntity>(ProjectUXAdapterFactory());
///
/// // Configure default disclosure levels for different user roles
/// shell.configureDisclosureLevel(
///   userRole: UserRole.advanced,
///   defaultLevel: DisclosureLevel.intermediate
/// );
///
/// // Launch the UI
/// runApp(ShellAppRunner(shellApp: shell));
/// ```
class ShellApp {
  /// The domain model being interpreted
  Domain get domain {
    if (_domainManager != null) {
      // If multi-domain, return the current domain
      return _domainManager!.currentDomain;
    }
    return _domain;
  }

  /// The original domain passed to the constructor
  final Domain _domain;

  /// Registry for UI component adapters
  final UXAdapterRegistry _adapterRegistry = UXAdapterRegistry();

  /// Default disclosure levels by user role
  final Map<String, DisclosureLevel> _disclosureLevelsByRole = {
    'default': DisclosureLevel.basic,
    'admin': DisclosureLevel.advanced,
    'developer': DisclosureLevel.complete,
  };

  /// UX customization configuration
  final ShellConfiguration configuration;

  /// The current user's role
  String _currentUserRole = 'default';

  /// The navigation service for this shell
  late final ShellNavigationService _navigationService;

  /// The domain manager for multi-domain support
  _DomainManager? _domainManager;

  /// Constructor
  ShellApp({
    required Domain domain,
    ShellConfiguration? configuration,
    Domains? domains,
    int initialDomainIndex = 0,
  })  : _domain = domain,
        configuration = configuration ?? ShellConfiguration() {
    _initializeShell();

    // Initialize multi-domain support if domains are provided
    if (domains != null) {
      initializeWithDomains(domains, initialDomainIndex: initialDomainIndex);
    }
  }

  /// Initialize the shell's core components
  void _initializeShell() {
    // Initialize the navigation service
    _navigationService =
        ShellNavigationService(domain: _domain, shellApp: this);
    _navigationService.initialize();

    // Register default adapters for core entity types
    _registerDefaultAdapters();

    // Set up message channels
    _setupMessageChannels();

    // Initialize component registry
    _initializeComponentRegistry();

    // Apply custom configurations
    _applyConfiguration();
  }

  /// Register default adapters for common entity types
  void _registerDefaultAdapters() {
    // Default adapters are registered here
    // These provide baseline visualization for all entity types
    // Clients can override these with their own implementations
  }

  /// Set up messaging infrastructure
  void _setupMessageChannels() {
    // Create channels for different message types
  }

  /// Initialize the component registry
  void _initializeComponentRegistry() {
    // Register core components for domain visualization
  }

  /// Apply custom configuration settings
  void _applyConfiguration() {
    // Apply settings from the configuration object

    // Set default disclosure level if specified
    if (configuration.defaultDisclosureLevel != null) {
      _disclosureLevelsByRole['default'] =
          configuration.defaultDisclosureLevel!;
    }

    // Register custom adapters if provided
    if (configuration.customAdapters.isNotEmpty) {
      for (final entry in configuration.customAdapters.entries) {
        // Use dynamic registration since we don't know the exact entity type at compile time
        _adapterRegistry.registerDynamic(entry.key, entry.value);
      }
    }
  }

  /// Register a custom adapter for an entity type
  void registerAdapter<T extends Entity<T>>(UXAdapterFactory<T> factory) {
    _adapterRegistry.register<T>(factory);
  }

  /// Register a disclosure-specific adapter for an entity type
  void registerAdapterWithDisclosure<T extends Entity<T>>(
    UXAdapterFactory<T> factory,
    DisclosureLevel level,
  ) {
    _adapterRegistry.registerWithDisclosure<T>(factory, level);
  }

  /// Configure the default disclosure level for a user role
  void configureDisclosureLevel({
    required String userRole,
    required DisclosureLevel defaultLevel,
  }) {
    _disclosureLevelsByRole[userRole] = defaultLevel;
  }

  /// Set the current user role
  set currentUserRole(String role) {
    _currentUserRole = role;
  }

  /// Get the current disclosure level based on user role
  DisclosureLevel get currentDisclosureLevel {
    return _disclosureLevelsByRole[_currentUserRole] ?? DisclosureLevel.basic;
  }

  /// Get the adapter registry
  UXAdapterRegistry get adapterRegistry => _adapterRegistry;

  /// Get the navigation service
  ShellNavigationService get navigationService => _navigationService;

  /// Get an entity by concept and ID
  Entity? getEntity(String conceptCode, String id) {
    // Find the concept in the domain
    final concept = _findConcept(conceptCode);
    if (concept == null) return null;

    // Find entity in the repository
    // This is simplified - real implementation would use proper repository
    return null;
  }

  /// Find a concept by its code
  Concept? _findConcept(String conceptCode) {
    // Iterate through models in the domain
    for (final model in domain.models) {
      // Iterate through concepts in the model
      for (final concept in model.concepts) {
        if (concept.code == conceptCode) {
          return concept;
        }
      }
    }
    return null;
  }

  /// Build a form for an entity
  Widget buildEntityForm<T extends Entity<T>>(
    BuildContext context,
    T entity, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Get the appropriate adapter and build the form
    final adapter = _adapterRegistry.getAdapter<T>(
      entity,
      disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
    );

    return adapter.buildForm(
      context,
      disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
    );
  }

  /// Build a list widget for entities of a specific concept
  Widget buildEntityList<T extends Entity<T>>(
    BuildContext context,
    String conceptCode,
    List<T> entities, {
    DisclosureLevel? disclosureLevel,
  }) {
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final entity = entities[index];
        final adapter = _adapterRegistry.getAdapter<T>(
          entity,
          disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
        );

        return adapter.buildListItem(
          context,
          disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
        );
      },
    );
  }

  /// Build a domain model visualization
  Widget buildDomainVisualization(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Create a visualization of the domain model
    // This would generate a diagram or interactive view of the domain
    return Text('Domain Visualization for ${domain.code}');
  }

  /// Build breadcrumb navigation for the current location
  Widget buildBreadcrumbNavigation(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
    BreadcrumbStyle? style,
  }) {
    // Get breadcrumb items from the navigation service
    final items = _navigationService.breadcrumbService.items;

    // If no items, don't show anything
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Return a breadcrumb component with current items
    return Breadcrumb(
      items: items,
      onItemTap: (item) => _navigationService.breadcrumbService
          .navigateToDestination(item.destination),
      style: style,
      disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
    );
  }

  /// Get a specific model by code
  Model? getModel(String modelCode) {
    for (final model in domain.models) {
      if (model.code == modelCode) {
        return model;
      }
    }
    return null;
  }

  /// Check if this shell has a specific feature
  bool hasFeature(String featureKey) {
    return configuration.features.contains(featureKey);
  }

  /// Navigate to a specific path
  void navigateTo(String path,
      {Map<String, dynamic>? parameters, String? label, IconData? icon}) {
    _navigationService.navigateTo(path,
        parameters: parameters, label: label, icon: icon);
  }

  /// Navigate to a specific entity
  void navigateToEntity(Entity entity,
      {Map<String, dynamic>? parameters, IconData? icon}) {
    _navigationService.navigateToEntity(entity,
        parameters: parameters, icon: icon);
  }

  /// Navigate to a specific model
  void navigateToModel(Model model,
      {Map<String, dynamic>? parameters, IconData? icon}) {
    _navigationService.navigateToModel(model,
        parameters: parameters, icon: icon);
  }

  /// Navigate to a specific concept
  void navigateToConcept(Concept concept,
      {Map<String, dynamic>? parameters, IconData? icon}) {
    _navigationService.navigateToConcept(concept,
        parameters: parameters, icon: icon);
  }

  /// Navigate back to the previous location
  bool navigateBack() {
    return _navigationService.navigateBack();
  }
}

/// Configuration for the Shell App
class ShellConfiguration {
  /// Default disclosure level for the shell
  final DisclosureLevel? defaultDisclosureLevel;

  /// Custom adapters for entity types
  final Map<Type, UXAdapterFactory> customAdapters;

  /// Enabled features
  final Set<String> features;

  /// Custom theme for the shell
  final ThemeData? theme;

  /// Constructor
  ShellConfiguration({
    this.defaultDisclosureLevel,
    Map<Type, UXAdapterFactory>? customAdapters,
    Set<String>? features,
    this.theme,
  })  : customAdapters = customAdapters ?? {},
        features = features ?? <String>{};

  /// Create a copy with modified values
  ShellConfiguration copyWith({
    DisclosureLevel? defaultDisclosureLevel,
    Map<Type, UXAdapterFactory>? customAdapters,
    Set<String>? features,
    ThemeData? theme,
  }) {
    return ShellConfiguration(
      defaultDisclosureLevel:
          defaultDisclosureLevel ?? this.defaultDisclosureLevel,
      customAdapters: customAdapters ?? Map.from(this.customAdapters),
      features: features ?? Set.from(this.features),
      theme: theme ?? this.theme,
    );
  }
}

/// A Flutter app that wraps the Shell
class ShellAppRunner extends StatefulWidget {
  /// The shell app to run
  final ShellApp shellApp;

  /// Optional theme override
  final ThemeData? theme;

  /// Constructor
  const ShellAppRunner({Key? key, required this.shellApp, this.theme})
      : super(key: key);

  @override
  State<ShellAppRunner> createState() => _ShellAppRunnerState();
}

class _ShellAppRunnerState extends State<ShellAppRunner> {
  @override
  Widget build(BuildContext context) {
    // Create a provider that gives access to the shell
    return MaterialApp(
      theme: widget.theme ??
          widget.shellApp.configuration.theme ??
          ThemeData.light(),
      home: widget.shellApp.isMultiDomain
          ? MultiDomainNavigator(shellApp: widget.shellApp)
          : DomainNavigator(shellApp: widget.shellApp),
    );
  }
}

/// A widget that provides navigation through the domain model
class DomainNavigator extends StatefulWidget {
  /// The shell app
  final ShellApp shellApp;

  /// Constructor
  const DomainNavigator({Key? key, required this.shellApp}) : super(key: key);

  @override
  State<DomainNavigator> createState() => _DomainNavigatorState();
}

class _DomainNavigatorState extends State<DomainNavigator> {
  int _selectedIndex = 0;
  String _currentPath = '/';

  @override
  void initState() {
    super.initState();
    // Listen for navigation changes
    widget.shellApp.navigationService.addListener(_onNavigationChanged);
  }

  @override
  void dispose() {
    // Remove the navigation listener
    widget.shellApp.navigationService.removeListener(_onNavigationChanged);
    super.dispose();
  }

  void _onNavigationChanged(String path) {
    setState(() {
      _currentPath = path;

      // Update the selected index if the path points to a model
      if (path.startsWith('/domain/')) {
        final segments = path.split('/').where((s) => s.isNotEmpty).toList();
        if (segments.length >= 2) {
          final modelCode = segments[1];
          final models = widget.shellApp.domain.models.toList();

          for (int i = 0; i < models.length; i++) {
            if (models[i].code == modelCode) {
              _selectedIndex = i;
              break;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the domain from the shell
    final domain = widget.shellApp.domain;
    final models = domain.models.toList();

    // Create a navigation drawer for the domain
    return Scaffold(
      appBar: AppBar(
        title: Text('EDNet Shell: ${domain.code}'),
        // Back button that uses the navigation service
        leading: widget.shellApp.navigationService.isInHistory(_currentPath)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => widget.shellApp.navigateBack(),
              )
            : null,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Domain: ${domain.code}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            // Generate menu items for each model
            ...List.generate(models.length, (index) {
              final model = models[index];
              return ListTile(
                title: Text(model.code),
                selected: _selectedIndex == index,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  // Navigate to the selected model using the navigation service
                  widget.shellApp.navigateToModel(model);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      body: Column(
        children: [
          // Show breadcrumb navigation at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.shellApp.buildBreadcrumbNavigation(
              context,
              disclosureLevel: widget.shellApp.currentDisclosureLevel,
            ),
          ),

          // Content area
          Expanded(
            child: models.isNotEmpty
                ? _buildModelView(models[_selectedIndex])
                : const Center(child: Text('No models available')),
          ),
        ],
      ),
    );
  }

  /// Build a view for a specific model
  Widget _buildModelView(Model model) {
    // Display the concepts in the model
    final concepts = model.concepts.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Model: ${model.code}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: concepts.length,
            itemBuilder: (context, index) {
              final concept = concepts[index];
              return ListTile(
                title: Text(concept.code),
                subtitle: Text('Attributes: ${concept.attributes.length}'),
                onTap: () {
                  // Navigate to concept using the navigation service
                  widget.shellApp.navigateToConcept(concept);

                  // Navigate to concept details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConceptExplorer(
                        shellApp: widget.shellApp,
                        concept: concept,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A widget for exploring a concept and its entities
class ConceptExplorer extends StatefulWidget {
  /// The shell app
  final ShellApp shellApp;

  /// The concept to explore
  final Concept concept;

  /// Constructor
  const ConceptExplorer({
    Key? key,
    required this.shellApp,
    required this.concept,
  }) : super(key: key);

  @override
  State<ConceptExplorer> createState() => _ConceptExplorerState();
}

class _ConceptExplorerState extends State<ConceptExplorer> {
  /// Current disclosure level
  DisclosureLevel _disclosureLevel = DisclosureLevel.basic;

  @override
  void initState() {
    super.initState();
    // Use the shell's current disclosure level as the initial value
    _disclosureLevel = widget.shellApp.currentDisclosureLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concept: ${widget.concept.code}'),
        actions: [
          // Disclosure level selector
          PopupMenuButton<DisclosureLevel>(
            icon: const Icon(Icons.visibility),
            tooltip: 'Change detail level',
            onSelected: (level) {
              setState(() {
                _disclosureLevel = level;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DisclosureLevel.minimal,
                child: Text('Minimal'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.basic,
                child: Text('Basic'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.intermediate,
                child: Text('Intermediate'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.advanced,
                child: Text('Advanced'),
              ),
              const PopupMenuItem(
                value: DisclosureLevel.complete,
                child: Text('Complete'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show breadcrumb navigation at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.shellApp.buildBreadcrumbNavigation(
              context,
              disclosureLevel: _disclosureLevel,
            ),
          ),

          // Concept header with details
          _buildConceptHeader(),

          // Entity list (placeholder - in a real app, would fetch entities)
          Expanded(
            child: Center(
              child: Text(
                'No entities available. In a real application, entities of this concept would be listed here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
      // FAB to create a new entity
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to create a new entity
          _showCreateEntityDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build the concept header
  Widget _buildConceptHeader() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.concept.code,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (widget.concept.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(widget.concept.description),
              ),
            const Divider(),
            Text('Attributes:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // Show attributes based on disclosure level
            ..._buildAttributeList(),
          ],
        ),
      ),
    );
  }

  /// Build the attribute list with progressive disclosure
  List<Widget> _buildAttributeList() {
    // Progressive disclosure of attributes
    final attributes = widget.concept.attributes.toList();

    // Filter attributes based on disclosure level
    final visibleAttributes = attributes.where((attr) {
      if (_disclosureLevel == DisclosureLevel.minimal) {
        // Show only required attributes
        return attr.required;
      } else if (_disclosureLevel == DisclosureLevel.basic) {
        // Show required and non-technical attributes
        return attr.required || !attr.code.startsWith('_');
      } else if (_disclosureLevel == DisclosureLevel.intermediate) {
        // Show all except very technical attributes
        return !attr.code.startsWith('__');
      } else {
        // Show all attributes
        return true;
      }
    }).toList();

    return visibleAttributes.map((attr) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                attr.code,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(attr.type?.code ?? 'Unknown'),
            if (attr.required)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.star, size: 12, color: Colors.red),
              ),
          ],
        ),
      );
    }).toList();
  }

  /// Show dialog to create a new entity
  void _showCreateEntityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create ${widget.concept.code}'),
          content: const Text(
            'This would display a form to create a new entity. '
            'In a real application, a dynamically generated form would appear here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Created ${widget.concept.code} (simulated)'),
                  ),
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
