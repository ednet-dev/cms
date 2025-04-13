part of ednet_core_flutter;

/// Configuration for the Shell App
class ShellConfiguration {
  /// Default disclosure level for the shell
  final DisclosureLevel? defaultDisclosureLevel;

  /// Custom adapters for entity types
  final Map<Type, LayoutAdapter> customAdapters;

  /// Enabled features
  final Set<String> features;

  /// Custom theme for the shell
  final ThemeData? theme;

  /// Sidebar mode configuration
  final SidebarMode sidebarMode;

  /// Constructor
  ShellConfiguration({
    this.defaultDisclosureLevel,
    Map<Type, LayoutAdapter>? customAdapters,
    Set<String>? features,
    this.theme,
    this.sidebarMode = SidebarMode.both,
  })  : customAdapters = customAdapters ?? {},
        features = features ?? <String>{};

  /// Create a copy with modified values
  ShellConfiguration copyWith({
    DisclosureLevel? defaultDisclosureLevel,
    Map<Type, LayoutAdapter>? customAdapters,
    Set<String>? features,
    ThemeData? theme,
    SidebarMode? sidebarMode,
  }) {
    return ShellConfiguration(
      defaultDisclosureLevel:
          defaultDisclosureLevel ?? this.defaultDisclosureLevel,
      customAdapters: customAdapters ?? Map.from(this.customAdapters),
      features: features ?? Set.from(this.features),
      theme: theme ?? this.theme,
      sidebarMode: sidebarMode ?? this.sidebarMode,
    );
  }
}

/// Sidebar mode options
enum SidebarMode {
  /// Classic domain sidebar with expandable sections
  classic,

  /// Tree-based artifact sidebar with full domain hierarchy
  tree,

  /// Both sidebars available with toggle
  both
}
