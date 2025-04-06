# EDNet One Presentation Layer Follow-up Tasks

This document tracks tasks that have been deferred from the main migration plan or require additional attention after the current migration phase.

## Completed Phase 1 Tasks

- [x] Create script to remove unused imports throughout the codebase (fix_unused_imports.dart)
- [x] Create script to update deprecated API usage (update_material_apis.dart)
- [x] Create shell script to run all cleanup tools (run_cleanup.sh)
- [x] Run cleanup scripts on the codebase
- [x] Create script to update withOpacity calls to use withValues (fix_opacity_api.dart)
- [x] Update all withOpacity calls to use the newer withValues API:
  - [x] Fixed 85 instances in the initial run
  - [x] Fixed withOpacity in relationship_navigator.dart 
  - [x] Fixed withOpacity in home_page.dart BoxShadow
- [x] Create script to fix unused variables (fix_unused_variables.dart)
- [x] Create script to fix BLoC warnings (fix_bloc_warnings.dart)
- [x] Create script to fix dead code (fix_dead_code.dart)
- [x] Fix path issues in cleanup scripts so they run properly
- [x] Update fix_unused_imports.dart, fix_opacity_api.dart, and other scripts to handle paths correctly
- [x] Fix incorrect @override annotations in BLoC state classes
- [x] Fix DomainSelectionState field name change (allDomains -> availableDomains)
- [x] Fix remaining method reference in home_page.dart (updateDomainsDirectly -> updateDomains)

## Remaining Phase 1 Tasks

- [ ] Run fix_unused_variables.dart to fix unused variables
- [ ] Run fix_bloc_warnings.dart to fix remaining BLoC issues 
- [ ] Run fix_dead_code.dart to fix dead code in service classes

## Phase 3: Component Structure Cleanup

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

## Phase 4: Screen Directory Removal

- [ ] Remove screen files
- [ ] Update imports across the codebase
- [ ] Validate all functionality still works

## Post-Migration Improvements

- [ ] Implement proper UI model layer (ednet_core integration)
- [ ] Enhance navigation with deep linking support
- [ ] Improve component reusability
- [ ] Dark mode support implementation
- [ ] Add accessibility features
- [ ] Create component showcase and documentation
- [ ] Implement responsive layouts for mobile support

## Performance Optimizations

- [ ] Implement widget memoization for frequently used components
- [ ] Optimize rendering for large entity lists
- [ ] Add lazy loading for complex page hierarchies
- [ ] Implement virtualized scrolling for long lists
- [ ] Optimize BLoC state management with selective rebuilds

## Current Progress Summary

We've made significant progress on the analyzer warning fixes by creating a suite of specialized tools that can automatically identify and fix various issues:

1. Completed all tool development for Phase 1:
   - fix_unused_imports.dart for removing unused imports
   - update_material_apis.dart for updating deprecated Material APIs
   - fix_opacity_api.dart for updating withOpacity calls to withValues
   - fix_unused_variables.dart for commenting out unused variables
   - fix_bloc_warnings.dart for fixing BLoC-related issues
   - fix_dead_code.dart for fixing dead code in service classes
   - run_cleanup.sh shell script to orchestrate all cleanup tools

2. Successfully applied multiple fixes:
   - Fixed all withOpacity to withValues conversions (87 instances)
   - Fixed incorrect @override annotations in state classes
   - Updated state field names for consistency (allDomains -> availableDomains)
   - Updated method calls for compatibility with renamed methods

3. Current analyzer state shows 114 issues (21 warnings and 93 info items)
   - Most warnings are related to unused variables
   - A few BLoC warnings remain
   - Most info items are related to print statements in tool scripts (which can be ignored)

The next step is to run our cleanup scripts to fix the remaining analyzer warnings before moving on to Phase 3 (Component Structure Cleanup).

## Next Steps

1. Run the analyzer warning fix scripts:
   ```bash
   cd apps/one/lib/presentation
   dart tools/fix_unused_variables.dart
   dart tools/fix_bloc_warnings.dart
   dart tools/fix_dead_code.dart
   ```

2. Verify all analysis warnings are fixed by running:
   ```bash
   cd apps/one
   dart analyze lib/presentation
   ```

3. Begin planning for Phase 3 (Component Structure Cleanup)
   - Start with entity_widget.dart decomposition
   - Create a component structure design document

## Timeline

Tasks will be prioritized based on:
1. Impact on user experience
2. Technical debt reduction value
3. Effort required
4. Dependencies with other tasks

**Next Immediate Tasks:**
1. Fix remaining analyzer warnings (types, unused variables, etc.)
2. Complete unit tests for new page components (currently at 60% coverage)
3. Begin Component Structure cleanup (Phase 3) 