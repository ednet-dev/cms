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
- [ ] Run fix_analyzer_issues.dart script to address common analyzer warnings
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
- [ ] model_detail_screen_scaffold.dart → model_detail_page.dart
- [ ] home_page.dart (in screens) → home_page.dart (in pages)
- [ ] domain_detail_screen.dart → domain_detail_page.dart
- [ ] graph_application.dart → graph_page.dart
- [ ] domains_widget.dart → domains_page.dart
- [ ] entries_sidebar_widget.dart → sidebar_page.dart or component

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

## Latest Migration Updates (Date: Current Date)

### Completed Migrations
- ModelDetailScreenScaffold → ModelDetailPage
- DomainDetailScreen → DomainDetailPage

### Implementation Notes
1. Added deprecation notices to the original screen files
2. Updated both screens to redirect to their page counterparts
3. Kept the old implementation as commented code for reference
4. Added proper documentation to the page components

### Build Issues
During testing, we encountered build errors unrelated to our migration:
- Generated code in the lib/generated directory has path issues with 'part of' declarations
- These issues are outside the scope of the presentation layer migration
- Our specific migrated files pass the analyzer check with only unused import warnings

### Next Steps
1. Continue with migration of graph_application.dart → graph_page.dart
2. Address unused imports in the migrated files
3. Add support for named routes for the newly migrated pages
4. Update any other references to the deprecated screens

## Migration Progress Tracking

| Component                 | Original Location                         | New Location                  | Status        | Issues                                                  |
| ------------------------- | ----------------------------------------- | ----------------------------- | ------------- | ------------------------------------------------------- |
| ModelPage                 | pages/model_page.dart                     | (Fixed in place)              | ✅ Done        | Missing imports                                         |
| HomePage                  | screens/home_page.dart                    | pages/home/home_page.dart     | 🔄 In progress | Multiple references                                     |
| ModelDetailScreenScaffold | screens/model_detail_screen_scaffold.dart | pages/model_detail_page.dart  | ✅ Done        | Added deprecation notice, redirects to ModelDetailPage  |
| DomainDetailScreen        | screens/domain_detail_screen.dart         | pages/domain_detail_page.dart | ✅ Done        | Added deprecation notice, redirects to DomainDetailPage |
| GraphApplication          | screens/graph_application.dart            | pages/graph_page.dart         | 📝 Planned     | -                                                       |

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