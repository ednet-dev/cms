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
- [ ] Remove unused imports throughout the codebase
- [ ] Update deprecated API usage (Material 3 related changes)

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

### Phase 3: Clean Up Component Structure (2-3 weeks)

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

### Phase 4: Remove Deprecated Screen Directory (Future)

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

### Current Progress
We've successfully migrated 9 of the key components from the screens/ directory to the pages/ directory. This represents approximately 90% completion of our migration plan.

### Next Steps
1. Address remaining analyzer warnings across the codebase
2. Complete unit tests for new page components (currently at 60% coverage)
3. Update Material 3 deprecated APIs across all components
4. Implement filtering functionality on entity lists
5. Enhance the bookmarking system with categorization and tagging
6. Begin Component Structure cleanup (Phase 3)

## Migration Progress Tracking

| Component                 | Original Location                         | New Location                      | Status        | Issues                                                               |
| ------------------------- | ----------------------------------------- | --------------------------------- | ------------- | -------------------------------------------------------------------- |
| ModelPage                 | pages/model_page.dart                     | (Fixed in place)                  | ✅ Done        | Missing imports fixed                                                |
| HomePage                  | screens/home_page.dart                    | pages/home/home_page.dart         | ✅ Done        | Added deprecation notice, redirects to new HomePage                  |
| ModelDetailScreenScaffold | screens/model_detail_screen_scaffold.dart | pages/model_detail_page.dart      | ✅ Done        | Added deprecation notice, redirects to ModelDetailPage               |
| DomainDetailScreen        | screens/domain_detail_screen.dart         | pages/domain_detail_page.dart     | ✅ Done        | Added deprecation notice, redirects to DomainDetailPage              |
| GraphApp                  | screens/graph_application.dart            | pages/graph_page.dart             | ✅ Done        | Added deprecation notice, enhanced GraphPage with consistent styling |
| DomainsWidget             | screens/domains_widget.dart               | pages/domains_page.dart           | ✅ Done        | Split into DomainsPage and DomainsListWidget                         |
| LeftSidebarWidget         | widgets/sidebar/left_sidebar_widget.dart  | pages/concepts_page.dart          | ✅ Done        | Reimplemented with proper navigation and state management            |
| RightSidebarWidget        | widgets/sidebar/right_sidebar_widget.dart | pages/models_page.dart            | ✅ Done        | Enhanced with filtering and consistent styling                       |
| MainContentWidget         | widgets/main_content_widget.dart          | pages/entity_detail_page.dart     | ✅ Done        | Improved with tabs and proper state management                       |
| BookmarkWidget            | widgets/bookmark_widget.dart              | pages/bookmark_page.dart          | ✅ Done        | Added categorization and enhanced UI                                 |
| FilterWidget              | widgets/filter_widget.dart                | widgets/filter/filter_widget.dart | 🔄 In Progress | Refactoring to support all entity types                              |
| NavigationRail            | widgets/navigation_rail.dart              | layouts/navigation_layout.dart    | 📝 Planned     | Will consolidate navigation components                               |

## Development Guidelines During Migration

1. **No New Screens**: All new container components should be created as pages
2. **Feature Freeze**: Avoid adding new features to screens being migrated
3. **Validate Each Change**: Ensure the application works after each migration step
4. **Document Changes**: Keep this migration plan updated with progress
5. **Consider Dependencies**: Be careful with shared components and imports

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
- **Phase 3 Initiation**: Start of third sprint
- **Phase 3 Completion**: End of fourth sprint
- **Phase 4 (Cleanup)**: Fifth sprint
- **Post-Migration Improvements**: Ongoing after migration completion 