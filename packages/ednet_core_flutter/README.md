# EDNet Core Flutter

A Flutter UI generation and interpretation framework for EDNet Core domain models, providing an intelligent shell for domain-driven applications.

[![pub package](https://img.shields.io/pub/v/ednet_core_flutter.svg)](https://pub.dev/packages/ednet_core_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Overview

EDNet Core Flutter enables rapid development of Flutter applications driven by domain models defined with EDNet Core. The package automatically generates UI components, navigation flows, and interactive elements based on your domain model's metadata, semantics, and relationships.

## Features

- **Dynamic UI Generation**: Create lists, details, and forms directly from domain models
- **Progressive Disclosure**: Adjust UI complexity based on user needs
- **Domain-Driven Theme System**: Theme components based on domain semantics
- **Powerful Navigation**: Navigate complex domain relationships with breadcrumbs
- **Command & Event Integration**: Dispatch commands and subscribe to domain events
- **Policy-Based UI**: Customize UI based on user permissions
- **Plugin System**: Extend with custom components and generators
- **Master-Detail Navigation**: Seamlessly navigate from domains to models and down to individual entities
- **Breadcrumb Navigation**: Maintain context with clear breadcrumb trails that reflect your domain hierarchy
- **Filtering & Search**: Quickly find specific entities and data using robust filtering capabilities
- **Bookmarking**: Save and return to specific points in your data exploration journey
- **Multiplatform Support**: Run applications on Android, iOS, Web, and Desktop with consistent UX
- **Canvas Visualization**: Graphically represent relationships between domain entities using interactive visual canvases
- **Advanced Graph Layouts**: Apply circular, hierarchical, and force-directed algorithms to visualize domain complexity
- **Repository Abstraction**: Connect to various data sources with built-in repository implementations
- **Integration Capabilities**: Ready-made connectors for external services and APIs
- **Shell Architecture**: Comprehensive runtime environment for domain models with enterprise integration patterns
- **Configuration Injection**: Flexible configuration system with YAML support and priority-based application
- **Application Service Abstraction**: Bridge between domain model aggregates and higher-order user stories

## Installation

```yaml
dependencies:
  ednet_core_flutter: ^1.0.0
  ednet_core: ^1.0.0
```

## Basic Usage

### Set up the Shell Interpreter

```dart
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  // Initialize your domain model
  final domain = Domain('MyDomain');
  // ... define your domain model
  
  // Initialize the Shell Interpreter
  final shell = EDNetShell(
    domain: domain,
    themeStrategy: CheerfulThemeStrategy(),
    disclosureLevel: DisclosureLevel.standard,
  );
  
  runApp(MyApp(shell: shell));
}

class MyApp extends StatelessWidget {
  final EDNetShell shell;
  
  const MyApp({Key? key, required this.shell}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDNet Application',
      theme: shell.themeData,
      home: shell.dashboardPage(),
    );
  }
}
```

### Display a Concept List

```dart
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'package:flutter/material.dart';

class ConceptListPage extends StatelessWidget {
  final String conceptName;
  
  const ConceptListPage({Key? key, required this.conceptName}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final shell = EDNetShell.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(conceptName)),
      body: shell.listViewFor(
        conceptName: conceptName,
        columns: ['name', 'description', 'createdAt'],
        onTap: (entity) => shell.navigateToDetail(entity),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => shell.navigateToForm(conceptName),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Architecture

EDNet Core Flutter follows a component-based architecture that integrates with EDNet Core domain models:

### Core Components

- **DomainMetadataInterpreter**: Extracts and caches metadata from domain models
- **ConceptUIMapper**: Maps domain concepts to appropriate UI representations
- **ListViewGenerator**: Creates list views for domain concepts
- **DetailViewGenerator**: Creates detail views for entity instances
- **FormBuilder**: Generates forms for entity creation and editing
- **NavigationService**: Handles navigation between domain entities
- **CommandDispatcher**: Issues domain commands from UI actions
- **EventSubscriber**: Listens for domain events and updates UI
- **PolicyEvaluator**: Checks user permissions for UI actions
- **DisclosureManager**: Controls UI complexity level
- **BreadcrumbManager**: Generates context-aware navigation breadcrumbs
- **CanvasRenderer**: Visualizes domain models and relationships graphically
- **FilteringService**: Provides dynamic filtering and search capabilities
- **BookmarkService**: Manages saved navigation states and entity references
- **ShellApp**: Central coordinating component that interprets domain models and manages the UI layer
- **ConfigurationInjector**: Flexible configuration system using dependency injection principles
- **CanonicalModelAdapter**: Standardizes entity representation for consistent UI rendering
- **UXCustomizationSystem**: Provides field descriptors, adapters, and validators with progressive disclosure

### Enterprise Integration Patterns

The architecture leverages several patterns from Enterprise Integration Patterns:

1. **Channel Adapter (ModelUXChannelAdapter)**: Bridges domain models with UI components
2. **Message Filter (UXComponentFilter)**: Selectively processes UI components based on criteria
3. **Message Aggregator (DomainModelVisualizer)**: Combines related entities for visualization
4. **Canonical Data Model (UXCanonicalModel)**: Standardizes entity representation for UI consumption

```dart
// Example of using the Channel Adapter pattern
final channelAdapter = ModelUXChannelAdapter(
  sourceChannel: domainEventChannel,
  targetChannel: uiUpdateChannel,
  transformer: (domainEvent) => UXUpdateMessage.fromDomainEvent(domainEvent),
);

// Example of using the Message Filter pattern
final filter = UXComponentFilter(
  criteria: EntityFilterCriteria.ofType('Task')
    .and(EntityFilterCriteria.whereAttribute('status', 'active')),
  sourceChannel: componentChannel,
  targetChannel: filteredComponentChannel,
);

// Start processing
channelAdapter.start();
filter.start();
```

### Theme System

The package includes a sophisticated theme system that adapts UI based on:

1. **Progressive Disclosure Level**: Adjust UI complexity from minimal to debug
2. **Semantic Styling**: Apply consistent styling based on concept type
3. **Theme Components**: Choose from Cheerful, CLI, or Minimalistic theme styles

```dart
// Apply a theme with disclosure level
final shell = EDNetShell(
  domain: domain,
  themeStrategy: CheerfulThemeStrategy(),
  disclosureLevel: DisclosureLevel.intermediate,
);

// Update disclosure level
shell.setDisclosureLevel(DisclosureLevel.advanced);

// Switch theme component
shell.setThemeComponent(CLIThemeComponent());
```

## Advanced Usage

### Custom Form Fields

```dart
final shell = EDNetShell(
  domain: domain,
  customFieldBuilders: {
    'geolocation': (attribute, entity) => GeolocationField(
      initialValue: entity?.getAttribute(attribute.name),
      onChanged: (value) => entity?.setAttribute(attribute.name, value),
    ),
  },
);
```

### Policy-Based UI

```dart
final shell = EDNetShell(
  domain: domain,
  policyProvider: (user, action, resource) {
    // Implement your permission logic
    return user.hasPermission(action, resource);
  },
);
```

### Custom Navigation

```dart
shell.navigationService.registerRoute(
  'dashboard',
  (context) => DashboardPage(),
);

shell.navigationService.navigateTo(
  'dashboard',
  arguments: {'filter': 'recent'},
);
```

### Command Handling

```dart
// Dispatch a command
shell.commandDispatcher.dispatch(
  CreateEntityCommand(
    conceptName: 'Task',
    attributes: {'name': 'New Task', 'dueDate': DateTime.now()},
  ),
);

// Subscribe to events
shell.eventSubscriber.subscribe('TaskCreated', (event) {
  // Handle the event
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Task created: ${event.data['name']}')),
  );
});
```

### Domain Visualization

```dart
// Create a canvas visualization of your domain model
final canvas = shell.canvasRenderer.buildDomainCanvas(
  domain: domain,
  layout: GraphLayout.forceBased,
  showAttributes: true,
  highlightConcept: 'Task',
);

// Add the canvas to your widget tree
return Scaffold(
  body: DomainModelCanvas(
    canvas: canvas,
    onConceptTap: (concept) => shell.navigateToList(concept.name),
    onRelationshipTap: (relationship) => showRelationshipDetails(relationship),
  ),
);
```

### Storage Repositories

```dart
// Configure repositories for your domain
final shell = EDNetShell(
  domain: domain,
  repositoryProviders: {
    'Task': JsonFileRepository<Task>(
      path: 'data/tasks.json',
      fromJson: Task.fromJson,
      toJson: (task) => task.toJson(),
    ),
    'Project': FirestoreRepository<Project>(
      collection: 'projects',
      fromJson: Project.fromJson,
      toJson: (project) => project.toJson(),
    ),
  },
);
```

### Shell Configuration

Configure the shell with various options:

```dart
// Create a shell configuration
final config = ShellConfiguration(
  defaultDisclosureLevel: DisclosureLevel.basic,
  features: {'filtering', 'sorting', 'export'},
);

// Apply configuration with the injector
final injector = ConfigurationInjector();
injector.registerConfiguration(
  YAMLConfiguration.fromString('''
  ux:
    name: "My App Configuration"
    priority: 10
    defaultDisclosureLevel: intermediate
    
    fieldCustomizations:
      TaskEntity:
        dueDate:
          displayName: "Deadline"
          disclosureLevel: basic
          validators:
            - type: required
              message: "A deadline is required for all tasks"
  '''),
  ConfigurationType.ux,
);

// Apply configurations to shell
injector.configure(shell);
```

### UX Adapters

Create custom UX adapters to control how entities are displayed:

```dart
// Create a custom adapter
class ProjectUXAdapter extends ProgressiveUXAdapter<ProjectEntity> {
  @override
  Widget buildListItem(BuildContext context, {
    required ProjectEntity entity,
    DisclosureLevel disclosureLevel = DisclosureLevel.minimal
  }) {
    return ProjectListItem(
      project: entity,
      disclosureLevel: disclosureLevel,
      onTap: () => navigateToDetail(context, entity),
    );
  }
  
  @override
  Widget buildDetailView(BuildContext context, {
    required ProjectEntity entity,
    DisclosureLevel disclosureLevel = DisclosureLevel.standard
  }) {
    return ProjectDetailView(
      project: entity,
      disclosureLevel: disclosureLevel,
    );
  }
}

// Register the adapter
shell.registerAdapter<ProjectEntity>(
  () => ProjectUXAdapter(),
  disclosureLevel: DisclosureLevel.all,
);
```

### Application Services

Bridge between domain model aggregates and higher-order user stories:

```dart
// Define an application service
class ProjectApplicationService implements ApplicationService {
  final ProjectRepository repository;
  final TaskRepository taskRepository;
  
  ProjectApplicationService({
    required this.repository,
    required this.taskRepository,
  });
  
  Future<void> createProjectWithTasks({
    required String name,
    required String description,
    required List<String> taskNames,
  }) async {
    // Create project
    final project = Project(name: name, description: description);
    await repository.save(project);
    
    // Create tasks
    for (final taskName in taskNames) {
      final task = Task(
        name: taskName,
        projectId: project.id,
      );
      await taskRepository.save(task);
    }
  }
}

// Register with the shell
shell.registerApplicationService<ProjectApplicationService>(
  ProjectApplicationService(
    repository: projectRepository,
    taskRepository: taskRepository,
  ),
);

// Use the application service
final projectService = shell.getApplicationService<ProjectApplicationService>();
await projectService.createProjectWithTasks(
  name: 'New Project',
  description: 'A sample project',
  taskNames: ['Task 1', 'Task 2', 'Task 3'],
);
```

## Customization

### Plugin System

Extend the shell with custom components:

```dart
shell.pluginRegistry.register(
  'customListView',
  (concept) => CustomListViewGenerator(concept),
);

// Use the custom component
final listView = shell.pluginRegistry.get('customListView', concept);
```

### Custom Theme Extensions

Create your own theme extensions:

```dart
class MyThemeExtension extends ThemeExtension<MyThemeExtension> {
  final Color specialColor;
  
  MyThemeExtension({required this.specialColor});
  
  @override
  ThemeExtension<MyThemeExtension> copyWith({Color? specialColor}) {
    return MyThemeExtension(
      specialColor: specialColor ?? this.specialColor,
    );
  }
  
  @override
  ThemeExtension<MyThemeExtension> lerp(
    ThemeExtension<MyThemeExtension>? other, double t) {
    if (other is! MyThemeExtension) return this;
    return MyThemeExtension(
      specialColor: Color.lerp(specialColor, other.specialColor, t)!,
    );
  }
}

// Register the extension
shell.themeService.registerExtension(
  () => MyThemeExtension(specialColor: Colors.purple),
);
```

### Integration Services

Connect your application with external services:

```dart
// Register an integration service
shell.integrationRegistry.register(
  'calendar',
  CalendarIntegrationService(
    apiKey: 'your-api-key',
    onEventCreated: (event) {
      // Handle calendar event creation
    },
  ),
);

// Use the integration service
final calendarService = shell.integrationRegistry.get('calendar');
calendarService.createEvent(
  title: 'Team Meeting',
  startTime: DateTime.now().add(Duration(hours: 1)),
  duration: Duration(hours: 1),
);
```

## Roadmap Features

The following advanced features are planned for future releases:

- **Inline Domain Editing**: Edit domain models directly within the UI
- **Model Merge & Sync**: Automated processes to merge local changes with remote domain definitions
- **Identity & Security Management**: Integration with major authentication providers
- **AI-Powered Insights**: Smart suggestions for domain modeling and UI improvements
- **Live Collaboration**: Multiple team members editing the domain graph simultaneously
- **Advanced Testing Tools**: Scenario simulations and domain validation

## Examples

Check out the example directory for complete applications built with EDNet Core Flutter:

- **TaskManager**: A simple task management application
- **InventorySystem**: An inventory tracking system with complex relationships
- **UserPortal**: A user management portal with policy-based UI

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Underutilized Features

The following features are implemented in the package but may not be fully utilized in client applications:

1. **Domain Model Diffing**: Track, export, and import changes to domain models at runtime with `exportDomainModelDiff`, `importDomainModelDiff`, and `saveDomainModelDiffToFile`.

2. **Enhanced Theme Management**: Advanced theme capabilities including accessibility features (high contrast, large text, reduced motion) and custom theme styles.

3. **Filtering System**: Comprehensive filter service for entities with dynamic criteria.

4. **Bookmarking System**: Save and restore navigation states with the `BookmarkService` and `BookmarkSidebar`.

5. **Semantic Pinning**: Pin important views and entities for quick access with `SemanticPinningService`.

6. **Meta Model Editing**: Runtime modification of domain models using `MetaModelManager` and `MetaModelPersistenceManager`.

7. **Advanced Canvas Visualization**: Rich visual representation of domain relationships with custom layout algorithms.

8. **Deep Linking**: Navigate directly to specific application parts from external sources.

9. **Entity Relationship Management**: UI-based definition and modification of entity relationships.

10. **Application Service Abstraction**: Higher-order abstractions connecting domain models to business workflows.

11. **Policy-Based UI**: Permission-based UI customization for different user roles.

12. **Integration Services**: Connect with external services and APIs.

13. **Multiple Sidebar Modes**: Various sidebar display options including classic, tree, compact, and hidden modes.

14. **Progressive Disclosure**: Adjust UI complexity based on user needs with customizable disclosure levels.

To enable these features, add the appropriate feature flags in your `ShellConfiguration`:

```dart
final shellApp = ShellApp(
  domain: domain,
  configuration: ShellConfiguration(
    features: {
      'domain_model_diffing',
      'meta_model_editing',
      'enhanced_theme',
      'bookmarking',
      'filtering',
      'deep_linking',
      'tree_navigation',
      ShellConfiguration.genericEntityFormFeature,
      ShellConfiguration.themeSwitchingFeature,
      ShellConfiguration.enhancedEntityCollectionFeature,
      ShellConfiguration.metaModelEditingFeature,
    },
    sidebarMode: SidebarMode.both,
    defaultDisclosureLevel: DisclosureLevel.advanced,
  ),
);
```
