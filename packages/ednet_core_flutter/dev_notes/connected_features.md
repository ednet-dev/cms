# Utilizing Underutilized Features in EDNet Core Flutter

This document outlines how to properly integrate and utilize the advanced features available in `ednet_core_flutter` that are often overlooked in client applications.

## Feature Activation in ShellConfiguration

The most important step is properly enabling features in the ShellConfiguration when creating your ShellApp instance:

```dart
final shellApp = ShellApp(
  domain: domain,
  configuration: ShellConfiguration(
    features: {
      // Core features
      'entity_editing',
      'entity_creation',
      
      // Advanced visualization and diff features
      'domain_model_diffing',
      'tree_navigation',
      
      // Meta-model runtime modifications
      ShellConfiguration.metaModelEditingFeature,
      
      // UX features
      ShellConfiguration.genericEntityFormFeature,
      ShellConfiguration.themeSwitchingFeature,
      ShellConfiguration.enhancedEntityCollectionFeature,
      
      // Other advanced features
      'development_mode',
      'filtering',
      'bookmarking',
      'deep_linking',
      'persistence',
    },
    sidebarMode: SidebarMode.both,
    defaultDisclosureLevel: DisclosureLevel.advanced,
  ),
);
```

## Domain Model Diffing

This feature allows tracking, exporting, and importing changes made to the domain model at runtime:

```dart
// Export the current model differences
String jsonDiff = shellApp.exportDomainModelDiff(domainCode);

// Import changes from a JSON diff
await shellApp.importDomainModelDiff(domainCode, jsonDiff);

// Save the current diff to a file
await shellApp.saveDomainModelDiffToFile(domainCode, 'domain_changes.json');

// Get the entire history of model changes
List<Map<String, dynamic>> history = await shellApp.getDomainModelDiffHistory(domainCode);
```

## Meta Model Editing

ShellApp provides a meta-model manager to modify domain models at runtime:

```dart
// Access the meta model manager
final metaModelManager = shellApp.metaModelManager;

// Operations vary based on implementation, but generally include:
// - Creating new concepts
// - Modifying existing concepts
// - Creating/modifying attributes
// - Creating/modifying relationships
```

## Tree Navigation

The TreeArtifactSidebar component provides a hierarchical view of the domain model:

```dart
TreeArtifactSidebar(
  shellApp: shellApp,
  onArtifactSelected: (path) {
    // Navigate to selected path
    shellApp.navigateTo(path);
  },
)
```

## Multiple Sidebar Modes

The SidebarMode enum provides different display options:

```dart
// Available modes:
// - SidebarMode.classic (traditional domain structure)
// - SidebarMode.tree (tree-based hierarchical view)
// - SidebarMode.both (toggle between classic and tree)
// - SidebarMode.compact (minimized space usage)
// - SidebarMode.hidden (no sidebar shown)

ShellConfiguration(
  sidebarMode: SidebarMode.both,
  // other configuration...
)
```

## Progressive Disclosure

Adjust UI complexity based on user needs with disclosure levels:

```dart
// Available levels:
// - DisclosureLevel.minimal (basic information only)
// - DisclosureLevel.basic (essential fields and actions)
// - DisclosureLevel.standard (balanced view)
// - DisclosureLevel.intermediate (more detailed information)
// - DisclosureLevel.advanced (comprehensive information)
// - DisclosureLevel.complete (all available information)
// - DisclosureLevel.debug (includes internal details)

// Set at configuration time
ShellConfiguration(
  defaultDisclosureLevel: DisclosureLevel.standard,
  // other configuration...
)

// Access or change current level at runtime
DisclosureLevel currentLevel = shellApp.currentDisclosureLevel;
shellApp.setDisclosureLevel(DisclosureLevel.advanced);
```

## Development Mode

Enable the development console for debugging and testing:

```dart
// In ShellConfiguration
features: {
  'development_mode',
  // other features...
},

// Use the control panel in your UI
DevelopmentModeControlPanel(
  adapter: DevelopmentModeChannelAdapter(shellApp),
)
```

## Enhanced Theme Management

The EnhancedThemeService provides advanced theme capabilities:

```dart
// Create enhanced theme service
final themeService = EnhancedThemeService(
  lightTheme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
);

// Listen for theme changes
themeService.addListener(() {
  // Update UI with new theme
});

// Switch theme mode
themeService.setThemeMode(ThemeMode.dark);

// Access accessibility features
themeService.setAccessibilityFeature('highContrast', true);
```

## Entity Relationship Management

The TreeArtifactSidebar supports relationship management via the UI:

```dart
// This is often handled through UI interactions in TreeArtifactSidebar
// When meta_model_editing is enabled, it shows dialogs to define relationships
```

## Deep Linking

Navigation service supports deep linking capabilities:

```dart
// Navigate using paths matching domain structure
shellApp.navigateTo('/DomainName/ModelName/ConceptName/EntityId');

// Navigate with a label for breadcrumbs
shellApp.navigateTo('/path/to/resource', label: 'Resource Details');
```

## ShellAppRunner Integration

The ShellAppRunner provides a complete environment for your domain model:

```dart
ShellAppRunner(
  shellApp: shellApp,
  theme: themeData,
)
```

By properly enabling and utilizing these features, you can leverage the full power of the ednet_core_flutter package in your applications. 