import 'package:flutter/material.dart';
import 'filter_criteria.dart';

/// A widget that allows users to build complex filter conditions
class FilterBuilder extends StatefulWidget {
  /// The current filter group being built or edited
  final FilterGroup filterGroup;

  /// Callback when the filter group is updated
  final ValueChanged<FilterGroup> onFilterGroupChanged;

  /// List of available fields that can be filtered
  final List<String> availableFields;

  /// Map of field names to their data types
  final Map<String, FilterValueType> fieldTypes;

  const FilterBuilder({
    super.key,
    required this.filterGroup,
    required this.onFilterGroupChanged,
    required this.availableFields,
    required this.fieldTypes,
  });

  @override
  State<FilterBuilder> createState() => _FilterBuilderState();
}

class _FilterBuilderState extends State<FilterBuilder> {
  late FilterGroup _filterGroup;

  @override
  void initState() {
    super.initState();
    _filterGroup = widget.filterGroup;
  }

  @override
  void didUpdateWidget(FilterBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterGroup != widget.filterGroup) {
      _filterGroup = widget.filterGroup;
    }
  }

  /// Add a new empty criterion to the filter group
  void _addCriterion() {
    final defaultField =
        widget.availableFields.isNotEmpty ? widget.availableFields.first : '';
    final defaultType = widget.fieldTypes[defaultField] ?? FilterValueType.text;

    final newCriterion = FilterCriteria(
      field: defaultField,
      operator: _getDefaultOperatorForType(defaultType),
      valueType: defaultType,
    );

    _updateFilterGroup(_filterGroup.addCriterion(newCriterion));
  }

  /// Remove a criterion at the specified index
  void _removeCriterion(int index) {
    _updateFilterGroup(_filterGroup.removeCriterion(index));
  }

  /// Update a criterion at the specified index
  void _updateCriterion(int index, FilterCriteria criterion) {
    _updateFilterGroup(_filterGroup.updateCriterion(index, criterion));
  }

  /// Toggle the filter group logic between AND/OR
  void _toggleLogic() {
    _updateFilterGroup(_filterGroup.toggleLogic());
  }

  /// Update the filter group and notify parent
  void _updateFilterGroup(FilterGroup filterGroup) {
    setState(() {
      _filterGroup = filterGroup;
    });
    widget.onFilterGroupChanged(filterGroup);
  }

  /// Get the default operator for a given value type
  FilterOperator _getDefaultOperatorForType(FilterValueType type) {
    switch (type) {
      case FilterValueType.text:
        return FilterOperator.contains;
      case FilterValueType.number:
        return FilterOperator.equals;
      case FilterValueType.date:
        return FilterOperator.equals;
      case FilterValueType.boolean:
        return FilterOperator.equals;
      case FilterValueType.relation:
        return FilterOperator.isIn;
    }
  }

  /// Get available operators for a given value type
  List<FilterOperator> _getOperatorsForType(FilterValueType type) {
    switch (type) {
      case FilterValueType.text:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.contains,
          FilterOperator.notContains,
          FilterOperator.startsWith,
          FilterOperator.endsWith,
          FilterOperator.isNull,
          FilterOperator.isNotNull,
        ];
      case FilterValueType.number:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.greaterThan,
          FilterOperator.lessThan,
          FilterOperator.greaterThanOrEquals,
          FilterOperator.lessThanOrEquals,
          FilterOperator.between,
          FilterOperator.isIn,
          FilterOperator.isNull,
          FilterOperator.isNotNull,
        ];
      case FilterValueType.date:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.greaterThan,
          FilterOperator.lessThan,
          FilterOperator.greaterThanOrEquals,
          FilterOperator.lessThanOrEquals,
          FilterOperator.between,
          FilterOperator.isNull,
          FilterOperator.isNotNull,
        ];
      case FilterValueType.boolean:
        return [
          FilterOperator.equals,
          FilterOperator.isNull,
          FilterOperator.isNotNull,
        ];
      case FilterValueType.relation:
        return [
          FilterOperator.isIn,
          FilterOperator.notIn,
          FilterOperator.isNull,
          FilterOperator.isNotNull,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logic selector (AND/OR)
        Row(
          children: [
            Text('Match', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(width: 16),
            SegmentedButton<FilterGroupLogic>(
              segments: const [
                ButtonSegment<FilterGroupLogic>(
                  value: FilterGroupLogic.and,
                  label: Text('ALL conditions'),
                ),
                ButtonSegment<FilterGroupLogic>(
                  value: FilterGroupLogic.or,
                  label: Text('ANY condition'),
                ),
              ],
              selected: {_filterGroup.logic},
              onSelectionChanged: (Set<FilterGroupLogic> selection) {
                if (selection.isNotEmpty) {
                  _toggleLogic();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Criteria list
        ..._filterGroup.criteria.asMap().entries.map((entry) {
          final index = entry.key;
          final criterion = entry.value;
          return _buildCriterionRow(criterion, index);
        }),

        // Add button
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _addCriterion,
          icon: const Icon(Icons.add),
          label: const Text('Add Condition'),
        ),
      ],
    );
  }

  /// Build a row for a single criterion
  Widget _buildCriterionRow(FilterCriteria criterion, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field selector
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: criterion.field,
              decoration: const InputDecoration(
                labelText: 'Field',
                border: OutlineInputBorder(),
              ),
              items:
                  widget.availableFields.map((field) {
                    return DropdownMenuItem<String>(
                      value: field,
                      child: Text(field),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  final newType =
                      widget.fieldTypes[value] ?? FilterValueType.text;
                  final newOperator = _getDefaultOperatorForType(newType);
                  _updateCriterion(
                    index,
                    criterion.copyWith(
                      field: value,
                      valueType: newType,
                      operator: newOperator,
                      value: null,
                      secondaryValue: null,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),

          // Operator selector
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<FilterOperator>(
              value: criterion.operator,
              decoration: const InputDecoration(
                labelText: 'Operator',
                border: OutlineInputBorder(),
              ),
              items:
                  _getOperatorsForType(criterion.valueType).map((operator) {
                    return DropdownMenuItem<FilterOperator>(
                      value: operator,
                      child: Text(operator.operatorLabel),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _updateCriterion(
                    index,
                    criterion.copyWith(
                      operator: value,
                      // Clear values if changing to a null/not null operator
                      value:
                          (value == FilterOperator.isNull ||
                                  value == FilterOperator.isNotNull)
                              ? null
                              : criterion.value,
                      secondaryValue:
                          (value == FilterOperator.isNull ||
                                  value == FilterOperator.isNotNull ||
                                  value != FilterOperator.between)
                              ? null
                              : criterion.secondaryValue,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),

          // Value input
          if (criterion.operator != FilterOperator.isNull &&
              criterion.operator != FilterOperator.isNotNull)
            Expanded(flex: 4, child: _buildValueInput(criterion, index)),

          // Remove button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _removeCriterion(index),
            tooltip: 'Remove condition',
          ),
        ],
      ),
    );
  }

  /// Build the appropriate input widget based on filter type
  Widget _buildValueInput(FilterCriteria criterion, int index) {
    // Handle between operator which needs two inputs
    if (criterion.operator == FilterOperator.between) {
      return Row(
        children: [
          Expanded(
            child: _buildSingleValueInput(criterion, index, isSecondary: false),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('and'),
          ),
          Expanded(
            child: _buildSingleValueInput(criterion, index, isSecondary: true),
          ),
        ],
      );
    }

    // For isIn and notIn, we'd ideally have a multi-select input
    // Simplified for now with a comma-separated text input
    if (criterion.operator == FilterOperator.isIn ||
        criterion.operator == FilterOperator.notIn) {
      return TextFormField(
        initialValue:
            criterion.value is List
                ? (criterion.value as List).join(', ')
                : criterion.value?.toString() ?? '',
        decoration: const InputDecoration(
          labelText: 'Values (comma separated)',
          border: OutlineInputBorder(),
          hintText: 'Enter values separated by commas',
        ),
        onChanged: (value) {
          final valuesList =
              value
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

          _updateCriterion(index, criterion.copyWith(value: valuesList));
        },
      );
    }

    // For all other operators
    return _buildSingleValueInput(criterion, index);
  }

  /// Build an input for a single value based on the value type
  Widget _buildSingleValueInput(
    FilterCriteria criterion,
    int index, {
    bool isSecondary = false,
  }) {
    switch (criterion.valueType) {
      case FilterValueType.text:
        return TextFormField(
          initialValue:
              isSecondary
                  ? criterion.secondaryValue?.toString() ?? ''
                  : criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Value',
            border: const OutlineInputBorder(),
            hintText: 'Enter text value',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          onChanged: (value) {
            if (isSecondary) {
              _updateCriterion(
                index,
                criterion.copyWith(secondaryValue: value),
              );
            } else {
              _updateCriterion(index, criterion.copyWith(value: value));
            }
          },
        );

      case FilterValueType.number:
        return TextFormField(
          initialValue:
              isSecondary
                  ? criterion.secondaryValue?.toString() ?? ''
                  : criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Value',
            border: const OutlineInputBorder(),
            hintText: 'Enter numeric value',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final numericValue = double.tryParse(value);
            if (isSecondary) {
              _updateCriterion(
                index,
                criterion.copyWith(secondaryValue: numericValue),
              );
            } else {
              _updateCriterion(index, criterion.copyWith(value: numericValue));
            }
          },
        );

      case FilterValueType.date:
        // Simplified date input for now
        // In a real app, you'd use a DatePicker
        return TextFormField(
          initialValue:
              isSecondary
                  ? criterion.secondaryValue?.toString() ?? ''
                  : criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Date',
            border: const OutlineInputBorder(),
            hintText: 'YYYY-MM-DD',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                // Would show a date picker here
              },
            ),
          ),
          onChanged: (value) {
            if (isSecondary) {
              _updateCriterion(
                index,
                criterion.copyWith(secondaryValue: value),
              );
            } else {
              _updateCriterion(index, criterion.copyWith(value: value));
            }
          },
        );

      case FilterValueType.boolean:
        final boolValue =
            isSecondary
                ? criterion.secondaryValue == true
                : criterion.value == true;

        return DropdownButtonFormField<bool>(
          value: boolValue,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: const [
            DropdownMenuItem<bool>(value: true, child: Text('True')),
            DropdownMenuItem<bool>(value: false, child: Text('False')),
          ],
          onChanged: (value) {
            if (value != null) {
              if (isSecondary) {
                _updateCriterion(
                  index,
                  criterion.copyWith(secondaryValue: value),
                );
              } else {
                _updateCriterion(index, criterion.copyWith(value: value));
              }
            }
          },
        );

      case FilterValueType.relation:
        // For relation, we'd ideally have an entity selector
        // Simplified for now with a text input for the ID
        return TextFormField(
          initialValue:
              isSecondary
                  ? criterion.secondaryValue?.toString() ?? ''
                  : criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Entity ID',
            border: const OutlineInputBorder(),
            hintText: 'Enter entity ID',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Would show an entity search dialog here
              },
            ),
          ),
          onChanged: (value) {
            if (isSecondary) {
              _updateCriterion(
                index,
                criterion.copyWith(secondaryValue: value),
              );
            } else {
              _updateCriterion(index, criterion.copyWith(value: value));
            }
          },
        );
    }
  }
}

/// Extension to get the operator label
extension FilterOperatorExtension on FilterOperator {
  String get operatorLabel {
    switch (this) {
      case FilterOperator.equals:
        return 'equals';
      case FilterOperator.notEquals:
        return 'not equals';
      case FilterOperator.contains:
        return 'contains';
      case FilterOperator.notContains:
        return 'does not contain';
      case FilterOperator.startsWith:
        return 'starts with';
      case FilterOperator.endsWith:
        return 'ends with';
      case FilterOperator.greaterThan:
        return 'greater than';
      case FilterOperator.lessThan:
        return 'less than';
      case FilterOperator.greaterThanOrEquals:
        return 'greater than or equals';
      case FilterOperator.lessThanOrEquals:
        return 'less than or equals';
      case FilterOperator.between:
        return 'between';
      case FilterOperator.isIn:
        return 'in';
      case FilterOperator.notIn:
        return 'not in';
      case FilterOperator.isNull:
        return 'is empty';
      case FilterOperator.isNotNull:
        return 'is not empty';
    }
  }
}
