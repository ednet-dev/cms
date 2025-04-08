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

  @override
  void initState() {
    super.initState();
    // Listen for navigation changes
    widget.shellApp.navigationService.addListener(_onNavigationChanged);

    // Listen for domain changes if multi-domain is enabled
    if (widget.shellApp.isMultiDomain) {
      widget.shellApp.domainManager?.addDomainChangeObserver(_onDomainChanged);
    }
  }

  @override
  void dispose() {
    // Remove listeners
    widget.shellApp.navigationService.removeListener(_onNavigationChanged);

    if (widget.shellApp.isMultiDomain) {
      widget.shellApp.domainManager
          ?.removeDomainChangeObserver(_onDomainChanged);
    }

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('EDNet Shell: ${domain.code}'),
            if (widget.shellApp.isMultiDomain) ...[
              const SizedBox(width: 16),
              DomainSelector(
                shellApp: widget.shellApp,
                domainItemBuilder: widget.domainItemBuilder,
                style: widget.domainSelectorStyle,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Domain: ${domain.code}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (widget.shellApp.isMultiDomain) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Select Domain:',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 36,
                      child: DomainSelector(
                        shellApp: widget.shellApp,
                        style: const DomainSelectorStyle(
                          selectorType: DomainSelectorType.chips,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Generate menu items for each model
            ...List.generate(models.length, (index) {
              final model = models[index];
              return ListTile(
                title: Text(model.code),
                selected: _selectedModelIndex == index,
                onTap: () {
                  setState(() {
                    _selectedModelIndex = index;
                  });
                  // Navigate to the selected model
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
                ? _buildModelView(models[_selectedModelIndex])
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
