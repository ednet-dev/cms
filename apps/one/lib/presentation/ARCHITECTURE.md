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