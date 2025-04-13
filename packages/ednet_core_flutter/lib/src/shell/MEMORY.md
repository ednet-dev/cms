# EDNet Shell Architecture Implementation - Memory File

## Current Progress (Phase 1)

We've successfully implemented the core components of the EDNet Shell Architecture. This architecture provides a flexible, customizable UI layer for domain models with progressive disclosure capabilities.

### Components Implemented

1. **ShellApp**: The central coordinating component that interprets domain models and provides UX representation
   - Handles disclosure levels
   - Manages adapters
   - Provides domain visualization

2. **Configuration Injector**: A flexible configuration system using dependency injection principles
   - Multiple configuration types (domain, data, UX)
   - YAML configuration support
   - Priority-based application

3. **Canonical Model Adapter**: Implementation of the Canonical Data Model pattern
   - Standardizes entity representation
   - Enables consistent UI rendering

4. **UX Customization System**: Field descriptors, adapters, and validators
   - Progressive disclosure controls
   - Flexible field descriptors
   - Validation framework

5. **Example Client Application**: Demonstrates the full architecture in action

### Integrated Enterprise Integration Patterns

1. Channel Adapter pattern (ModelUXChannelAdapter)
2. Message Filter pattern (UXComponentFilter)
3. Message Aggregator pattern (DomainModelVisualizer)
4. Canonical Data Model pattern (UXCanonicalModel)

## UI Component Integration Plan (Phase 2)

After reviewing the existing UI components, we identified significant inconsistencies and fragmentation that need to be addressed:

### Key Architectural Inconsistencies

1. **Multiple Form Implementations**: `generic_entity_form.dart` and `constraint_validated_form.dart` overlap in responsibility without clear differentiation.
2. **Disjointed Visualization Components**: `semantic_entity_collection_view.dart`, `domain_entity_card.dart`, and `domain_list_item.dart` implement similar visualization patterns without coherent integration.
3. **Missing Entity Creation Flow**: Despite form components, there's no clear way to create new entities through the UI.
4. **Inconsistent Progressive Disclosure**: The `DisclosureLevel` enum exists but is applied inconsistently across components.
5. **Disconnected Navigation**: Navigation between entity views lacks cohesive implementation.

### Integration Strategy

1. **Unify Form Components**:
   - Merge the best features of `generic_entity_form.dart` and `constraint_validated_form.dart`
   - Create a single entry point in `ShellApp` for entity form generation
   - Implement consistent validation using domain constraints

2. **Standardize Entity Visualization**:
   - Create a unified adapter registry for all visualization types
   - Establish clear hierarchy between list, card, table, and detail views
   - Implement consistent theming and styling based on concept semantics

3. **Implement Entity Creation Flow**:
   - Add entity creation methods to `ShellApp` that leverage unified form components
   - Create standardized dialogs for entity creation with proper context
   - Ensure proper integration with domain model constraints

4. **Consolidate Progressive Disclosure**:
   - Implement consistent disclosure level handling across all components
   - Define clear guidelines for what is shown at each disclosure level
   - Ensure proper inheritance of disclosure levels across component hierarchy

5. **Integrate Navigation Flow**:
   - Establish clear navigation patterns between list, detail, edit, and create views
   - Integrate with `ShellApp.navigationService` for consistent breadcrumb and history support
   - Support deep linking to entity views

### UI Component Unification Tasks

1. **Phase 2.1: Forms & Creation** ✅
   - [x] Create unified form architecture by merging existing implementations
   - [x] Implement standardized entity creation dialogs
   - [x] Add entity creation methods to ShellApp
   - [x] Ensure proper validation and error handling

2. **Phase 2.2: Visualization & Display** ✅
   - [x] Unify entity visualization components
   - [x] Standardize progressive disclosure implementation
   - [x] Implement consistent styling based on domain semantics
   - [x] Create unified collection view with multiple visualization modes

3. **Phase 2.3: Navigation & Integration** 🔄
   - [x] Create an extension method for ShellApp to show entity manager view
   - [x] Add showConceptEntities method to ShellNavigationService
   - [x] Begin updating DomainSidebar and MultiDomainNavigator
   - [x] Complete integration with breadcrumb navigation service
   - [x] Support proper navigation history
   - [x] Add deep linking capabilities

## Concept Navigator Integration Status

We've completed integrating the EntityManagerView into the navigation flow:

### Completed:
1. ✅ Added `showEntityManager` extension method to `ShellApp`
2. ✅ Added `showConceptEntities` method to `ShellNavigationService`
3. ✅ Modified `MultiDomainNavigator._navigateToConcept()` to use our new EntityManagerView
4. ✅ Integrated deep linking capabilities in `ShellNavigationService`
5. ✅ Created integration tests for the navigation flow
6. ✅ Fixed DomainSidebar method order issue

### Issues Remaining:
1. ❌ The main application still shows a separate entity management demo panel (this will be addressed by the client application)

### TDD Approach Needed

To fully implement and test our changes according to TDD principles:

1. **Red**: Create failing tests for:
   - Navigation service with EntityManagerView integration
   - Breadcrumb updates when navigating to a concept
   - Back navigation behavior

2. **Green**: Implement remaining integration points:
   - Fix the linter error in DomainSidebar
   - Remove the demo panel from the main app
   - Ensure all components work together

3. **Refactor**: Extract common patterns and ensure consistent behavior:
   - Create helper methods for entity management actions
   - Ensure consistent disclosure level handling
   - Document usage patterns in READMES

## Immediate Next Steps

1. ~~Fix the linter error in DomainSidebar's _navigateToConceptEntities method:~~
   ```dart
   // Move this method definition before it's used
   void _navigateToConceptEntities(Concept concept, String path) {
     // Notify item selected as before (for backwards compatibility)
     widget.onItemSelected?.call(DomainNavigationItem(
       type: NavigationItemType.concept,
       path: path,
       title: concept.code,
       concept: concept,
     ));
     
     // Update navigation state and show entity manager view
     if (widget.shellApp.hasFeature('entity_creation') && 
         widget.shellApp.hasFeature('entity_editing')) {
       // If features are available, use the enhanced entity management view
       widget.shellApp.showEntityManager(
         context,
         concept.code,
         title: concept.code,
         initialViewMode: EntityViewMode.list,
         disclosureLevel: widget.shellApp.currentDisclosureLevel,
       );
     } else {
       // Fallback to regular navigation if features aren't available
       widget.shellApp.navigateTo(path);
     }
   }
   ```

2. ~~Create integration tests for navigation flow~~

3. ~~Update main.dart to remove the demo panel:~~
   ```dart
   // Remove this section from the Stack in the build method
   Positioned(
     top: 100,
     right: 20,
     child: _buildEntityManagementDemoPanel(context, shellApp),
   ),
   ```

4. ~~Document the integration approach~~

## Deep Linking Implementation

We've implemented deep linking capabilities in the ShellNavigationService with the following features:

1. **URI-based navigation**: Using the `ednet://` URI scheme to navigate to any part of the domain model
2. **Shareable links**: Generate deep links for sharing specific entity views
3. **Parameter support**: Pass parameters through deep links to control view mode and other options
4. **Integration with EntityManagerView**: Properly handle concept links by showing the entity manager

Example usage:

```dart
// Handle a deep link from an external source
final uri = Uri.parse('ednet://ProjectManagement/Core/Task/task-123?view=details');
shellApp.navigationService.handleDeepLink(uri, context);

// Generate a deep link to the current location
final deepLink = shellApp.navigationService.generateDeepLink();
// Share deep link: ednet://ProjectManagement/Core/Task?viewMode=cards
```

## Next Steps for Client Applications

Client applications using ednet_core_flutter should:

1. Remove the separate entity management demo panel (if present)
2. Register URI handlers to support deep linking
3. Update to the latest version of ednet_core_flutter
4. Configure deep link handling in their app initialization

The client is responsible for:

```dart
// In client app initialization
void initDeepLinkHandling() {
  // Handle initial URI
  final initialUri = Uri.parse('ednet://domain/model/concept');
  shellApp.navigationService.handleDeepLink(initialUri, context);
  
  // Listen for platform URI events
  // Platform-specific implementation
}
```

## Future Work

1. Enhance deep linking with more advanced parameter handling
2. Add deep link generation to the UI for sharing views
3. Improve test coverage for edge cases
4. Support more complex navigation patterns
5. Fix test implementation issues related to domain model creation

## Test Implementation Issues

The navigation flow tests currently have issues with the test domain model creation:

```
type 'Concept' is not a subtype of type 'Property'
package:ednet_core/domain/model/entity/entities.dart 833:17  Entities.add
```

This error suggests that the way we're constructing the test domain model doesn't match the internal requirements of ednet_core. The specific issue appears to be with how Concept objects are added to collections in the domain model.

To fix this:

1. Examine the implementation of `Entities.add` in ednet_core to understand the correct way to add concepts
2. Update the createTestDomainModel implementation to follow these requirements
3. Consider using a mock or more appropriate test helper for domain model creation

Until these issues are fixed, the tests provide a good structure for validating the navigation flow, but they won't pass execution.

## Pending Issues (From Phase 1)

1. **Core Type Definitions**:
   - Define DisclosureLevel enum
   - Create UXAdapterRegistry class
   - Define UX field types and descriptors

2. **Library Structure Issues**:
   - Fix part-of declarations and imports
   - Align with ednet_core library structure
   - Ensure proper Flutter imports

3. **Implementation Gaps**:
   - Complete the ProgressiveUXAdapter abstract class
   - Implement default adapters
   - Add filterFieldsByDisclosure implementation

4. **Testing**:
   - Add unit tests for shell components
   - Test configuration loading
   - Test adapter registration

5. **Documentation Refinement**:
   - Add API documentation for all public classes
   - Create usage examples
   - Document customization patterns

## Integration with Existing Code

We need to integrate with:

1. `ModelInstanceService` - Fix linter errors and align with EDNet architecture
2. `ProjectEntity` - Fix attribute type definitions and inheritance issues
3. `apps/one/lib/presentation` - Leverage the shell architecture for the UI layer

## Action Plan

1. Define core missing types in `packages/core/lib/domain/patterns/ui/`
2. Fix library structure and import issues
3. Complete implementation of abstract classes
4. Address linter errors in the existing code
5. Test integration with the existing project structure
6. Refine documentation 

## Next Steps

We have to extract application service abstraction as API connecting domain model aggregates and higher order user stories they build aside of default CRUD implementation we anyways provide. So IApplicationService manages behavioral aspects and is used by the shell app for discovery.

### Immediate Next Steps

1. Replace `ConceptExplorer` with `EntityManagerView` in the navigation flow
2. Update the `MultiDomainNavigator._navigateToConcept()` method
3. Ensure all UI components respect progressive disclosure levels consistently
4. Document the integration patterns for other developers to follow 