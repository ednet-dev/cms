# Shell Architecture Migration Guide

## Overview

This document outlines the steps required to complete the integration of the Shell Architecture from the `ednet_core_flutter` package into the EDNet One application. The migration enables progressive disclosure, semantic styling, and better domain model representation in the UI.

## Current Status

We have successfully:
- Added the `ednet_core_flutter` package to the project dependencies
- Created the `PersonShowcase` to demonstrate progressive disclosure with different levels
- Integrated with existing domain models from OneApplication
- Set up components that respect semantic presentation rules
- Demonstrated the domain model representation with attributes and entities

## Remaining Tasks

### 1. Theme Integration

- **Issue**: There's an incompatibility in how ThemeExtensions are handled in the `standard_theme_strategy.dart` file. 
- **Solution**: We've simplified the theme extension application to resolve type conflicts.
- **Next Steps**: 
  - Test theme extensions like `DisclosureLevelThemeExtension` and `SemanticColorsExtension`
  - Create custom theme components specific to the application domain

### 2. ShellApp Integration

- **Goal**: Fully integrate with the ShellApp pattern for centralized domain-UI integration
- **Tasks**:
  ```dart
  // In main.dart
  final shellApp = ShellApp(
    domain: oneApplication.domain,
    configuration: ShellConfiguration(
      defaultDisclosureLevel: DisclosureLevel.basic,
      features: {'responsive_layout', 'semantic_pinning'},
    ),
  );
  
  runApp(ShellAppRunner(shellApp: shellApp));
  ```
- **Remaining Work**:
  - Complete integration without conflicts with existing implementations
  - Register domain adapters with the ShellApp registry

### 3. Navigation Integration

- **Goal**: Use the ShellNavigationService for domain model navigation
- **Tasks**:
  - Replace current navigation with ShellNavigationService
  - Integrate breadcrumb navigation for domain exploration
  - Ensure proper history management

### 4. Custom Adapters

- **Goal**: Create UX adapters for each entity type
- **Tasks**:
  - Implement entity-specific adapters for all main concepts
  - Register adapters through the adapter registry
  - Support progressive disclosure in all adapters

## Development Workflow

1. **Incremental Integration**: Approach the integration in small, testable pieces
2. **Component Verification**: Test each component in isolation before integration
3. **Parallel Systems**: Allow both approaches to coexist during transition
4. **Domain First**: Focus on domain model integration before UI components

## Testing Strategy

Each step in the migration should be tested for:

1. **Functionality**: Does it work as expected?
2. **Compatibility**: Does it work with existing code?
3. **Performance**: Does it maintain or improve performance?
4. **Usability**: Does it improve the user experience?

## Example: Shell Component Integration

```dart
// Example of integrating a domain entity visualization
final domain = oneApplication.domains.first;
final concept = // Find appropriate concept

// Create entity
final entity = concept.newEntity();
entity.setAttribute('key', value);

// Use Shell Architecture components to visualize
return DomainEntityCard.forEntity(
  entity: entity,
  disclosureLevel: DisclosureLevel.intermediate,
  child: YourCustomWidget(entity),
);
```

## Troubleshooting

1. **Theme Extensions**: If theme extension issues continue, consider creating a simplified theme extension model
2. **Type Errors**: Many issues stem from generic type mismatches - ensure proper type declarations
3. **Null Safety**: Ensure nullable types are properly handled with null checks
4. **Dependencies**: Verify all dependencies are properly registered in pubspec.yaml

## Conclusion

The Shell Architecture integration provides a more structured approach to domain-driven UI development with progressive disclosure capabilities. By following this migration guide, we can ensure a smooth transition to this new architectural approach while maintaining compatibility with existing code. 