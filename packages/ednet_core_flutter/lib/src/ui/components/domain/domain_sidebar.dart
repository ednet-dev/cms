part of ednet_core_flutter;

/// Types of navigation items in the domain hierarchy
enum NavigationItemType {
  domain,
  model,
  concept,
  relationship,
}

/// Represents a selected item in the domain navigation
class DomainNavigationItem {
  final NavigationItemType type;
  final String path;
  final String title;
  final Domain? domain;
  final Model? model;
  final Concept? concept;

  DomainNavigationItem({
    required this.type,
    required this.path,
    required this.title,
    this.domain,
    this.model,
    this.concept,
  });
}

/// Theme configuration for the domain sidebar
class DomainSidebarTheme {
  final double sidebarWidth;
  final Color backgroundColor;
  final Color headerBackgroundColor;
  final Color dividerColor;
  final Color selectedItemColor;
  final Color selectedItemBorderColor;
  final Color itemIconColor;
  final Color selectedItemIconColor;
  final Color entryBadgeColor;
  final Color abstractBadgeColor;

  final TextStyle headerTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle itemTextStyle;
  final TextStyle selectedItemTextStyle;
  final TextStyle badgeTextStyle;
  final TextStyle groupLabelStyle;

  const DomainSidebarTheme({
    required this.sidebarWidth,
    required this.backgroundColor,
    required this.headerBackgroundColor,
    required this.dividerColor,
    required this.selectedItemColor,
    required this.selectedItemBorderColor,
    required this.itemIconColor,
    required this.selectedItemIconColor,
    required this.entryBadgeColor,
    required this.abstractBadgeColor,
    required this.headerTextStyle,
    required this.subtitleTextStyle,
    required this.itemTextStyle,
    required this.selectedItemTextStyle,
    required this.badgeTextStyle,
    required this.groupLabelStyle,
  });

  /// Create a theme instance from the current context
  factory DomainSidebarTheme.fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DomainSidebarTheme(
      sidebarWidth: 280,
      backgroundColor: colorScheme.surface,
      headerBackgroundColor: colorScheme.primaryContainer.withValues(alpha: .1),
      dividerColor: colorScheme.outline.withValues(alpha: .2),
      selectedItemColor: colorScheme.primaryContainer.withValues(alpha: .3),
      selectedItemBorderColor: colorScheme.primary,
      itemIconColor: colorScheme.onSurface.withValues(alpha: .7),
      selectedItemIconColor: colorScheme.primary,
      entryBadgeColor: colorScheme.primary.withValues(alpha: .2),
      abstractBadgeColor: colorScheme.secondary.withValues(alpha: .2),
      headerTextStyle: theme.textTheme.titleLarge!.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      subtitleTextStyle: theme.textTheme.bodySmall!.copyWith(
        color: colorScheme.onSurface.withValues(alpha: .6),
      ),
      itemTextStyle: theme.textTheme.bodyMedium!,
      selectedItemTextStyle: theme.textTheme.bodyMedium!.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      badgeTextStyle: theme.textTheme.labelSmall!.copyWith(
        color: colorScheme.onSurface,
      ),
      groupLabelStyle: theme.textTheme.labelSmall!.copyWith(
        color: colorScheme.onSurface.withValues(alpha: .6),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// A hierarchical sidebar component for navigating domain models.
///
/// This component provides a rich navigation experience through the EDNet domain model
/// hierarchy, supporting multiple domains, models, and concepts with progressive disclosure.
class DomainSidebar extends StatefulWidget {
  /// The shell app instance providing domain and navigation context
  final ShellApp shellApp;

  /// Optional custom theme for the sidebar
  final DomainSidebarTheme? theme;

  /// Callback when an item is selected
  final Function(DomainNavigationItem)? onItemSelected;

  const DomainSidebar({
    super.key,
    required this.shellApp,
    this.theme,
    this.onItemSelected,
  });

  @override
  State<DomainSidebar> createState() => _DomainSidebarState();
}

class _DomainSidebarState extends State<DomainSidebar> {
  /// Track expanded state of tree nodes
  final Map<String, bool> _expandedNodes = {};

  /// Currently selected item path
  String? _selectedPath;

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
      _selectedPath = path;
      // Auto-expand parent nodes of selected item
      _expandParentNodes(path);
    });
  }

  void _expandParentNodes(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    var currentPath = '';
    for (final segment in segments) {
      currentPath += '/$segment';
      _expandedNodes[currentPath] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? DomainSidebarTheme.fromContext(context);

    return Container(
      width: theme.sidebarWidth,
      color: theme.backgroundColor,
      child: Column(
        children: [
          // Domain Header
          _buildDomainHeader(theme),

          // Navigation Tree
          Expanded(
            child: SingleChildScrollView(
              child: _buildNavigationTree(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainHeader(DomainSidebarTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.shellApp.domain.code,
            style: theme.headerTextStyle,
          ),
          if (widget.shellApp.domain.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.shellApp.domain.description,
                style: theme.subtitleTextStyle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationTree(DomainSidebarTheme theme) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: _buildDomainNode(
        widget.shellApp.domain,
        theme,
        parentPath: '',
      ),
    );
  }

  Widget _buildDomainNode(Domain domain, DomainSidebarTheme theme,
      {required String parentPath}) {
    final path = '$parentPath/${domain.code}';
    final isExpanded = _expandedNodes[path] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Domain node
        _buildTreeItem(
          title: domain.code,
          icon: Icons.domain,
          theme: theme,
          isExpanded: isExpanded,
          isSelected: _selectedPath == path,
          onTap: () {
            setState(() {
              _expandedNodes[path] = !isExpanded;
            });
            _notifyItemSelected(DomainNavigationItem(
              type: NavigationItemType.domain,
              path: path,
              title: domain.code,
              domain: domain,
            ));
          },
        ),

        // Models under this domain
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: domain.models
                  .map((model) =>
                      _buildModelNode(model, theme, parentPath: path))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildModelNode(Model model, DomainSidebarTheme theme,
      {required String parentPath}) {
    final path = '$parentPath/${model.code}';
    final isExpanded = _expandedNodes[path] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Model node
        _buildTreeItem(
          title: model.code,
          icon: Icons.data_object,
          theme: theme,
          isExpanded: isExpanded,
          isSelected: _selectedPath == path,
          onTap: () {
            setState(() {
              _expandedNodes[path] = !isExpanded;
            });
            _notifyItemSelected(DomainNavigationItem(
              type: NavigationItemType.model,
              path: path,
              title: model.code,
              model: model,
            ));
          },
        ),

        // Concepts under this model
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: model.concepts
                  .map((concept) =>
                      _buildConceptNode(concept, theme, parentPath: path))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildConceptNode(Concept concept, DomainSidebarTheme theme,
      {required String parentPath}) {
    final path = '$parentPath/${concept.code}';
    final isExpanded = _expandedNodes[path] ?? false;

    // Determine icon based on concept type
    final conceptIcon = concept.entry
        ? Icons.class_
        : concept.abstract
            ? Icons.architecture
            : Icons.schema;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Concept node
        _buildTreeItem(
          title: concept.code,
          icon: conceptIcon,
          theme: theme,
          isExpanded: isExpanded,
          isSelected: _selectedPath == path,
          onTap: () {
            setState(() {
              _expandedNodes[path] = !isExpanded;
            });

            // Use the concept for navigation and entity management
            _navigateToConceptEntities(concept, path);
          },
          subtitle: concept.description,
          badges: _buildConceptBadges(concept, theme),
        ),

        // Show relationships if expanded
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parents
                if (concept.parents.isNotEmpty)
                  _buildRelationshipGroup(
                    'Parents',
                    concept.parents.map((p) => p.code).toList(),
                    Icons.arrow_upward,
                    theme,
                    path,
                  ),

                // Children
                if (concept.children.isNotEmpty)
                  _buildRelationshipGroup(
                    'Children',
                    concept.children.map((c) => c.code).toList(),
                    Icons.arrow_downward,
                    theme,
                    path,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _buildConceptBadges(Concept concept, DomainSidebarTheme theme) {
    final badges = <Widget>[];

    if (concept.entry) {
      badges.add(_buildBadge('Entry', theme.entryBadgeColor, theme));
    }
    if (concept.abstract) {
      badges.add(_buildBadge('Abstract', theme.abstractBadgeColor, theme));
    }

    return badges;
  }

  Widget _buildBadge(String text, Color color, DomainSidebarTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: theme.badgeTextStyle,
      ),
    );
  }

  Widget _buildRelationshipGroup(
    String title,
    List<String> items,
    IconData icon,
    DomainSidebarTheme theme,
    String parentPath,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 4),
          child: Text(
            title,
            style: theme.groupLabelStyle,
          ),
        ),
        ...items.map((item) => _buildTreeItem(
              title: item,
              icon: icon,
              theme: theme,
              isExpanded: false,
              isSelected: false,
              onTap: () {
                _notifyItemSelected(DomainNavigationItem(
                  type: NavigationItemType.relationship,
                  path: '$parentPath/$item',
                  title: item,
                ));
              },
              dense: true,
            )),
      ],
    );
  }

  Widget _buildTreeItem({
    required String title,
    required IconData icon,
    required DomainSidebarTheme theme,
    required bool isExpanded,
    required bool isSelected,
    required VoidCallback onTap,
    String? subtitle,
    List<Widget> badges = const [],
    bool dense = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: dense ? 4 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.selectedItemColor : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? theme.selectedItemBorderColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: dense ? 16 : 20,
              color: isSelected
                  ? theme.selectedItemIconColor
                  : theme.itemIconColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: (isSelected
                                  ? theme.selectedItemTextStyle
                                  : theme.itemTextStyle)
                              .copyWith(fontSize: dense ? 12 : null),
                        ),
                      ),
                      ...badges,
                    ],
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: theme.subtitleTextStyle.copyWith(
                        fontSize: dense ? 10 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (isExpanded)
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                size: dense ? 16 : 20,
                color: theme.itemIconColor,
              ),
          ],
        ),
      ),
    );
  }

  void _notifyItemSelected(DomainNavigationItem item) {
    widget.onItemSelected?.call(item);
    widget.shellApp.navigateTo(item.path);
  }

  /// Navigate to concept and show its entities
  void _navigateToConceptEntities(Concept concept, String path) {
    // Notify item selected as before (for backwards compatibility)
    widget.onItemSelected?.call(DomainNavigationItem(
      type: NavigationItemType.concept,
      path: path,
      title: concept.code,
      concept: concept,
    ));

    // Update navigation state and show entity manager view
    if (widget.shellApp.hasFeature('entity_creation') &&
        widget.shellApp.hasFeature('entity_editing')) {
      // If features are available, use the enhanced entity management view
      widget.shellApp.showEntityManager(
        context,
        concept.code,
        title: concept.code,
        initialViewMode: EntityViewMode.list,
        disclosureLevel: widget.shellApp.currentDisclosureLevel,
      );
    } else {
      // Fallback to regular navigation if features aren't available
      widget.shellApp.navigateTo(path);
    }
  }
}
