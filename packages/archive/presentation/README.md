# EDNet One Presentation Layer

This folder contains the presentation layer of the EDNet One application, which is responsible for the user interface, state management, and user interactions.

## Architecture

The presentation layer follows a clean, component-based architecture designed to promote separation of concerns, reusability, and maintainability. Key architectural components include:

- **Pages**: Container components that handle business logic and state management
- **Widgets**: Reusable UI components that are primarily presentational
- **State Management**: BLoC pattern is used for managing application state
- **Navigation**: Centralized routing system for consistent navigation
- **Theming**: Material Design based theming with custom extensions

## Directory Structure

```
presentation/
├── pages/          # Container components with business logic
├── screens/        # Legacy container components (being phased out)
├── widgets/        # Reusable presentational components 
├── state/          # State management
│   ├── blocs/      # BLoC pattern implementations
│   ├── models/     # UI models/DTOs
│   └── providers/  # Service providers
├── layouts/        # Layout components and strategies
├── navigation/     # Navigation service and routes
└── theme/          # Theme configuration
```

## Current State and Migration

This layer is currently undergoing a significant refactoring to improve architecture, component decomposition, and overall code quality. The main initiatives include:

1. Migration from dual structure (pages + screens) to a unified pages approach
2. Breaking down large components into smaller, focused ones
3. Implementing enhanced navigation with breadcrumbs
4. Adding a comprehensive bookmarking system
5. Implementing entity filtering and search capabilities

For detailed information, see:
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Defines architectural standards
- [MIGRATION-PLAN.md](./MIGRATION-PLAN.md) - Outlines the screen to page migration
- [PRESENTATION-REFACTORING-LONGTERM-MEMORY](../PRESENTATION-REFACTORING-LONGTERM-MEMORY) - Comprehensive refactoring plan

## Current Migration Status

The presentation layer is undergoing a migration from screens (legacy container components) to pages (modern container components). Here's the current status:

### Completed Migrations:
- ModelDetailScreenScaffold → ModelDetailPage
- DomainDetailScreen → DomainDetailPage
- GraphApp (in graph_application.dart) → GraphPage
- HomePage (screens version) → HomePage (pages/home version)
- DomainsWidget → DomainsPage with DomainsListWidget
- LeftSidebarWidget → ConceptsPage with ConceptsListWidget
- RightSidebarWidget → ModelsPage with ModelsListWidget
- MainContentWidget → EntityDetailPage
- BookmarkWidget → BookmarkPage with BookmarkListWidget

### In Progress:
- FilterWidget refactoring to support all entity types
- Creating comprehensive test suite for migrated components (60% coverage)
- Implementing consistent navigation and routing strategy
- Addressing remaining analyzer warnings

### Coming Soon:
- NavigationRail consolidation into layouts/navigation_layout.dart
- Dark mode support implementation
- Accessibility enhancements
- Component structure cleanup (Phase 3)

For detailed information on the migration progress and plan, see [MIGRATION-PLAN.md](./MIGRATION-PLAN.md).

## Key Components

### Pages

Pages are container components that handle business logic, state management, and data fetching. They:
- Connect to BLoCs and services
- Compose multiple widgets
- Handle routing and navigation
- Manage the overall state of a screen

Examples: `HomePage`, `ModelDetailPage`, `GraphPage`, `DomainsPage`

### Widgets

Widgets are reusable UI components that are primarily presentational. They:
- Accept data through props
- Emit events through callbacks
- Have minimal internal state
- Focus on rendering and user interaction

Examples: `EntityWidget`, `AttributeWidget`, `RelationshipNavigator`, `FilterListItem`

### BLoC Pattern

The BLoC (Business Logic Component) pattern is used for state management. Key components:
- **BLoCs**: Handle business logic and state transitions
- **Events**: Trigger state changes
- **States**: Represent the UI state at a point in time

Examples: `DomainSelectionBloc`, `ModelSelectionBloc`, `ConceptSelectionBloc`, `BookmarkBloc`

## Features and Capabilities

### Navigation System

The presentation layer implements a comprehensive navigation system:
- **Route Management**: Centralized route definitions
- **Breadcrumbs**: Consistent navigation path display
- **Deep Linking**: Support for direct access to specific entities
- **History Management**: Support for browser back/forward navigation

### Bookmarking System

A full-featured bookmarking system allows users to:
- Save frequently accessed entities
- Categorize bookmarks by type and purpose
- Search and filter bookmarks
- Share bookmarks between sessions

### Entity Filtering

The entity filtering system provides:
- Type-based filtering (concepts, models, domains)
- Text search functionality
- Advanced filter combinations
- Saved filter presets

## Best Practices

### Component Design

1. **Single Responsibility**: Each component should focus on a single responsibility
2. **Composition Over Inheritance**: Prefer composing smaller components
3. **Stateless When Possible**: Keep components stateless unless state is necessary
4. **Prop Drilling**: Pass only what's needed to each component
5. **Documentation**: Document component interfaces and usage

### Coding Standards

1. **Consistent Naming**: Follow established naming conventions
2. **Error Handling**: Implement proper error handling and recovery
3. **Testing**: Write tests for business logic and UI interactions
4. **Performance**: Consider performance implications, especially for large lists
5. **Accessibility**: Ensure components are accessible

## Development Guidelines

1. **Create New Components in Pages**: Do not add to the screens directory
2. **Follow Migration Plan**: When updating existing components
3. **Run Analyzer**: Ensure code passes Dart analyzer
4. **Document Changes**: Update relevant documentation
5. **Update Tests**: Keep tests in sync with implementation changes

## Performance Optimization

Current optimization efforts include:
1. Widget memoization for frequently used components
2. Selective rebuilds to avoid unnecessary UI updates
3. Lazy loading for complex component hierarchies
4. Virtualized scrolling for large entity lists
5. BLoC state optimization to minimize rebuilds

## Maintenance and Support

The presentation layer is actively maintained as part of the EDNet One application development. For questions or issues:

1. Review the documentation in this directory
2. Check the migration and refactoring plans
3. Consult with the development team

## Future Roadmap

After completing the current migration, planned improvements include:
1. Enhanced responsiveness for mobile and tablet views
2. Improved accessibility features
3. Advanced visualization capabilities for domain models
4. Integration with ednet_core for more direct domain model interaction
5. Comprehensive component showcase and documentation

# EDNet One Presentation Architecture

## The "Holy Trinity" Architecture

The EDNet One presentation layer is built on a flexible, domain-driven architecture we call the "Holy Trinity." This architecture cleanly separates three core concerns:

1. **Layout Strategy** - How UI components are sized and positioned
2. **Theme Strategy** - How UI components are visually styled
3. **Domain Model** - The underlying business concepts

By separating these concerns while maintaining semantic connections between them, we enable:

- Different visual presentations of the same domain model
- Layout adaptations for different screen sizes and contexts
- Consistent styling across the application
- User customization of layout and theme
- Strong semantic connection to the domain

## Key Components

### 1. Layout Strategy

Layout strategies are responsible for determining how UI components are sized, positioned and organized based on semantic concepts from the domain model.

- `LayoutStrategy` - Abstract interface for all layout strategies
- `CompactLayoutStrategy` - Implementation optimized for small screens and dense layouts
- `DetailedLayoutStrategy` - Implementation optimized for larger screens with more detailed information
- `LayoutProvider` - Provider that manages active layout strategy

**Example Usage:**

```dart
// Get layout constraints for a specific concept
final constraints = layoutProvider.activeStrategy
    .getConstraintsForConcept('User', parentConstraints);

// Build a container for a specific concept
final container = layoutProvider.activeStrategy.buildConceptContainer(
  context: context,
  conceptType: 'User',
  child: userProfileWidget,
);

// Use the SemanticConceptContainer widget
SemanticConceptContainer(
  conceptType: 'User',
  child: UserProfileWidget(),
)
```

### 2. Theme Strategy

Theme strategies are responsible for determining how UI components are visually styled based on semantic concepts from the domain model.

- `ThemeStrategy` - Abstract interface for all theme strategies
- `ThemeProvider` - Provider that manages active theme strategy

**Example Usage:**

```dart
// Get color for a specific concept
final color = themeProvider.activeStrategy
    .getColorForConcept('Error');

// Get text style for a specific concept
final textStyle = themeProvider.activeStrategy
    .getTextStyleForConcept('User', textRole: 'title');

// Use the extension methods
final errorColor = context.conceptColor('Error');
final titleStyle = context.conceptTextStyle('User', role: 'title');
```

### 3. Domain Model Integration

The domain model is connected to the UI through semantic concept identifiers. This maintains a clear separation between the domain model and its presentation while preserving semantic meaning.

**Example:**

```dart
// A User concept from the domain model is represented visually
SemanticConceptContainer(
  conceptType: 'User',
  child: Column(
    children: [
      Text(
        user.name,
        style: context.conceptTextStyle('User', role: 'name'),
      ),
      Text(
        user.email,
        style: context.conceptTextStyle('User', role: 'email'),
      ),
    ],
  ),
)
```

## Extending the Architecture

### Creating a Custom Layout Strategy

To create a custom layout strategy:

1. Create a new class that implements `LayoutStrategy`
2. Implement all required methods
3. Register it with the `LayoutProvider`

```dart
class MyCustomLayoutStrategy extends LayoutStrategy {
  @override
  String get id => 'my_custom';
  
  @override
  String get name => 'My Custom Layout';
  
  @override
  String get category => 'custom';
  
  // Implement the remaining methods...
}

// Register it
layoutProvider.registerStrategy(MyCustomLayoutStrategy());
```

### Creating a Custom Theme Strategy

To create a custom theme strategy:

1. Create a new class that implements `ThemeStrategy`
2. Implement all required methods
3. Register it with the `ThemeProvider`

```dart
class MyCustomThemeStrategy extends ThemeStrategy {
  @override
  String get id => 'my_custom';
  
  @override
  String get name => 'My Custom Theme';
  
  @override
  String get category => 'custom';
  
  // Implement the remaining methods...
}

// Register it
themeProvider.registerStrategy(MyCustomThemeStrategy());
```

## Benefits for Junior Developers

This architecture provides several benefits for junior developers:

1. **Clear Separation of Concerns** - You can focus on one aspect (layout, theme, or domain) at a time
2. **Consistent Patterns** - The same patterns are used throughout the codebase
3. **Semantic Connection** - UI components maintain their connection to domain concepts
4. **Extensibility** - New layout or theme strategies can be added without changing existing code
5. **Reusability** - Layout and theme strategies can be reused across the application

## Best Practices

1. **Always use semantic concept containers** - Wrap your widgets in `SemanticConceptContainer` to ensure proper layout
2. **Use the extension methods** - The extension methods (`conceptColor`, `conceptTextStyle`) make it easy to apply consistent styling
3. **Don't hardcode layout constraints** - Let the layout strategy determine constraints based on semantic concepts
4. **Don't hardcode colors or styles** - Let the theme strategy determine colors and styles based on semantic concepts
5. **Keep layout and theme concerns separate** - Don't mix layout and theme concerns in the same component

## Further Reading

- [Domain-Driven Design](https://domainlanguage.com/ddd/)
- [Flutter Layout Principles](https://flutter.dev/docs/development/ui/layout)
- [Flutter Theme System](https://flutter.dev/docs/cookbook/design/themes)
- [Provider Package](https://pub.dev/packages/provider) 