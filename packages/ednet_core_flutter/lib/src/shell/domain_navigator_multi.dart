part of ednet_core_flutter;

/// A DomainNavigator that supports multiple domains
class MultiDomainNavigator extends StatefulWidget {
  /// The shell app with domain support
  final ShellApp shellApp;

  /// Custom styles for the domain selector
  final DomainSelectorStyle? domainSelectorStyle;

  /// Custom domain item builder
  final Widget Function(BuildContext, Domain, bool)? domainItemBuilder;

  /// Constructor
  const MultiDomainNavigator({
    Key? key,
    required this.shellApp,
    this.domainSelectorStyle,
    this.domainItemBuilder,
  }) : super(key: key);

  @override
  State<MultiDomainNavigator> createState() => _MultiDomainNavigatorState();
}

class _MultiDomainNavigatorState extends State<MultiDomainNavigator> {
  int _selectedModelIndex = 0;
  String _currentPath = '/';

  // Stream subscriptions
  StreamSubscription<String>? _navigationSubscription;
  StreamSubscription<Domain>? _domainChangeSubscription;

  @override
  void initState() {
    super.initState();

    // Set up navigation service listener
    _navigationSubscription = _setupNavigationListener();

    // Listen for domain changes if multi-domain is enabled
    if (widget.shellApp.isMultiDomain) {
      _domainChangeSubscription = _setupDomainChangeListener();
    }
  }

  @override
  void dispose() {
    // Cancel subscriptions
    _navigationSubscription?.cancel();
    _domainChangeSubscription?.cancel();

    super.dispose();
  }

  // Create a stream subscription for navigation changes
  StreamSubscription<String> _setupNavigationListener() {
    final controller = StreamController<String>.broadcast();

    void listener() {
      if (!controller.isClosed) {
        controller.add(widget.shellApp.navigationService.currentPath);
      }
    }

    widget.shellApp.navigationService.addListener(listener);

    return controller.stream
        .distinct() // Only process unique path changes
        .listen(
      _onNavigationChanged,
      onError: (error) {
        debugPrint('Navigation error: $error');
      },
      onDone: () {
        widget.shellApp.navigationService.removeListener(listener);
        if (!controller.isClosed) {
          controller.close();
        }
      },
    );
  }

  // Create a stream subscription for domain changes
  StreamSubscription<Domain>? _setupDomainChangeListener() {
    if (widget.shellApp.domainManager == null) return null;

    // Simply return the subscription directly
    return widget.shellApp.domainManager!
        .addDomainChangeObserver(_onDomainChanged);
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
              _selectedModelIndex = i;
              break;
            }
          }
        }
      }
    });
  }

  void _onDomainChanged(Domain domain) {
    // Reset model selection when domain changes
    setState(() {
      _selectedModelIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final domain = widget.shellApp.domain;
    final models = domain.models.toList();
    final sidebarMode = widget.shellApp.configuration.sidebarMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('EDNet Shell One'),
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
                domainItemBuilder: widget.domainItemBuilder,
              ),
            ],
          ],
        ),
        leading: widget.shellApp.navigationService.isInHistory(_currentPath)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => widget.shellApp.navigateBack(),
              )
            : null,
      ),
      drawer: _buildDrawer(context, domain),
      body: Row(
        children: [
          // Include sidebar based on configuration
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
                      ? _buildModelView(models[_selectedModelIndex])
                      : const Center(child: Text('No models available')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build drawer for navigation
  Widget _buildDrawer(BuildContext context, Domain domain) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 36,
                  child: DomainSelector(
                    shellApp: widget.shellApp,
                    style: DomainSelectorStyle(
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                      selectedTextStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Generate menu items for each domain and its models
          if (widget.shellApp.availableDomains != null)
            ...widget.shellApp.availableDomains!.map((domain) {
              final isCurrentDomain = domain == widget.shellApp.domain;
              return ExpansionTile(
                title: Text(domain.code),
                initiallyExpanded: isCurrentDomain,
                leading: Icon(
                  Icons.domain,
                  color:
                      isCurrentDomain ? Theme.of(context).primaryColor : null,
                ),
                onExpansionChanged: (expanded) {
                  if (expanded && !isCurrentDomain) {
                    widget.shellApp.switchToDomainByCode(domain.code);
                  }
                },
                children: domain.models.map((model) {
                  final isSelected = isCurrentDomain &&
                      domain.models.any((m) => m.code == model.code);
                  return ListTile(
                    title: Text(model.code),
                    selected: isSelected,
                    leading: const Icon(Icons.model_training),
                    onTap: () {
                      if (!isCurrentDomain) {
                        widget.shellApp.switchToDomainByCode(domain.code);
                      }
                      widget.shellApp.navigateToModel(model);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            }).toList(),
        ],
      ),
    );
  }

  /// Build a view for a specific model
  Widget _buildModelView(Model model) {
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
                onTap: () => _navigateToConcept(concept),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Handle concept navigation with proper separation of concerns
  void _navigateToConcept(Concept concept) {
    // First update the domain navigation state (no await needed as the method returns void)
    widget.shellApp.navigateToConcept(concept);

    // Then handle UI navigation if the widget is still mounted
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConceptExplorer(
            shellApp: widget.shellApp,
            concept: concept,
          ),
        ),
      );
    }
  }
}
