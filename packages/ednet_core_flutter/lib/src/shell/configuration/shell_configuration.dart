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

  /// Meta-model editing features
  static const String metaModelEditingFeature = 'meta_model_editing';
  static const String conceptManagementFeature = 'concept_management';
  static const String relationshipManagementFeature = 'relationship_management';
  static const String attributeManagementFeature = 'attribute_management';
  static const String domainModelDiffingFeature = 'domain_model_diffing';
  static const String genericEntityFormFeature = 'generic_entity_form';

  /// Common feature sets as named presets
  static final Map<String, Set<String>> featurePresets = {
    'minimal': {
      'basic_visualization',
    },
    'standard': {
      'basic_visualization',
      'entity_creation',
      'entity_editing',
      'filtering',
      'sorting',
      'persistence',
      'breadcrumbs',
      'tree_navigation',
      domainModelDiffingFeature,
      genericEntityFormFeature,
    },
    'developer': {
      'basic_visualization',
      'rich_visualization',
      'entity_creation',
      'entity_editing',
      'advanced_navigation',
      'breadcrumbs',
      'filtering',
      'sorting',
      'domain_analytics',
      'export_features',
      'persistence',
      'development_mode',
      'tree_navigation',
      metaModelEditingFeature,
      conceptManagementFeature,
      relationshipManagementFeature,
      attributeManagementFeature,
      domainModelDiffingFeature,
      genericEntityFormFeature,
    },
  };

  /// Constructor
  ShellConfiguration({
    this.defaultDisclosureLevel,
    Map<Type, LayoutAdapter>? customAdapters,
    Set<String>? features,
    this.theme,
    this.sidebarMode = SidebarMode.both,
  })  : customAdapters = customAdapters ?? {},
        features = features ?? <String>{};

  /// Create a configuration from a preset
  factory ShellConfiguration.fromPreset(
    String preset, {
    DisclosureLevel? defaultDisclosureLevel,
    Map<Type, LayoutAdapter>? customAdapters,
    Set<String>? additionalFeatures,
    ThemeData? theme,
    SidebarMode? sidebarMode,
  }) {
    final presetFeatures = featurePresets[preset] ?? <String>{};
    final features = Set<String>.from(presetFeatures);

    if (additionalFeatures != null) {
      features.addAll(additionalFeatures);
    }

    return ShellConfiguration(
      defaultDisclosureLevel: defaultDisclosureLevel,
      customAdapters: customAdapters,
      features: features,
      theme: theme,
      sidebarMode: sidebarMode ?? SidebarMode.both,
    );
  }

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
