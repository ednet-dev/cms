part of ednet_core_flutter;

/// A specialized sidebar that displays the domain model hierarchy as a tree
/// with support for artifacts like domains, models, concepts, and their relationships.
class TreeArtifactSidebar extends StatefulWidget {
  /// The shell app instance providing domain and navigation context
  final ShellApp shellApp;

  /// Optional custom theme for the sidebar
  final DomainSidebarTheme? theme;

  /// Callback when an artifact is selected
  final Function(String path)? onArtifactSelected;

  const TreeArtifactSidebar({
    super.key,
    required this.shellApp,
    this.theme,
    this.onArtifactSelected,
  });

  @override
  State<TreeArtifactSidebar> createState() => _TreeArtifactSidebarState();
}

class _TreeArtifactSidebarState extends State<TreeArtifactSidebar> {
  /// Track expanded state of tree nodes
  final Map<String, bool> _expandedNodes = {};

  /// Currently selected path
  String? _selectedPath;

  void _navigationListener() {
    final path = widget.shellApp.navigationService.currentPath;
    setState(() {
      _selectedPath = path;
      // Auto-expand parent nodes of selected item
      _expandParentNodes(path);
    });
  }

  @override
  void initState() {
    super.initState();
    // Listen for navigation changes
    widget.shellApp.navigationService.addListener(_navigationListener);
    // Initialize with current path
    _navigationListener();
  }

  @override
  void dispose() {
    widget.shellApp.navigationService.removeListener(_navigationListener);
    super.dispose();
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
            _notifyArtifactSelected(path);
          },
          subtitle: domain.description,
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
            _notifyArtifactSelected(path);
          },
          subtitle: model.description,
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

    // Build concept badges
    final badges = <Widget>[];
    if (concept.entry) {
      badges.add(_buildBadge('Entry', theme.entryBadgeColor, theme));
    }
    if (concept.abstract) {
      badges.add(_buildBadge('Abstract', theme.abstractBadgeColor, theme));
    }

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
            _notifyArtifactSelected(path);
          },
          subtitle: concept.description,
          badges: badges,
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
                    concept.parents.map((parent) => parent.code).toList(),
                    Icons.arrow_upward,
                    theme,
                    path,
                  ),

                // Children
                if (concept.children.isNotEmpty)
                  _buildRelationshipGroup(
                    'Children',
                    concept.children.map((child) => child.code).toList(),
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
                _notifyArtifactSelected('$parentPath/$item');
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
            if (!dense)
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

  void _notifyArtifactSelected(String path) {
    widget.onArtifactSelected?.call(path);
    widget.shellApp.navigateTo(path);
  }
}
