# Entity Filtering System

This directory contains components that implement a robust filtering system for entities in the EDNet One application.

## Components

### Models

- **FilterCriteria**: Represents a single filter condition with field, operator, and value(s).
- **FilterGroup**: Combines multiple criteria with AND/OR logic for complex filtering.
- **FilterPreset**: Saved filter configurations that can be applied quickly.

### UI Components

- **FilterBuilder**: UI for building complex filter conditions with multiple criteria.
- **AttributeFilter**: Specialized filter component for entity attributes.
- **RelationFilter**: Specialized filter component for entity relationships.
- **FilterDrawer**: Main filter UI container that slides in from the right.
- **FilterButton**: Button that opens the filter drawer when tapped.

### State Management

- **FilterManager**: Service class that manages filter state and persistence with SharedPreferences.

## Usage

To add filtering capability to an entity collection:

1. Add the `FilterButton` to your UI:
```dart
FilterButton(
  availableFields: fieldsList,  // List of field names that can be filtered
  fieldTypes: fieldTypesMap,    // Map of field names to their data types
  onFilterApplied: (filter) {
    // Optional custom filter handling
    // Default is to update FilterManager
  },
)
```

2. Implement filter logic in your entity filtering method:
```dart
bool filterEntity(Entity entity) {
  final filterManager = Provider.of<FilterManager>(context, listen: false);
  final activeFilter = filterManager.activeFilter;
  
  // If no active filter, return true (show all)
  if (activeFilter == null || !activeFilter.hasActiveCriteria) {
    return true;
  }
  
  // Apply filter criteria...
  // (See EntitiesWidget._applyFilterCriteria for complete implementation)
}
```

3. Connect filter button to entity collection view or list.

## Filter UI Flow

1. User clicks on filter button
2. Filter drawer appears with:
   - Build Filter tab: interface to create complex filters
   - Saved Filters tab: list of previously saved filters
3. User builds or selects a filter and clicks Apply
4. Entity list is filtered based on criteria

## Filter Persistence

Filters are automatically saved to SharedPreferences when:
- A filter preset is created
- A filter preset is updated
- A filter preset is deleted

Filter presets can be imported/exported as JSON for sharing or backup. 