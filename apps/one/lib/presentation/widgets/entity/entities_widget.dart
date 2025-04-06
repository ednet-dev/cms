import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/providers/filter_manager.dart';
import '../filters/filter_button.dart';
import '../filters/filter_criteria.dart' as filters;
import '../bookmarks/bookmark_manager.dart';
import '../bookmarks/bookmark_model.dart';
import 'entity_collection_view.dart';

/// Widget for displaying a collection of entities
class EntitiesWidget extends StatefulWidget {
  /// The entities to display
  final Entities entities;

  /// Optional callback when an entity is selected
  final void Function(Entity entity)? onEntitySelected;

  /// Optional bookmark manager to create bookmarks from entities
  final BookmarkManager? bookmarkManager;

  /// Optional callback when a bookmark is created
  final void Function(Bookmark bookmark)? onBookmarkCreated;

  /// Constructor for EntitiesWidget
  const EntitiesWidget({
    super.key,
    required this.entities,
    this.onEntitySelected,
    this.bookmarkManager,
    this.onBookmarkCreated,
  });

  @override
  State<EntitiesWidget> createState() => _EntitiesWidgetState();
}

class _EntitiesWidgetState extends State<EntitiesWidget> {
  late ViewMode _currentViewMode;
  String? _searchQuery;

  // Map of entity attributes to their filter types
  late Map<String, filters.FilterValueType> _attributeTypes;
  // List of filterable attributes
  late List<String> _filterableAttributes;

  @override
  void initState() {
    super.initState();
    _currentViewMode = ViewMode.cards;
    _initFilterAttributes();
  }

  /// Initialize filterable attributes based on the entities
  void _initFilterAttributes() {
    _attributeTypes = {};
    final attributes = <String>{};

    // Extract attributes from the first few entities to determine types
    int count = 0;
    for (var entity in widget.entities) {
      if (count > 10) break; // Sample up to 10 entities

      try {
        final concept = entity.concept;
        if (concept == null) continue;

        final attrs = concept.attributes;

        for (var attr in attrs) {
          attributes.add(attr.code);

          // Check for null attribute type
          if (attr.type?.code == null) {
            _attributeTypes[attr.code] = filters.FilterValueType.text;
            continue;
          }

          // Determine attribute type
          switch (attr.type?.code) {
            case 'String':
            case 'Email':
            case 'Uri':
            case 'Text':
              _attributeTypes[attr.code] = filters.FilterValueType.text;
              break;
            case 'DateTime':
            case 'Date':
            case 'Time':
              _attributeTypes[attr.code] = filters.FilterValueType.date;
              break;
            case 'int':
            case 'Integer':
            case 'double':
            case 'num':
            case 'Decimal':
              _attributeTypes[attr.code] = filters.FilterValueType.number;
              break;
            case 'bool':
            case 'Boolean':
              _attributeTypes[attr.code] = filters.FilterValueType.boolean;
              break;
            default:
              _attributeTypes[attr.code] = filters.FilterValueType.text;
          }
        }
      } catch (e) {
        // Skip entities that don't have proper concept structure
      }
      count++;
    }

    _filterableAttributes = attributes.toList();
  }

  // Filter entities based on search query and active filter
  bool _filterEntity(dynamic entity) {
    final entityObj = entity as Entity;

    // Apply text search filter
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      final query = _searchQuery!.toLowerCase();

      // Check entity code
      if (entityObj.code.toLowerCase().contains(query)) {
        return _applyFilterCriteria(entityObj);
      }

      // Check concept
      try {
        if (entityObj.concept.code.toLowerCase().contains(query)) {
          return _applyFilterCriteria(entityObj);
        }
      } catch (e) {
        // If we can't access concept, just continue
      }

      // Check common attributes
      try {
        for (var attrCode in ['name', 'title', 'description', 'id']) {
          final value = entityObj.getAttribute(attrCode);
          if (value != null && value.toString().toLowerCase().contains(query)) {
            return _applyFilterCriteria(entityObj);
          }
        }
      } catch (e) {
        // If we can't access attributes, just continue
      }

      return false;
    }

    // If no search query, just apply filter criteria
    return _applyFilterCriteria(entityObj);
  }

  // Apply filter criteria to an entity
  bool _applyFilterCriteria(Entity entity) {
    final filterManager = Provider.of<FilterManager>(context, listen: false);
    final activeFilter = filterManager.activeFilter;

    // If no active filter, return true (show all)
    if (activeFilter == null || !activeFilter.hasActiveCriteria) {
      return true;
    }

    // Get only active criteria
    final activeCriteria = activeFilter.activeCriteria;

    // Apply filter logic (AND/OR)
    if (activeFilter.logic == filters.FilterGroupLogic.and) {
      // Must match ALL criteria
      for (var criterion in activeCriteria) {
        if (!_matchesCriterion(entity, criterion)) {
          return false;
        }
      }
      return true;
    } else {
      // Must match ANY criterion
      if (activeCriteria.isEmpty) return true;

      for (var criterion in activeCriteria) {
        if (_matchesCriterion(entity, criterion)) {
          return true;
        }
      }
      return false;
    }
  }

  // Check if an entity matches a specific criterion
  bool _matchesCriterion(Entity entity, filters.FilterCriteria criterion) {
    try {
      // Get attribute value
      final attrValue = entity.getAttribute(criterion.field);

      // Check for null conditions
      if (criterion.operator == filters.FilterOperator.isNull) {
        return attrValue == null;
      }
      if (criterion.operator == filters.FilterOperator.isNotNull) {
        return attrValue != null;
      }

      // If value is null and we're not checking for null, no match
      if (attrValue == null) {
        return false;
      }

      // Convert to string for comparison
      final stringValue = attrValue.toString().toLowerCase();

      // Apply different operators
      switch (criterion.operator) {
        case filters.FilterOperator.equals:
          return stringValue == criterion.value.toString().toLowerCase();
        case filters.FilterOperator.notEquals:
          return stringValue != criterion.value.toString().toLowerCase();
        case filters.FilterOperator.contains:
          return stringValue.contains(criterion.value.toString().toLowerCase());
        case filters.FilterOperator.notContains:
          return !stringValue.contains(
            criterion.value.toString().toLowerCase(),
          );
        case filters.FilterOperator.startsWith:
          return stringValue.startsWith(
            criterion.value.toString().toLowerCase(),
          );
        case filters.FilterOperator.endsWith:
          return stringValue.endsWith(criterion.value.toString().toLowerCase());
        case filters.FilterOperator.greaterThan:
          if (attrValue is num && criterion.value is num) {
            return attrValue > criterion.value;
          }
          return stringValue.compareTo(
                criterion.value.toString().toLowerCase(),
              ) >
              0;
        case filters.FilterOperator.lessThan:
          if (attrValue is num && criterion.value is num) {
            return attrValue < criterion.value;
          }
          return stringValue.compareTo(
                criterion.value.toString().toLowerCase(),
              ) <
              0;
        case filters.FilterOperator.greaterThanOrEquals:
          if (attrValue is num && criterion.value is num) {
            return attrValue >= criterion.value;
          }
          return stringValue.compareTo(
                criterion.value.toString().toLowerCase(),
              ) >=
              0;
        case filters.FilterOperator.lessThanOrEquals:
          if (attrValue is num && criterion.value is num) {
            return attrValue <= criterion.value;
          }
          return stringValue.compareTo(
                criterion.value.toString().toLowerCase(),
              ) <=
              0;
        case filters.FilterOperator.between:
          if (attrValue is num &&
              criterion.value is num &&
              criterion.secondaryValue is num) {
            return attrValue >= criterion.value &&
                attrValue <= criterion.secondaryValue;
          }
          return false;
        case filters.FilterOperator.isIn:
          if (criterion.value is List) {
            return (criterion.value as List).any(
              (val) => stringValue == val.toString().toLowerCase(),
            );
          }
          return false;
        case filters.FilterOperator.notIn:
          if (criterion.value is List) {
            return !(criterion.value as List).any(
              (val) => stringValue == val.toString().toLowerCase(),
            );
          }
          return false;
        default:
          return false;
      }
    } catch (e) {
      // If any error occurs during filtering, consider it a non-match
      return false;
    }
  }

  // Group entities by concept
  String _groupByConceptCode(dynamic entity) {
    final entityObj = entity as Entity;
    try {
      return entityObj.concept.code;
    } catch (e) {
      return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search and Filter bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Search field
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search entities...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerLowest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // Filter button
              const SizedBox(width: 8),
              FilterButton(
                availableFields: _filterableAttributes,
                fieldTypes: _attributeTypes,
                onFilterApplied: (filter) {
                  // This will trigger a rebuild through the provider
                  Provider.of<FilterManager>(
                    context,
                    listen: false,
                  ).setActiveFilter(filter);
                },
              ),

              // View mode toggle
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _currentViewMode == ViewMode.cards
                      ? Icons.view_list
                      : Icons.grid_view,
                ),
                tooltip: 'Toggle view mode',
                onPressed: () {
                  setState(() {
                    _currentViewMode =
                        _currentViewMode == ViewMode.cards
                            ? ViewMode.table
                            : ViewMode.cards;
                  });
                },
              ),
            ],
          ),
        ),

        // Entity collection view
        Expanded(
          child: EntityCollectionView(
            entities: widget.entities,
            viewMode: _currentViewMode,
            onEntitySelected: widget.onEntitySelected,
            filter: _filterEntity,
            groupBy: _groupByConceptCode,
          ),
        ),
      ],
    );
  }
}
