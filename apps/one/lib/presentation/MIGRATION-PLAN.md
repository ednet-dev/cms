# EDNet One Presentation Layer Migration Plan

This document outlines the plan to migrate from the current dual structure (pages + screens) to a unified pages-only approach, along with addressing architectural issues.

## Key Issues to Address

1. **Redundant Containers**: Pages and screens directories contain duplicate functionality
2. **Inconsistent Structure**: Files with similar purposes are organized differently
3. **Analyzer Issues**: Multiple deprecation warnings and unused imports
4. **Incomplete Refactoring**: Some files don't have proper Flutter imports

## Migration Steps

### Phase 1: Fix Critical Issues (Immediate)

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

### Phase 2: Consolidate Screens into Pages (1-2 weeks)

For each screen file:

1. [ ] Create corresponding page file if it doesn't exist
2. [ ] Migrate functionality from screen to page
3. [ ] Update imports throughout the codebase
4. [ ] Redirect routes to new page components
5. [ ] Add deprecation notices to screen files
6. [ ] Validate all functionality works with the new structure

**Files to Migrate**:

- [x] model_detail_screen_scaffold.dart → model_detail_page.dart
- [x] home_page.dart (in screens) → home_page.dart (in pages)
- [x] domain_detail_screen.dart → domain_detail_page.dart
- [x] graph_application.dart → graph_page.dart
- [x] domains_widget.dart → domains_page.dart
- [x] entries_sidebar_widget.dart → sidebar_page.dart or component

### Phase 3: Holy Trinity Architecture Implementation (1-2 weeks)

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

### Phase 4: Clean Up Component Structure (2-3 weeks)

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

### Phase 5: Remove Deprecated Screen Directory (Future)

Once all functionality has been migrated:

1. [ ] Remove screen files
2. [ ] Update imports across the codebase
3. [ ] Validate all functionality still works
4. [ ] Update documentation to reflect the new structure

## Component Migration Template

For each component being migrated, follow this pattern:

1. **Analyze**: Understand what the component does and its dependencies
2. **Create**: Make the new component in the correct location
3. **Refactor**: Break down large components into smaller ones
4. **Update**: Fix all imports and references
5. **Test**: Verify the component works as expected
6. **Document**: Add documentation for the component
7. **Remove**: Delete the original component when safe

## Holy Trinity Architecture

The Holy Trinity architecture has been implemented as a foundational architectural pattern for our UI. This architecture separates three core concerns:

1. **Layout Strategy** - How UI components are sized and positioned
2. **Theme Strategy** - How UI components are visually styled
3. **Domain Model** - The underlying business concepts

Key components:

- **LayoutProvider**: Manages the active layout strategy
- **ThemeProvider**: Manages the active theme strategy
- **DomainModelProvider**: Extensions for OneApplication to connect domain models to semantic concepts
- **SemanticConceptContainer**: Primary widget for applying semantic layout and styling

Migration of existing components to the Holy Trinity architecture involves:

1. Wrapping components in SemanticConceptContainer
2. Replacing hardcoded styles with theme strategy methods
3. Replacing fixed layouts with layout strategy constraints
4. Using domain model extensions to connect with semantic concepts

## Latest Migration Updates

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

### Current Progress

We've successfully migrated 9 of the key components from the screens/ directory to the pages/ directory, implemented the core Holy Trinity architecture, and converted 2 key pages to use it. This represents approximately 60% completion of the migration plan.

### Next Steps

1. Run the analyzer warning fix scripts to fix remaining issues:

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

## Migration Progress Tracking

| Component                       | Original Location                         | New Location                                | Status        | Issues                                                               |
| ------------------------------- | ----------------------------------------- | ------------------------------------------- | ------------- | -------------------------------------------------------------------- |
| ModelPage                       | pages/model_page.dart                     | (Fixed in place)                            | ✅ Done        | Missing imports fixed                                                |
| HomePage                        | screens/home_page.dart                    | pages/home/home_page.dart                   | ✅ Done        | Added deprecation notice, redirects to new HomePage                  |
| ModelDetailScreenScaffold       | screens/model_detail_screen_scaffold.dart | pages/model_detail_page.dart                | ✅ Done        | Added deprecation notice, redirects to ModelDetailPage               |
| DomainDetailScreen              | screens/domain_detail_screen.dart         | pages/domain_detail_page.dart               | ✅ Done        | Added deprecation notice, redirects to DomainDetailPage              |
| GraphApp                        | screens/graph_application.dart            | pages/graph_page.dart                       | ✅ Done        | Added deprecation notice, enhanced GraphPage with consistent styling |
| DomainsWidget                   | screens/domains_widget.dart               | pages/domains_page.dart                     | ✅ Done        | Split into DomainsPage and DomainsListWidget                         |
| LeftSidebarWidget               | widgets/sidebar/left_sidebar_widget.dart  | pages/concepts_page.dart                    | ✅ Done        | Reimplemented with proper navigation and state management            |
| RightSidebarWidget              | widgets/sidebar/right_sidebar_widget.dart | pages/models_page.dart                      | ✅ Done        | Enhanced with filtering and consistent styling                       |
| MainContentWidget               | widgets/main_content_widget.dart          | pages/entity_detail_page.dart               | ✅ Done        | Improved with tabs and proper state management                       |
| BookmarkWidget                  | widgets/bookmark_widget.dart              | pages/bookmark_page.dart                    | ✅ Done        | Added categorization and enhanced UI                                 |
| Holy Trinity Architecture       | N/A                                       | Multiple files                              | ✅ Done        | Core infrastructure implemented                                      |
| StandardThemeStrategy           | N/A                                       | theme/strategy/standard_theme_strategy.dart | ✅ Done        | Theme strategy implementation                                        |
| ThemeProvider                   | N/A                                       | theme/providers/theme_provider.dart         | ✅ Done        | Theme provider implementation                                        |
| DomainModelProvider             | N/A                                       | domain/domain_model_provider.dart           | ✅ Done        | Domain model extension implementation                                |
| ModelDetailPage (Holy Trinity)  | pages/model_detail_page.dart              | pages/model_detail_page.dart                | ✅ Done        | Converted to use Holy Trinity architecture                           |
| EntityDetailPage (Holy Trinity) | pages/entity_detail_page.dart             | pages/entity_detail_page.dart               | ✅ Done        | Converted to use Holy Trinity architecture                           |
| FilterWidget                    | widgets/filter_widget.dart                | widgets/filter/filter_widget.dart           | 🔄 In Progress | Refactoring to support all entity types                              |
| EntityWidget (Holy Trinity)     | widgets/entity/entity_widget.dart         | widgets/entity/entity_widget.dart           | 📝 Planned     | Will convert to use Holy Trinity architecture                        |
| EntitiesWidget (Holy Trinity)   | widgets/entity/entities_widget.dart       | widgets/entity/entities_widget.dart         | 📝 Planned     | Will convert to use Holy Trinity architecture                        |
| NavigationRail                  | widgets/navigation_rail.dart              | layouts/navigation_layout.dart              | 📝 Planned     | Will consolidate navigation components                               |
| fix_unused_imports.dart         | N/A                                       | tools/fix_unused_imports.dart               | ✅ Done        | Script to remove unused imports                                      |
| update_material_apis.dart       | N/A                                       | tools/update_material_apis.dart             | ✅ Done        | Script to update deprecated Material 3 APIs                          |
| run_cleanup.sh                  | N/A                                       | tools/run_cleanup.sh                        | ✅ Done        | Shell script to run all cleanup tools                                |
| fix_opacity_api.dart            | N/A                                       | tools/fix_opacity_api.dart                  | ✅ Done        | Script to update withOpacity calls to withValues                     |
| withOpacity to withValues       | Multiple files                            | Multiple files                              | ✅ Done        | Updated 85 occurrences to use the new API                            |
| fix_unused_variables.dart       | N/A                                       | tools/fix_unused_variables.dart             | ✅ Done        | Script to fix unused variables                                       |
| fix_bloc_warnings.dart          | N/A                                       | tools/fix_bloc_warnings.dart                | ✅ Done        | Script to fix BLoC warnings                                          |
| fix_dead_code.dart              | N/A                                       | tools/fix_dead_code.dart                    | ✅ Done        | Script to fix dead code                                              |

## Development Guidelines During Migration

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

## Performance Optimizations

After completing the migration, we'll focus on these performance enhancements:

1. Implement widget memoization for frequently used components
2. Optimize rendering for large entity lists
3. Add lazy loading for complex page hierarchies
4. Implement virtualized scrolling for long lists
5. Optimize BLoC state management with selective rebuilds
6. Implement caching for frequently accessed data
7. Reduce unnecessary rebuilds with const constructors

## Timeline and Milestones

- **Phase 1 Completion**: End of current sprint
- **Phase 2 Completion**: Mid-next sprint
- **Phase 3 Completion**: End of next sprint
- **Phase 4 Initiation**: Start of third sprint
- **Phase 4 Completion**: End of fourth sprint
- **Phase 5 (Cleanup)**: Fifth sprint
- **Post-Migration Improvements**: Ongoing after migration completion

