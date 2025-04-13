part of ednet_core_flutter;

/// A container component that manages both classic and tree-based sidebars
class SidebarContainer extends StatefulWidget {
  /// The shell app instance providing domain and navigation context
  final ShellApp shellApp;

  /// Optional custom theme for the sidebar
  final DomainSidebarTheme? theme;

  /// Callback when an artifact is selected
  final Function(String path)? onArtifactSelected;

  const SidebarContainer({
    super.key,
    required this.shellApp,
    this.theme,
    this.onArtifactSelected,
  });

  @override
  State<SidebarContainer> createState() => _SidebarContainerState();
}

class _SidebarContainerState extends State<SidebarContainer> {
  /// Current sidebar mode
  late SidebarMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.shellApp.configuration.sidebarMode == SidebarMode.both
        ? SidebarMode.classic
        : widget.shellApp.configuration.sidebarMode;
  }

  @override
  Widget build(BuildContext context) {
    final showToggle =
        widget.shellApp.configuration.sidebarMode == SidebarMode.both;

    return Column(
      children: [
        // Toggle button if both modes are enabled
        if (showToggle)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: [
                    _currentMode == SidebarMode.classic,
                    _currentMode == SidebarMode.tree,
                  ],
                  onPressed: (index) {
                    setState(() {
                      _currentMode =
                          index == 0 ? SidebarMode.classic : SidebarMode.tree;
                    });
                  },
                  children: const [
                    Tooltip(
                      message: 'Classic View',
                      child: Icon(Icons.view_list),
                    ),
                    Tooltip(
                      message: 'Tree View',
                      child: Icon(Icons.account_tree),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // Sidebar content
        Expanded(
          child: _currentMode == SidebarMode.classic
              ? DomainSidebar(
                  shellApp: widget.shellApp,
                  theme: widget.theme,
                  onItemSelected: (item) {
                    widget.onArtifactSelected?.call(item.path);
                  },
                )
              : TreeArtifactSidebar(
                  shellApp: widget.shellApp,
                  theme: widget.theme,
                  onArtifactSelected: widget.onArtifactSelected,
                ),
        ),
      ],
    );
  }
}
