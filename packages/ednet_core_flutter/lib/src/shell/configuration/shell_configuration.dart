part of ednet_core_flutter;

/// Configuration for the Shell app that allows customizing appearance, features, and behavior
class ShellConfiguration {
  /// Features enabled in the shell app
  final Set<String> features;

  /// Default theme mode for the app
  final ThemeMode? defaultThemeMode;

  /// The default disclosure level
  final DisclosureLevel? defaultDisclosureLevel;

  /// The sidebar mode
  final SidebarMode sidebarMode;

  /// Custom adapters for specific entity types
  final Map<Type, LayoutAdapter> customAdapters;

  /// Theme data for the app
  final ThemeData? theme;

  /// Dark theme data for the app
  final ThemeData? darkTheme;

  /// Whether to show a theme toggle in AppBar
  final bool showThemeToggleInAppBar;

  /// Whether to use Material 3 design
  final bool useMaterial3;

  /// Constructor for ShellConfiguration
  ShellConfiguration({
    Set<String>? features,
    this.defaultThemeMode,
    this.defaultDisclosureLevel,
    this.sidebarMode = SidebarMode.classic,
    Map<Type, LayoutAdapter>? customAdapters,
    this.theme,
    this.darkTheme,
    this.showThemeToggleInAppBar = true,
    this.useMaterial3 = true,
  })  : features = features ?? <String>{},
        customAdapters = customAdapters ?? <Type, LayoutAdapter>{};

  /// Static constant for the entity form feature key
  static const String genericEntityFormFeature = 'generic_entity_form';

  /// Static constant for the theme switching feature key
  static const String themeSwitchingFeature = 'theme_switching';

  /// Static constant for the entity collection view feature key
  static const String enhancedEntityCollectionFeature =
      'enhanced_entity_collection';

  /// Static constant for the meta model editing feature key
  static const String metaModelEditingFeature = 'meta_model_editing';

  /// Generate a default full-featured configuration
  static ShellConfiguration defaultConfiguration() {
    return ShellConfiguration(
      features: {
        'entity_editing',
        'entity_creation',
        'domain_model_diffing',
        'tree_navigation',
        'meta_model_editing',
        'development_mode',
        genericEntityFormFeature,
        themeSwitchingFeature,
        enhancedEntityCollectionFeature,
      },
      defaultDisclosureLevel: DisclosureLevel.standard,
      sidebarMode: SidebarMode.both,
      showThemeToggleInAppBar: true,
      useMaterial3: true,
    );
  }

  /// Creates a copy of this configuration with the given changes
  ShellConfiguration copyWith({
    Set<String>? features,
    ThemeMode? defaultThemeMode,
    DisclosureLevel? defaultDisclosureLevel,
    SidebarMode? sidebarMode,
    Map<Type, LayoutAdapter>? customAdapters,
    ThemeData? theme,
    ThemeData? darkTheme,
    bool? showThemeToggleInAppBar,
    bool? useMaterial3,
  }) {
    return ShellConfiguration(
      features: features ?? this.features,
      defaultThemeMode: defaultThemeMode ?? this.defaultThemeMode,
      defaultDisclosureLevel:
          defaultDisclosureLevel ?? this.defaultDisclosureLevel,
      sidebarMode: sidebarMode ?? this.sidebarMode,
      customAdapters: customAdapters ?? this.customAdapters,
      theme: theme ?? this.theme,
      darkTheme: darkTheme ?? this.darkTheme,
      showThemeToggleInAppBar:
          showThemeToggleInAppBar ?? this.showThemeToggleInAppBar,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
    );
  }
}

/// Sidebar mode for domain navigation
enum SidebarMode {
  /// Classic sidebar with domain structure
  classic,

  /// Tree-based sidebar
  tree,

  /// Both sidebar types available with toggle
  both,

  /// Compact mode
  compact,

  /// Hidden (no sidebar)
  hidden,
}
