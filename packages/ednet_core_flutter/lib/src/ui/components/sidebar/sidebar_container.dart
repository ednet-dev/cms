part of ednet_core_flutter;

/// A container for domain sidebars that supports toggling between classic and tree modes
class SidebarContainer extends StatefulWidget {
  /// The shell app to visualize
  final ShellApp shellApp;

  /// Custom sidebar theme
  final DomainSidebarTheme? theme;

  /// Callback when an artifact is selected from the tree view
  final void Function(String)? onArtifactSelected;

  /// Constructor
  const SidebarContainer({
    Key? key,
    required this.shellApp,
    this.theme,
    this.onArtifactSelected,
  }) : super(key: key);

  @override
  State<SidebarContainer> createState() => _SidebarContainerState();
}

class _SidebarContainerState extends State<SidebarContainer> {
  /// Whether to show the tree view (true) or classic view (false)
  bool _isTreeView = true;

  @override
  void initState() {
    super.initState();

    // Initialize tree view based on domain manager setting if available
    if (widget.shellApp.domainManager != null) {
      _isTreeView = widget.shellApp.domainManager!.isTreeMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Support switching sidebar modes if configuration allows both
    final sidebarMode = widget.shellApp.configuration.sidebarMode;
    final showToggle = sidebarMode == SidebarMode.both;

    return Column(
      children: [
        // Show toggle only if both sidebar modes are enabled
        if (showToggle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sidebar Mode',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ToggleButtons(
                  isSelected: [!_isTreeView, _isTreeView],
                  onPressed: (index) {
                    setState(() {
                      _isTreeView = index == 1;

                      // Update domain manager if available
                      if (widget.shellApp.domainManager != null) {
                        widget.shellApp.domainManager!.setTreeMode(_isTreeView);
                      }
                    });
                  },
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 32),
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Icon(Icons.list, size: 18),
                    Icon(Icons.account_tree, size: 18),
                  ],
                ),
              ],
            ),
          ),

        // Show the appropriate sidebar based on current mode
        Expanded(
          child: _isTreeView
              ? TreeArtifactSidebar(
                  shellApp: widget.shellApp,
                  theme: widget.theme,
                  onArtifactSelected: widget.onArtifactSelected,
                )
              : DomainSidebar(
                  shellApp: widget.shellApp,
                  onItemSelected: (item) {
                    // Convert navigation item to path and call artifact selected callback
                    if (widget.onArtifactSelected != null) {
                      var path = '/';

                      if (item.model != null) {
                        path = '/domain/${item.model!.code}';

                        if (item.concept != null) {
                          path = '$path/${item.concept!.code}';
                        }
                      }

                      widget.onArtifactSelected!(path);
                    }
                  },
                ),
        ),
      ],
    );
  }
}
