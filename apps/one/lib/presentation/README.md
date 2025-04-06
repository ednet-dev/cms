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