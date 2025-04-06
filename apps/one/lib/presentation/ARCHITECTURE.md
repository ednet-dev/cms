# EDNet One Presentation Layer Architecture

## Overview

The presentation layer follows a clean, component-based architecture that separates concerns and promotes reusability. This document defines the architectural standards, component responsibilities, and best practices for the presentation layer.

## Directory Structure

```
presentation/
├── pages/          # Container components (smart components)
├── screens/        # Container components for legacy support (being phased out)
├── widgets/        # Reusable presentational components (dumb components)
├── state/          # State management
│   ├── blocs/      # BLoC pattern implementations
│   ├── models/     # UI models/DTOs
│   └── providers/  # Service providers
├── layouts/        # Layout components and strategies
├── navigation/     # Navigation service and routes
└── theme/          # Theme configuration
```

## Component Hierarchy

### Pages vs. Screens

- **Pages**: Top-level container components that should be used for all new development
  - Responsible for data fetching, state management, and composing widgets
  - Connected to BLoCs and providers
  - Registered with Navigator routes
  - File naming: `*_page.dart`

- **Screens**: Legacy container components being phased out (do not create new screens)
  - Functionality being migrated to the pages structure
  - Will be deprecated once migration is complete
  - File naming: `*_screen.dart`

### Widgets

- **Presentational components** with minimal business logic
- Receive data through props and emit events through callbacks
- Should be stateless when possible
- Organized by feature or responsibility
- File naming: `*_widget.dart`

## State Management

- **BLoC Pattern**: Used for complex state management
  - Organized by feature in `state/blocs/feature_name/`
  - Each feature has events, states, and bloc files

- **Providers**: Service classes for data fetching and business logic
  - Injected into BLoCs and pages
  - Act as facade to domain layer

## Naming Conventions

- **Use PascalCase for component classes**: `EntityWidget`, `HomePage`
- **Use snake_case for files**: `entity_widget.dart`, `home_page.dart`
- **Consistent suffixes**:
  - Pages: `*Page` (class), `*_page.dart` (file)
  - Widgets: `*Widget` (class), `*_widget.dart` (file)
  - BLoCs: `*Bloc` (class), `*_bloc.dart` (file)
  - Events: `*Event` (class), `*_event.dart` (file)
  - States: `*State` (class), `*_state.dart` (file)
  - Services: `*Service` (class), `*_service.dart` (file)

## Best Practices

### Component Design

1. **Single Responsibility**: Each component should do one thing well
2. **Interface Segregation**: Components should expose minimal interfaces needed
3. **Composition**: Prefer composition over inheritance for component reuse
4. **Statelessness**: Keep most components stateless where possible
5. **Pure Rendering**: Separate rendering logic from business logic

### Performance

1. **Use const constructors** where appropriate
2. **Implement equatable** for efficient equality checks
3. **Avoid rebuilding large widget trees** unnecessarily
4. **Use lazy loading** for complex component hierarchies

### Flutter Specific

1. **Use super parameters** for widget constructors
2. **Use key parameter** for widgets that might be recreated within the same parent
3. **Replace deprecated APIs** with modern alternatives
4. **Follow Material Design guidelines** for consistent UI

## Refactoring Guidance

When refactoring existing code:

1. Move files to the appropriate directory based on responsibility
2. Rename files and classes to follow the naming conventions
3. Break large components into smaller, focused components
4. Update imports throughout the codebase
5. Verify build succeeds after each change
6. Run the application to ensure functionality is preserved

## Current Migration Status

- Migrating from `screens/` to `pages/` structure
- Decomposing large components into smaller, focused ones
- Implementing enhanced navigation and breadcrumb functionality
- Adding comprehensive bookmarking system
- Implementing entity filtering

## Component Structure

The presentation layer of EDNet One follows a nested component structure:

```
presentation/
  ├── pages/            # Full pages representing key user flows
  ├── widgets/          # Reusable UI components 
  ├── state/            # State management (BLoCs, providers)
  ├── theme/            # Theming and styling
  ├── layouts/          # Layout strategies and providers
  └── navigation/       # Navigation services and routes
```

## State Management Pattern

EDNet One uses a combination of:

1. **BLoC Pattern** for complex state with events, states, and transformations
2. **Provider Pattern** for simpler shared state and dependencies
3. **Repository Pattern** for data access

## Architecture Pattern: "Holy Trinity"

The presentation layer is built on what we call the "Holy Trinity" architecture, which separates three core concerns:

1. **Layout Strategy** - How UI components are sized and positioned
2. **Theme Strategy** - How UI components are visually styled  
3. **Domain Model** - The underlying business concepts

By making these three aspects pluggable and interchangeable while maintaining semantic connections, we achieve a flexible architecture that can adapt to different user preferences and device capabilities.

### Layout Strategy

Layout strategies determine how UI components are sized and positioned based on semantic concepts from the domain model. They are implemented in `presentation/layouts/strategy/`.

Key components:
- `LayoutStrategy` - Abstract interface
- `CompactLayoutStrategy` - For space-efficient layouts
- `DetailedLayoutStrategy` - For information-rich layouts
- `LayoutProvider` - Manages active strategy

### Theme Strategy

Theme strategies determine how UI components are visually styled based on semantic concepts from the domain model. They are implemented in `presentation/theme/strategy/`.

Key components:
- `ThemeStrategy` - Abstract interface
- `ThemeProvider` - Manages active strategy

### Semantic Components

These components connect layout and theme to domain concepts:

- `SemanticConceptContainer` - Applies appropriate layout to a domain concept
- `SemanticFlowContainer` - Arranges multiple components in a flow layout
- `SemanticConstraintsBuilder` - Provides semantic constraints for custom layouts

For more details on the Holy Trinity architecture, see the [README.md](README.md).

## Communication Patterns

1. **BLoC Events/States** - Component → BLoC → Component
2. **Provider Notifications** - Provider → Component
3. **Callbacks** - Child → Parent component
4. **Navigation** - Component → Router

## Design Principles

1. **Separation of Concerns** - UI, state, and business logic are separated
2. **Composition Over Inheritance** - Build complex UIs from simple components 
3. **Single Responsibility** - Each component has one purpose
4. **Domain-Driven Design** - UI components maintain semantic connection to domain
5. **Adaptability** - UI adapts to different screen sizes and device capabilities

## Future Directions

1. Better support for testing UI components
2. Improved accessibility 
3. Advanced visualization capabilities for domain models
4. Integration with ednet_core for more direct domain model interaction
5. Comprehensive component showcase and documentation 