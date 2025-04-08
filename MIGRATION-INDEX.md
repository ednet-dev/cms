# EDNet One Migration Index

This document serves as an index for migrating components from the current architecture in `ednet_one` to the new `ednet_core_flutter` package.

## Migration Principles

1. **Preserve Business Features**: Essential business features must be retained and properly integrated into the new architecture, including:
   - Breadcrumbs
   - Bookmarks management
   - Responsive/adaptive entity/concept/attribute rendering
   - Filters
   - Navigable domain relationships
   - Graphs and visualizations
   - Layout spacing modes

2. **Migration Order**: Components will be migrated from leaf nodes towards root nodes in the dependency tree.

3. **Semantic Evaluation**: Each component will be evaluated for architectural semantic coherence before migration.

4. **File Preservation**: Original files will only be deleted after successful migration and verification.

5. **Leverage Core for Modeling**: Always use `ednet_core` for modeling solutions and domain semantics.

6. **Enhanced Composability**: Focus on improving composability in overriding capabilities of low-level primitives:
   - Attributes, properties, relations
   - Concepts, entities, models, domains
   - Deployments, environments, projects
   - UI rendering and client customizations
 7. Challenge the current architecture and design patterns and if it is needed in ednet_core_flutter or is covered by existing patterns.
 8. 
## Target Architecture: EDNet Shell Architecture

The new architecture is based on the **EDNet Shell Architecture**, which provides a clean separation between domain models and UI representation through a flexible, customizable layer.

### Key Architectural Components

1. **ShellApp**
   - Central coordinating component
   - Interprets domain models and provides UX representation
   - Manages progressive disclosure levels
   - Coordinates adapter registry

2. **UX Adapters**
   - Bridge domain models with UI components
   - Implement the Channel Adapter pattern
   - Allow custom rendering of domain entities
   - Support different disclosure levels

3. **Configuration Injection**
   - Flexible configuration system using dependency injection
   - Support for YAML-defined customizations
   - Priority-based configuration application
   - Multiple configuration types (domain, data, UX)

4. **Canonical Model**
   - Standardizes entity representation for UI
   - Enables consistent rendering across components
   - Abstracts domain model complexity

5. **Progressive Disclosure**
   - Controls UI complexity based on user expertise
   - Levels: minimal, basic, intermediate, advanced, complete
   - Reduces cognitive load with focused interfaces

6. **Enterprise Integration Patterns**
   - Channel Adapter (ModelUXChannelAdapter)
   - Message Filter (UXComponentFilter)
   - Message Aggregator (DomainModelVisualizer)
   - Canonical Data Model (UXCanonicalModel)
## Integration Strategy

1. **Progressive Enhancement**:
   - Start with essential features (minimal disclosure level)
   - Add complexity gradually as migration progresses
   - Test each component in isolation before integration

2. **Enterprise Integration Patterns**:
   - Use Channel Adapters for entity-UI bridges
   - Implement Message Filters for UI component filtering
   - Create Message Aggregators for combined visualizations
   - Build on the Canonical Data Model for standardized UI representation

3. **Deferred Implementation**:
   - Use "Not Implemented" adapters for incomplete features
   - Provide fallback UIs for in-progress components
   - Maintain backward compatibility where possible

4. **Migration Sequence**:
   - First migrate theme system and UI primitives
   - Then implement adapters for entities and domain model
   - Build navigation system compatible with Shell Architecture
   - Connect state management with message-based architecture
   - Finally migrate screens and modular components

## Migration Tracking

Each migration session should update this document with:

1. Updated status indicators for migrated components
2. Notes on any architectural decisions made
3. Changes to migration order if dependencies are discovered
4. Potential challenges or technical debt identified

This living document will guide the migration process and ensure no critical components are missed or improperly implemented.

## Migration Notes

### 2023-04-07: Theme Migration

#### theme_constants.dart ✅
- Enhanced with progressive disclosure level color support for all disclosure levels (minimal, basic, standard, intermediate, advanced, detailed, complete, debug)
- Added SemanticColors for domain-specific coloring (entity, concept, attribute, relationship, model, domain)
- Added ThemeConfiguration class for Configuration Injector integration
- Integrated with DisclosureLevel enum for contextual styling
- Enhanced text styles with disclosure level-appropriate formatting
- Added support for new theme names (corporate, creative) 
  
### 2023-04-08: Concept Components Migration

#### semantic_concept_container.dart ✅
- Migrated to the Shell Architecture with progressive disclosure support
- Implemented as part of the components/concept directory
- Fixed Dart analyzer issues related to part files and imports
- Simplified implementation to use direct Flutter widgets
- Added disclosure level to all components for progressive UX
- Components work with core ednet_core_flutter library

### 2023-04-08: Canvas Interactions Migration ✅

#### canvas/interactions/ ✅
- Migrated PanHandler, ZoomHandler, and SelectionHandler to the Shell Architecture
- Enhanced with disclosure level support
- Added proper documentation for the Shell Architecture context
- Improved error handling and zoom/pan behavior
- Integrated with main library using part directive
- All components work with Flutter widget system

### Migration Transformation Guidelines

When migrating components, transform them according to these guidelines or implement missing aspects of migrated stuff:

#### Theme Components
- Convert to theme extensions and configurations in the Shell Architecture
- Implement as part of the UX customization system
- Use the Configuration Injector to register theme customizations

#### ACCESSABILITY
- Convert to accessibility extensions and configurations in the Shell Architecture
- Implement as part of the UX customization system
- Use the Configuration Injector to register accessibility customizations


#### INTERNATIONALIZATION
- Convert to internationalization extensions and configurations in the Shell Architecture
- Implement as part of the UX customization system
- Use the Configuration Injector to register internationalization customizations


#### UI Widgets
- Convert to UX Adapters for specific entity types
- Implement ProgressiveUXAdapter for disclosure-aware components
- Use Field Descriptors for form elements
- Separate domain logic from presentation concerns

#### Navigation
- Transform into Shell-compatible navigation service
- Integrate with domain relationships for model navigation
- Maintain breadcrumb and bookmark functionality through adapters

#### State Management
- Replace with Message-based architecture using UX Channels
- Implement UX Component Filters for selective UI updates
- Use Canonical Models for standardized state representation

#### Domain Model Interaction
- Use DomainModelVisualizer for graph representations
- Implement UXAdapters for entity-specific rendering
- Leverage domain model without UI coupling

## Migration Status Indicators

- ⌛ Not Started
- 🔄 In Progress
- ✅ Completed
- 🚫 Deprecated (will not be migrated)

## Files to Migrate (Ordered by Dependency Level)

### Level 1: Utilities and Base Components

#### Theme and Styling
- ✅ `presentation/theme/theme_constants.dart` → Shell: UX customization system
- ✅ `presentation/theme/text_styles.dart` → Shell: Theme configuration
- ✅ `presentation/theme/theme.dart` → Shell: Theme configuration
- ✅ `presentation/theme/theme_service.dart` → Shell: Configuration Injector
- ✅ `presentation/theme/theme_components/` → Shell: UX Field Descriptors
  - ✅ `presentation/theme/theme_components/theme_component.dart` → Shell: ThemeComponent base class
  - ✅ `presentation/theme/theme_components/cheerful_theme_component.dart` → Shell: CheerfulThemeComponent implementation
  - ✅ `presentation/theme/theme_components/cli_theme_component.dart` → Shell: CLIThemeComponent implementation
  - ✅ `presentation/theme/theme_components/minimalistic_theme_component.dart` → Shell: MinimalisticThemeComponent implementation
  - ✅ `presentation/theme/theme_components/custom_colors.dart` → Shell: CustomColors utilities
  - ✅ `presentation/theme/theme_components/list_item_card.dart` → Shell: ListItemCard component
- ✅ `presentation/theme/extensions/` → Shell: UX customization extensions
  - ✅ `presentation/theme/extensions/theme_extensions.dart` → Shell: Context extensions for theme
  - ✅ `presentation/theme/extensions/theme_spacing.dart` → Shell: Spacing extensions
  - ✅ `presentation/theme/extensions/disclosure_level_theme_extension.dart` → Shell: Disclosure level theme extension
  - ✅ `presentation/theme/extensions/semantic_colors_extension.dart` → Shell: Semantic colors theme extension
- ✅ `presentation/theme/strategy/` → Shell: Theme strategy adapters
  - ✅ `presentation/theme/strategy/theme_strategy.dart` → Shell: ThemeStrategy interface
  - ✅ `presentation/theme/strategy/standard_theme_strategy.dart` → Shell: StandardThemeStrategy implementation
- ✅ `presentation/theme/providers/` → Shell: UX Channel for theme changes
  - ✅ `presentation/theme/providers/theme_provider.dart` → Shell: ThemeProvider implementation

#### Utils
- ✅ `presentation/utils/` → Shell: Utility services

#### Base UI Components
- ✅ `presentation/widgets/breadcrumb/` → Shell: Navigation visualizers
- ✅ `presentation/widgets/bookmarks/` → Shell: Entity reference adapters
- ✅ `presentation/widgets/filters/` → Shell: UX Component Filters
- ✅ `presentation/widgets/card/` → Shell: Entity card adapters
- ✅ `presentation/widgets/list/` → Shell: Collection adapters
- ✅ `presentation/widgets/canvas/` → Shell: Visualization components
  - ✅ `presentation/widgets/canvas/meta_domain_canvas.dart` → Shell: Domain canvas component
  - ✅ `presentation/widgets/canvas/meta_domain_painter.dart` → Shell: Domain painter
  - ✅ `presentation/widgets/canvas/interactions/` → Shell: Canvas interactions
    - ✅ `presentation/widgets/canvas/interactions/pan_handler.dart` → Shell: Pan gesture handler
    - ✅ `presentation/widgets/canvas/interactions/zoom_handler.dart` → Shell: Zoom gesture handler
    - ✅ `presentation/widgets/canvas/interactions/selection_handler.dart` → Shell: Selection gesture handler
  - ✅ `presentation/widgets/canvas/render_objects/` → Shell: Canvas render objects
  - ✅ `presentation/widgets/canvas/painters/` → Shell: Canvas painters
- ✅ `presentation/widgets/tools/` → Shell: UI action components
- ✅ `presentation/widgets/layout/` → Shell: Layout strategies
- ✅ `presentation/widgets/samples/` → Shell: Example adapters
- ✅ `presentation/widgets/semantic_concept_container.dart` → Shell: Concept adapter

### Level 2: Domain Model and Navigation

#### Domain
- ⌛ `presentation/domain/domain_model_provider.dart` → Shell: Domain model channel
- ⌛ `presentation/widgets/domain/` → Shell: Domain visualization adapters

#### Navigation
- ✅ `presentation/navigation/navigation_service.dart` → Shell: Navigation service
- ⌛ `presentation/widgets/navigation/` → Shell: Navigation components
- ⌛ `presentation/state/navigation_helper.dart` → Shell: Navigation helpers

### Level 3: Entity and Model Components

#### Entity and Domain Components
- ⌛ `presentation/widgets/entity/` → Shell: Entity-specific adapters
- ⌛ `presentation/widgets/entity_form.dart` → Shell: Form generation with Field Descriptors
- ⌛ `presentation/widgets/domain_model_editor.dart` → Shell: Domain model editor adapter
- ⌛ `presentation/widgets/project_entity_form.dart` → Shell: Project entity adapter
- ⌛ `presentation/widgets/project_form.dart` → Shell: Project form adapter
- ⌛ `presentation/widgets/workspace/` → Shell: Workspace visualization

### Level 4: State Management

#### Providers and Blocs
- ⌛ `presentation/di/bloc_providers.dart` → Shell: Message channels
- ⌛ `presentation/state/providers/` → Shell: UX channels and messages
- ⌛ `presentation/state/blocs/` → Shell: Message processors
- ⌛ `presentation/state/models/` → Shell: Canonical models
- ⌛ `presentation/providers/project_provider.dart` → Shell: Project adapter
- ⌛ `presentation/layouts/providers/` → Shell: Layout configuration

### Level 5: Modules and Features

#### Module Components
- ⌛ `presentation/modules/domain_explorer/` → Shell: Domain explorer module
- ⌛ `presentation/modules/model_manager/` → Shell: Model manager module
- ⌛ `presentation/modules/module_registry.dart` → Shell: Module registry

### Level 6: Screens and Pages

#### Screens
- ⌛ `presentation/screens/domains_widget.dart` → Shell: Domain visualization
- ⌛ `presentation/screens/domain_detail_screen.dart` → Shell: Domain detail adapter
- ⌛ `presentation/screens/model_detail_screen_scaffold.dart` → Shell: Model detail adapter
- ⌛ `presentation/screens/graph_application.dart` → Shell: Graph visualization
- ⌛ `presentation/screens/entries_sidebar_widget.dart` → Shell: Navigation sidebar
- ⌛ `presentation/screens/home_page.dart` → Shell: Shell app home

#### Pages
- ⌛ `presentation/pages/home/` → Shell: Home page adapters
- ⌛ `presentation/pages/domain/` → Shell: Domain page adapters
- ⌛ `presentation/pages/model/` → Shell: Model page adapters
- ⌛ `presentation/pages/entity/` → Shell: Entity page adapters
- ⌛ `presentation/pages/settings/` → Shell: Settings page adapters
- ⌛ `presentation/pages/search/` → Shell: Search page adapters
- ⌛ `presentation/pages/help/` → Shell: Help and documentation adapters

### Level 7: Application and Routing

#### Application Components
- ⌛ `presentation/app.dart` → Shell: ShellApp implementation
- ⌛ `presentation/app_config.dart` → Shell: Configuration registry
- ⌛ `presentation/app_shell.dart` → Shell: Shell container adapter

#### Routing
- ⌛ `presentation/routing/router.dart` → Shell: Adaptive router service
- ⌛ `presentation/routing/route_generator.dart` → Shell: Domain-aware route generation
- ⌛ `presentation/routing/route_information_parser.dart` → Shell: Route parsing with entity support

### Level 8: Integration and External Services

#### API and Services
- ⌛ `data/api/` → Shell: API channel adapters
- ⌛ `data/services/` → Shell: Service integrations
- ⌛ `data/repositories/` → Shell: Repository pattern implementations

#### External Integrations
- ⌛ `integrations/analytics/` → Shell: Analytics adapters
- ⌛ `integrations/storage/` → Shell: Storage adapters
- ⌛ `integrations/platforms/` → Shell: Platform-specific adapters

## Integration Testing Plan

The migration will be verified through a comprehensive testing plan:

1. **Component Tests**:
   - Each migrated component must have corresponding tests
   - Tests should verify both functionality and integration

2. **Integration Tests**:
   - Complete user journeys must be tested through shell architecture
   - Tests should include all disclosure levels

3. **Performance Benchmarks**:
   - Baseline performance metrics must be established
   - Post-migration performance must meet or exceed baseline

4. **Accessibility Verification**:
   - Components must maintain or improve accessibility
   - Screen reader compatibility must be verified

5. **Cross-Platform Testing**:
   - Verify component behavior across platforms (web, mobile, desktop)
   - Test platform-specific adaptations

## Visual Migration Map

A visual migration map will be maintained to track dependencies and progress:

```
ShellApp
├── ProgressiveDisclosure
│   └── DisclosureLevel
├── UXAdapters
│   ├── EntityAdapters
│   ├── ConceptAdapters
│   ├── AttributeAdapters
│   └── RelationshipAdapters
├── ConfigurationInjection
│   ├── ThemeConfig
│   ├── UXConfig
│   └── DomainConfig
├── CanonicalModel
│   ├── EntityCanonicalModel
│   └── RelationshipCanonicalModel
└── MessageChannels
    ├── EntityMessages
    ├── NavigationMessages
    └── UserActionMessages
```

## Next Steps

1. Complete theme migration with remaining components
2. Begin migrating base UI components (cards, lists)
3. Implement domain model channel adapter
4. Create initial UX adapters for core entity types
5. Develop migration test harness

## Technical Debt Tracking

As migration progresses, any technical debt should be tracked here:

1. Legacy styling in theme components needs refactoring (Medium priority)
2. Navigation state management needs adaptation to message architecture (High priority)
3. Domain model visualization requires performance optimization (Medium priority)
4. State management patterns should be unified (Medium priority)