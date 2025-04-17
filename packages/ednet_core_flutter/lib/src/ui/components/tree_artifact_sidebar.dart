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

  /// Animation duration for expand/collapse
  static const _animationDuration = Duration(milliseconds: 200);
  static const _animationCurve = Curves.easeInOut;

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

    return Material(
      child: Container(
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
      ),
    );
  }

  Widget _buildDomainHeader(DomainSidebarTheme theme) {
    return Material(
      color: Colors.transparent,
      child: Container(
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
        _buildTreeItem(
          title: domain.code,
          icon: Icons.domain,
          theme: theme,
          isExpanded: isExpanded,
          isSelected: _selectedPath == path,
          onTap: () => _notifyArtifactSelected(path),
          subtitle: domain.description,
          uniqueId: domain.oid.toString(),
        ),
        _buildExpandableSection(
          isExpanded: isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: domain.models
                  .map((model) =>
                      _buildModelNode(model, theme, parentPath: path))
                  .toList(),
            ),
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
        _buildTreeItem(
          title: model.code,
          icon: Icons.data_object,
          theme: theme,
          isExpanded: isExpanded,
          isSelected: _selectedPath == path,
          onTap: () => _notifyArtifactSelected(path),
          subtitle: model.description,
          uniqueId: model.oid.toString(),
        ),
        _buildExpandableSection(
          isExpanded: isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: model.concepts
                  .map((concept) =>
                      _buildConceptNode(concept, theme, parentPath: path))
                  .toList(),
            ),
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
        _buildTreeItem(
          title: concept.code,
          icon: conceptIcon,
          theme: theme,
          isExpanded: isExpanded,
          isSelected: _selectedPath == path,
          onTap: () => _notifyArtifactSelected(path),
          subtitle: concept.description,
          badges: badges,
          uniqueId: concept.oid.toString(),
        ),
        _buildExpandableSection(
          isExpanded: isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (concept.parents.isNotEmpty)
                  _buildRelationshipGroup(
                    'Parents',
                    concept.parents.map((parent) => parent.code).toList(),
                    Icons.arrow_upward,
                    theme,
                    path,
                    concept,
                  ),
                if (concept.children.isNotEmpty)
                  _buildRelationshipGroup(
                    'Children',
                    concept.children.map((child) => child.code).toList(),
                    Icons.arrow_downward,
                    theme,
                    path,
                    concept,
                  ),
              ],
            ),
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
    Concept concept,
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
                _safeNavigateToRelationship(parentPath, item, concept);
              },
              dense: true,
              uniqueId: '$title-$item',
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
    String? uniqueId,
  }) {
    // Create a guaranteed unique key using both title and uniqueId if available
    final keyString =
        uniqueId != null ? 'tree_item_${title}_$uniqueId' : 'tree_item_$title';

    return InkWell(
      key: ValueKey(keyString),
      onTap: () => onTap(),
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
            // Collapsible indicator button
            if (!dense)
              IconButton(
                icon: AnimatedRotation(
                  duration: _animationDuration,
                  turns: isExpanded ? 0.25 : 0,
                  child: const Icon(Icons.chevron_right),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                iconSize: 20,
                splashRadius: 20,
                color: theme.itemIconColor,
                onPressed: () {
                  setState(() {
                    _expandedNodes[title] = !isExpanded;
                  });
                },
              ),
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
                key: ValueKey('tree_item_content_$title'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          key: ValueKey(
                              'tree_item_text_$title${isExpanded ? '_expanded' : ''}'),
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
                      key: ValueKey('tree_item_subtitle_$title'),
                      style: theme.subtitleTextStyle.copyWith(
                        fontSize: dense ? 10 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required bool isExpanded,
    required Widget child,
  }) {
    return AnimatedCrossFade(
      firstChild: Container(),
      secondChild: child,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: _animationDuration,
      sizeCurve: _animationCurve,
      firstCurve: _animationCurve,
      secondCurve: _animationCurve,
    );
  }

  void _notifyArtifactSelected(String path) {
    widget.onArtifactSelected?.call(path);
    widget.shellApp.navigateTo(path);
  }

  /// Safely navigate to a relationship with exception handling
  void _safeNavigateToRelationship(
      String parentPath, String relationshipCode, Concept concept) {
    try {
      // Check if meta-model editing is enabled
      final hasMetaModelEditing = widget.shellApp
          .hasFeature(ShellConfiguration.metaModelEditingFeature);

      // Try to access the relationship safely
      final relationship = hasMetaModelEditing
          ? concept.getRelationship(relationshipCode)
          : null;

      if (relationship != null || !hasMetaModelEditing) {
        // Navigate normally if relationship exists or meta-model editing is not enabled
        _notifyArtifactSelected('$parentPath/$relationshipCode');
      } else {
        // Show dialog to create relationship if meta-model editing is enabled
        _showDefineMissingRelationshipDialog(concept, relationshipCode);
      }
    } catch (e) {
      if (e is ConceptException &&
          widget.shellApp
              .hasFeature(ShellConfiguration.metaModelEditingFeature)) {
        // Show dialog to create relationship if meta-model editing is enabled
        _showDefineMissingRelationshipDialog(concept, relationshipCode);
      } else {
        // Fallback behavior
        debugPrint('Error navigating to relationship: $e');
        _showErrorSnackbar(
            'Could not navigate to relationship: $relationshipCode');
      }
    }
  }

  /// Show dialog to define a missing relationship
  void _showDefineMissingRelationshipDialog(
      Concept concept, String relationshipCode) {
    final context = GlobalNavigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) => RelationshipDefinitionDialog(
          shellApp: widget.shellApp,
          concept: concept,
          relationshipCode: relationshipCode,
        ),
      );
    } else {
      // Fallback if GlobalNavigatorKey is not available
      showDialog(
        context: this.context,
        builder: (context) => RelationshipDefinitionDialog(
          shellApp: widget.shellApp,
          concept: concept,
          relationshipCode: relationshipCode,
        ),
      );
    }
  }

  /// Show error message in a snackbar
  void _showErrorSnackbar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
