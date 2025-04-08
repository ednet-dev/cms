# EDNet One Presentation Layer Memory

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Directory Structure](#directory-structure)
- [Component Hierarchy](#component-hierarchy)
- [State Management](#state-management)
- [Design Principles](#design-principles)
- [Holy Trinity Architecture](#holy-trinity-architecture)
- [Migration Plan](#migration-plan)
- [Migration Progress](#migration-progress)
- [Current Focus & Next Steps](#current-focus--next-steps)
- [Follow-up Tasks](#follow-up-tasks)
- [Shell App Migration](#shell-app-migration)
- [Development Guidelines](#development-guidelines)
- [Post-Migration Improvements](#post-migration-improvements)

## Architecture Overview

The presentation layer follows a clean, component-based architecture that separates concerns and promotes reusability. The architecture is built on what we call the "Holy Trinity" architecture, which separates three core concerns:

1. **Layout Strategy** - How UI components are sized and positioned
2. **Theme Strategy** - How UI components are visually styled  
3. **Domain Model** - The underlying business concepts

By making these three aspects pluggable and interchangeable while maintaining semantic connections, we achieve a flexible architecture that can adapt to different user preferences and device capabilities.

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

## Holy Trinity Architecture

The "Holy Trinity" architecture is built on three core components:

### Layout Strategy

Layout strategies determine how UI components are sized and positioned based on semantic concepts from the domain model.

Key components:
- `LayoutStrategy` - Abstract interface
- `CompactLayoutStrategy` - For space-efficient layouts
- `DetailedLayoutStrategy` - For information-rich layouts
- `LayoutProvider` - Manages active strategy

### Theme Strategy

Theme strategies determine how UI components are visually styled based on semantic concepts from the domain model.

Key components:
- `ThemeStrategy` - Abstract interface
- `ThemeProvider` - Manages active strategy

### Semantic Components

These components connect layout and theme to domain concepts:

- `SemanticConceptContainer` - Applies appropriate layout to a domain concept
- `SemanticFlowContainer` - Arranges multiple components in a flow layout
- `SemanticConstraintsBuilder` - Provides semantic constraints for custom layouts

## Design Principles

1. **Separation of Concerns** - UI, state, and business logic are separated
2. **Composition Over Inheritance** - Build complex UIs from simple components 
3. **Single Responsibility** - Each component has one purpose
4. **Domain-Driven Design** - UI components maintain semantic connection to domain
5. **Adaptability** - UI adapts to different screen sizes and device capabilities

### Communication Patterns

1. **BLoC Events/States** - Component → BLoC → Component
2. **Provider Notifications** - Provider → Component
3. **Callbacks** - Child → Parent component
4. **Navigation** - Component → Router

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

## Migration Plan

### Key Issues to Address

1. **Redundant Containers**: Pages and screens directories contain duplicate functionality
2. **Inconsistent Structure**: Files with similar purposes are organized differently
3. **Analyzer Issues**: Multiple deprecation warnings and unused imports
4. **Incomplete Refactoring**: Some files don't have proper Flutter imports

### Migration Phases

#### Phase 1: Fix Critical Issues (Immediate)

- [x] Fix model_page.dart and other files with missing Flutter imports
- [x] Run fix_analyzer_issues.dart script to address common analyzer warnings
- [x] Create script to remove unused imports throughout the codebase (fix_unused_imports.dart)
- [x] Create script to update deprecated API usage (update_material_apis.dart)
- [x] Create shell script to run all cleanup tools (run_cleanup.sh)
- [x] Run cleanup scripts on the codebase
- [x] Create script to update withOpacity calls to use withValues (fix_opacity_api.dart)
- [x] Run opacity fix script to update all deprecated calls
- [x] Create script to fix unused variables (fix_unused_variables.dart)
- [x] Create script to fix BLoC warnings (fix_bloc_warnings.dart)
- [x] Create script to fix dead code in service classes (fix_dead_code.dart)
- [ ] Run the new analyzer warning fix scripts to address all remaining issues

#### Phase 2: Consolidate Screens into Pages (1-2 weeks)

For each screen file:

1. [ ] Create corresponding page file if it doesn't exist
2. [ ] Migrate functionality from screen to page
3. [ ] Update imports throughout the codebase
4. [ ] Redirect routes to new page components
5. [ ] Add deprecation notices to screen files
6. [ ] Validate all functionality works with the new structure

#### Phase 3: Holy Trinity Architecture Implementation (1-2 weeks)

1. [x] Implement core infrastructure
   - [x] LayoutProvider and layout strategies
   - [x] ThemeProvider and theme strategies
   - [x] DomainModelProvider extension for semantic concepts
   - [x] Semantic concept containers for widgets

2. [x] Create sample components
   - [x] HolyTrinitySample example widget
   - [x] Convert ModelDetailPage to use Holy Trinity
   - [x] Convert EntityDetailPage to use Holy Trinity

3. [ ] Migrate remaining key components
   - [ ] HomePage and main navigation
   - [ ] EntityWidget to use semantic concepts
   - [ ] EntitiesWidget to use semantic concepts 
   - [ ] HeaderWidget to use semantic concepts
   - [ ] Dialog components to use semantic concepts

4. [ ] Add semantic concept registry
   - [ ] Create a registry of all semantic concepts used in the UI
   - [ ] Document the mapping between domain concepts and UI concepts
   - [ ] Create a style guide for semantic concepts

#### Phase 4: Clean Up Component Structure (2-3 weeks)

1. [ ] Extract large components into smaller, focused ones
2. [ ] Apply consistent naming conventions
3. [ ] Create proper component documentation
4. [ ] Add proper test coverage
5. [ ] Ensure all components follow the design guidelines

**Components to Refactor**:

- [ ] entity_widget.dart (continue decomposition)
- [ ] layout components (consolidate and standardize)
- [ ] graph visualization (improve architecture and performance)
- [ ] bookmark_widget.dart (enhance with consistent interface)
- [ ] breadcrumb_navigation.dart (standardize across all pages)

#### Phase 5: Remove Deprecated Screen Directory (Future)

Once all functionality has been migrated:

1. [ ] Remove screen files
2. [ ] Update imports across the codebase
3. [ ] Validate all functionality still works
4. [ ] Update documentation to reflect the new structure

## Migration Progress

### Completed Migrations

- ModelDetailScreenScaffold → ModelDetailPage
- DomainDetailScreen → DomainDetailPage
- GraphApp (in graph_application.dart) → GraphPage
- HomePage (screens version) → HomePage (pages/home version)
- DomainsWidget → DomainsPage with DomainsListWidget
- LeftSidebarWidget → ConceptsPage with ConceptsListWidget
- RightSidebarWidget → ModelsPage with ModelsListWidget
- MainContentWidget → EntityDetailPage
- BookmarkWidget → BookmarkPage with BookmarkListWidget
- Created fix_unused_imports.dart script to clean up imports
- Created update_material_apis.dart script to fix deprecated Material 3 APIs
- Created run_cleanup.sh shell script to automate code cleanup
- Ran cleanup scripts to identify and remove unused imports
- Created fix_opacity_api.dart script to update withOpacity calls
- Updated 85 withOpacity calls to use withValues API with correct type
- Created fix_unused_variables.dart script to handle unused variables
- Created fix_bloc_warnings.dart script to fix BLoC emit and @override issues
- Created fix_dead_code.dart script to handle unreachable code in service classes
- Implemented Holy Trinity architecture core components
- Created ThemeProvider and StandardThemeStrategy
- Created DomainModelProvider extensions for OneApplication
- Converted ModelDetailPage to use Holy Trinity architecture
- Converted EntityDetailPage to use Holy Trinity architecture
- Created HolyTrinitySample widget as a reference

### Implementation Notes

1. Added deprecation notices to original screen/widget files
2. Updated screens to redirect to their page counterparts
3. Created new page components with consistent styling and navigation
4. Enhanced all pages with proper documentation and navigation
5. Added route definitions in main.dart for seamless integration
6. Split presentation logic from UI rendering where appropriate
7. Implemented a consistent breadcrumb navigation pattern
8. Added bookmark integration to all new pages
9. Implemented shared state management using BLoC pattern across pages
10. Created tools to improve code quality and address common issues
11. Identified 135 issues during code cleanup (38 warnings and 97 info items)
12. Created automated tool to update deprecated withOpacity API calls to withValues
13. Fixed 85 withOpacity API calls to use the newer withValues API with correct types
14. Built comprehensive suite of 6 cleanup tools to automate code quality improvements
15. Implemented Holy Trinity architecture with separation of layout, theme, and domain model
16. Created semantic concept containers to apply consistent styling and layout
17. Connected domain model with UI through semantic concept mappings

## Current Focus & Next Steps

1. Run the analyzer warning fix scripts:
   ```bash
   cd apps/one/lib/presentation
   ./tools/run_cleanup.sh
   ```

2. Complete the Holy Trinity migration for remaining key components:
   - HomePage and main navigation
   - EntityWidget and EntitiesWidget
   - HeaderWidget and dialog components

3. Create a semantic concept registry to document all semantic concepts

4. Complete unit tests for new page components (currently at 60% coverage)

5. Begin Component Structure cleanup (Phase 4)

## Follow-up Tasks

### Remaining Phase 1 Tasks

- [ ] Run fix_unused_variables.dart to fix unused variables
- [ ] Run fix_bloc_warnings.dart to fix remaining BLoC issues 
- [ ] Run fix_dead_code.dart to fix dead code in service classes

### Phase 3: Component Structure Cleanup

- [ ] Extract large components into smaller, focused ones
  - [ ] entity_widget.dart (continue decomposition)
  - [ ] graph visualization components (improve architecture)
  
- [ ] Apply consistent naming conventions across all components

- [ ] Create proper component documentation
  - [ ] Add JSDoc-style comments to all public components
  - [ ] Create usage examples for complex components

- [ ] Add proper test coverage
  - [ ] Unit tests for widgets
  - [ ] Integration tests for pages
  - [ ] BLoC tests

- [ ] Ensure all components follow the design guidelines
  - [ ] Accessibility review
  - [ ] Performance review

### Performance Optimizations

- [ ] Implement widget memoization for frequently used components
- [ ] Optimize rendering for large entity lists
- [ ] Add lazy loading for complex page hierarchies
- [ ] Implement virtualized scrolling for long lists
- [ ] Optimize BLoC state management with selective rebuilds

## Shell App Migration

### Overview
Converting the application from a page-based structure to a shell app with micro-frontends.

### Architecture
- **Shell App**: Central container providing consistent layout, navigation, and module loading
- **Micro-Frontends**: Self-contained modules representing domain areas
- **Module Registry**: Central registry for all modules
- **Module Communication**: Event-based communication between modules

### Migration Strategy

#### Phase 1: Master-Detail for Existing Modules
- [x] Shell app implementation
- [x] Module registry
- [x] Basic Domain Explorer module
- [x] Basic Model Manager module
- [x] Domain Explorer master-detail layout
- [ ] Model Manager master-detail layout
- [x] Breadcrumb navigation component
- [ ] Module-to-module navigation

#### Phase 2: Additional Module Migration
- [ ] Entity Workspace Module
  - [ ] Entity listing
  - [ ] Entity detail view
  - [ ] Entity editing
- [ ] Graph Visualization Module
  - [ ] Domain graph view
  - [ ] Model graph view
  - [ ] Entity relationship view
- [ ] Settings Module
  - [ ] Theme settings
  - [ ] Layout settings
  - [ ] User preferences

#### Phase 3: Cross-Module Communication
- [ ] Event bus implementation
- [ ] Global navigation state
- [ ] Shared search functionality
- [ ] Context-aware module loading

## Development Guidelines

1. **No New Screens**: All new container components should be created as pages
2. **Feature Freeze**: Avoid adding new features to screens being migrated
3. **Validate Each Change**: Ensure the application works after each migration step
4. **Document Changes**: Keep this migration plan updated with progress
5. **Consider Dependencies**: Be careful with shared components and imports
6. **Use Holy Trinity**: All new components should use the Holy Trinity architecture
7. **Semantic Naming**: Use consistent semantic concept names in the UI

## Post-Migration Improvements

1. Implement proper UI model layer (ednet_core integration)
2. Enhance navigation with deep linking support
3. Improve component reusability
4. Add comprehensive tests
5. Optimize for performance
6. Implement dark mode support
7. Add accessibility features
8. Create component showcase and documentation
9. Implement responsive layouts for mobile support
10. Add animation and transition standardization

### Timeline and Milestones

- **Phase 1 Completion**: End of current sprint
- **Phase 2 Completion**: Mid-next sprint
- **Phase 3 Completion**: End of next sprint
- **Phase 4 Initiation**: Start of third sprint
- **Phase 4 Completion**: End of fourth sprint
- **Phase 5 (Cleanup)**: Fifth sprint
- **Post-Migration Improvements**: Ongoing after migration completion 