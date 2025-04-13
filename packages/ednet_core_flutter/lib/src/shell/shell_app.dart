part of ednet_core_flutter;

/// A powerful domain interpreter shell that provides runtime interpretation of EDNet domain models
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
class ShellApp extends ChangeNotifier {
  /// The domain model being interpreted
  Domain get domain {
    if (_domainManager != null) {
      // If multi-domain, return the current domain
      final domainManager = _domainManager as ShellDomainManager;
      return domainManager.currentDomain;
    }
    return _domain;
  }

  /// The original domain passed to the constructor
  final Domain _domain;

  /// Persistence manager for entity operations that handles saving/loading
  late final ShellPersistence _persistence;

  /// Registry for UI component adapters
  // TODO: Migrate to LayoutAdapterRegistry when full layout adapter pattern is implemented.
  // This is part of the Phase 2 implementation described in IMPLEMENTATION_PLAN.md
  final LayoutAdapterRegistry _adapterRegistry = LayoutAdapterRegistry();

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
  ShellDomainManager? _domainManager;

  /// Check if this shell supports multiple domains
  bool get isMultiDomain => _domainManager != null;

  /// Constructor
  ShellApp({
    required Domain domain,
    ShellConfiguration? configuration,
    Domains? domains,
    int initialDomainIndex = 0,
  })  : _domain = domain,
        configuration = configuration ?? ShellConfiguration() {
    // Initialize persistence with the domain
    // Check if development mode should be enabled
    final useDevelopmentMode = _shouldEnableDevelopmentMode();

    // Initialize persistence with development mode configuration
    _persistence =
        ShellPersistence(domain, useDevelopmentMode: useDevelopmentMode);

    if (useDevelopmentMode) {
      debugPrint(
          '⚠️ DEVELOPMENT MODE ENABLED - using sample data repositories');
    }

    _initializeShell();

    // Initialize multi-domain support if domains are provided
    if (domains != null) {
      initializeWithDomains(domains.toList(),
          initialDomainIndex: initialDomainIndex);
    }
  }

  /// Determine if development mode should be enabled based on configuration
  bool _shouldEnableDevelopmentMode() {
    // First check if it's explicitly enabled in the features
    if (configuration.features.contains('development_mode')) {
      return true;
    }

    // Then check if it's enabled via environment variable
    if (const bool.fromEnvironment('EDNET_DEV_MODE', defaultValue: false)) {
      return true;
    }

    // Default to false - explicitly enable through features or env vars
    return false;
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
    // Register default layout adapters for core entity types
    _adapterRegistry.register<Domain>(DomainLayoutAdapter());
    _adapterRegistry.register<Model>(ModelLayoutAdapter());
    _adapterRegistry.register<Concept>(ConceptLayoutAdapter());
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
        _adapterRegistry.registerType(entry.key, entry.value);
      }
    }
  }

  /// Register a custom adapter for an entity type
  void registerAdapter<T extends Entity<T>>(LayoutAdapter<T> adapter) {
    _adapterRegistry.register<T>(adapter);
  }

  /// Register a disclosure-specific adapter for an entity type
  void registerAdapterWithDisclosure<T extends Entity<T>>(
    LayoutAdapter<T> adapter,
    DisclosureLevel level,
  ) {
    _adapterRegistry.registerWithDisclosure<T>(adapter, level);
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
  LayoutAdapterRegistry get adapterRegistry => _adapterRegistry;

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
      disclosureLevel: disclosureLevel ?? currentDisclosureLevel,
    );

    if (adapter == null) {
      return Text('No adapter found for ${entity.concept.code}');
    }

    return adapter.buildForm(
      context,
      entity,
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
    final effectiveDisclosureLevel = disclosureLevel ?? currentDisclosureLevel;

    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final entity = entities[index];
        final adapter = _adapterRegistry.getAdapter<T>(
          disclosureLevel: effectiveDisclosureLevel,
        );

        if (adapter == null) {
          return ListTile(
            title: Text(entity.code),
            subtitle: Text('No adapter found for ${entity.concept.code}'),
          );
        }

        return adapter.buildListItem(
          context,
          entity,
          disclosureLevel: effectiveDisclosureLevel,
        );
      },
    );
  }

  /// Build a domain model visualization
  Widget buildDomainVisualization(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    // Create a visualization of the domain model using the semantic wrapper
    return ResponsiveSemanticWrapper.basic(
      artifactId: 'domain_visualization_${domain.code}',
      child: Text('Domain Visualization for ${domain.code}'),
    );
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

    // If tree navigation is enabled, handle artifact loading
    if (hasFeature('tree_navigation')) {
      _loadArtifactContent(path);
    }
  }

  /// Load content for a specific artifact path
  void _loadArtifactContent(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) return;

    // Handle domain level
    final domainCode = segments[0];
    Domain? domainToUse;

    if (isMultiDomain && _domainManager != null) {
      // Try to find domain by code
      final manager = _domainManager as ShellDomainManager;
      try {
        domainToUse = manager.getDomain(domainCode);
      } catch (e) {
        // Domain not found, use current domain
        domainToUse = domain;
      }
    } else {
      domainToUse = domain;
    }

    if (segments.length == 1) {
      // Show domain overview
      _navigationService.showDomainOverview(domainToUse);
      return;
    }

    // Handle model level
    final modelCode = segments[1];
    final model = domainToUse.getModel(modelCode);

    if (model == null) return;

    if (segments.length == 2) {
      // Show model overview
      _navigationService.showModelOverview(model);
      return;
    }

    // Handle concept level
    final conceptCode = segments[2];
    final concept = model.getConcept(conceptCode);

    if (concept == null) return;

    if (segments.length == 3) {
      // Show concept overview
      _navigationService.showConceptOverview(concept);
      return;
    }

    // Handle relationship level
    final relationshipCode = segments[3];
    final relationship = concept.getRelationship(relationshipCode);

    if (relationship != null) {
      // Show relationship details
      _navigationService.showRelationshipDetails(concept, relationshipCode);
    }
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

  /// Save an entity to the repository
  Future<bool> saveEntity(String conceptCode, Map<String, dynamic> entityData) {
    return _persistence.saveEntity(conceptCode, entityData);
  }

  /// Load entities from the repository
  Future<List<Map<String, dynamic>>> loadEntities(String conceptCode) {
    return _persistence.loadEntities(conceptCode);
  }

  /// Initialize the shell
  void initialize() {
    // Implement in subclasses
  }

  /// Get the current domain manager
  ShellDomainManager? get domainManager => _domainManager;

  /// Set the domain manager
  set domainManager(ShellDomainManager? manager) {
    _domainManager = manager;
    notifyListeners();
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

  // Stream subscription for navigation changes
  StreamSubscription<String>? _navigationSubscription;

  @override
  void initState() {
    super.initState();

    // Set up navigation service listener using a stream
    _setupNavigationListener();
  }

  @override
  void dispose() {
    // Cancel subscription
    _navigationSubscription?.cancel();
    super.dispose();
  }

  // Create a stream subscription for navigation changes
  void _setupNavigationListener() {
    // Create a stream controller
    final controller = StreamController<String>.broadcast();

    // Add callback to navigation service
    widget.shellApp.navigationService.addListener(() {
      controller.add(widget.shellApp.navigationService.currentPath);
    });

    // Subscribe to events
    _navigationSubscription = controller.stream.listen(_onNavigationChanged);
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

          for (var i = 0; i < models.length; i++) {
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
    final sidebarMode = widget.shellApp.configuration.sidebarMode;

    // Create a navigation drawer for the domain
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('EDNet Shell: ${domain.code}'),
            if (widget.shellApp.isMultiDomain) ...[
              const SizedBox(width: 16),
              DomainSelector(
                shellApp: widget.shellApp,
                style: DomainSelectorStyle(
                  textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  selectedTextStyle:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              // Show settings dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Settings'),
                  content:
                      const Text('Settings dialog will be implemented here.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        leading: widget.shellApp.navigationService.isInHistory(_currentPath)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => widget.shellApp.navigateBack(),
              )
            : null,
      ),
      body: Row(
        children: [
          // Domain Sidebar - included by default based on configuration
          if (sidebarMode == SidebarMode.classic ||
              sidebarMode == SidebarMode.both)
            SidebarContainer(
              shellApp: widget.shellApp,
              theme: Theme.of(context)
                  .extension<DomainSidebarThemeExtension>()
                  ?.sidebarTheme,
              onArtifactSelected: (path) {
                // Handle artifact selection
                widget.shellApp.navigateTo(path);
              },
            ),

          // Main content area
          Expanded(
            child: Column(
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

/// Command for updating an entity

/// Global context to access shell app from anywhere
