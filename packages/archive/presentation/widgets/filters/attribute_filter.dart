import 'package:flutter/material.dart';
import 'filter_criteria.dart';

/// A specialized filter component for entity attributes
class AttributeFilter extends StatefulWidget {
  /// The current filter criterion
  final FilterCriteria criterion;

  /// Available attributes to filter on
  final List<String> availableAttributes;

  /// Map of attribute names to their types
  final Map<String, FilterValueType> attributeTypes;

  /// Callback when the filter criterion changes
  final ValueChanged<FilterCriteria> onFilterChanged;

  const AttributeFilter({
    super.key,
    required this.criterion,
    required this.availableAttributes,
    required this.attributeTypes,
    required this.onFilterChanged,
  });

  @override
  State<AttributeFilter> createState() => _AttributeFilterState();
}

class _AttributeFilterState extends State<AttributeFilter> {
  late FilterCriteria _criterion;

  @override
  void initState() {
    super.initState();
    _criterion = widget.criterion;
  }

  @override
  void didUpdateWidget(AttributeFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.criterion != widget.criterion) {
      _criterion = widget.criterion;
    }
  }

  /// Update the attribute selection
  void _updateAttribute(String? attribute) {
    if (attribute != null) {
      final type = widget.attributeTypes[attribute] ?? FilterValueType.text;
      final newOperator = _getDefaultOperatorForType(type);

      final newCriterion = _criterion.copyWith(
        field: attribute,
        valueType: type,
        operator: newOperator,
        value: null,
        secondaryValue: null,
      );

      _updateFilter(newCriterion);
    }
  }

  /// Update the operator selection
  void _updateOperator(FilterOperator? operator) {
    if (operator != null) {
      final newCriterion = _criterion.copyWith(
        operator: operator,
        value:
            (operator == FilterOperator.isNull ||
                    operator == FilterOperator.isNotNull)
                ? null
                : _criterion.value,
        secondaryValue:
            (operator == FilterOperator.isNull ||
                    operator == FilterOperator.isNotNull ||
                    operator != FilterOperator.between)
                ? null
                : _criterion.secondaryValue,
      );

      _updateFilter(newCriterion);
    }
  }

  /// Update the value
  void _updateValue(dynamic value) {
    final newCriterion = _criterion.copyWith(value: value);
    _updateFilter(newCriterion);
  }

  /// Update the secondary value
  void _updateSecondaryValue(dynamic value) {
    final newCriterion = _criterion.copyWith(secondaryValue: value);
    _updateFilter(newCriterion);
  }

  /// Update the filter and notify parent
  void _updateFilter(FilterCriteria criterion) {
    setState(() {
      _criterion = criterion;
    });
    widget.onFilterChanged(criterion);
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
      children: [
        // Attribute selector
        DropdownButtonFormField<String>(
          value: _criterion.field,
          decoration: const InputDecoration(
            labelText: 'Attribute',
            border: OutlineInputBorder(),
          ),
          items:
              widget.availableAttributes.map((attribute) {
                return DropdownMenuItem<String>(
                  value: attribute,
                  child: Text(attribute),
                );
              }).toList(),
          onChanged: _updateAttribute,
        ),
        const SizedBox(height: 16),

        // Operator selector
        DropdownButtonFormField<FilterOperator>(
          value: _criterion.operator,
          decoration: const InputDecoration(
            labelText: 'Operator',
            border: OutlineInputBorder(),
          ),
          items:
              _getOperatorsForType(_criterion.valueType).map((operator) {
                return DropdownMenuItem<FilterOperator>(
                  value: operator,
                  child: Text(operator.operatorLabel),
                );
              }).toList(),
          onChanged: _updateOperator,
        ),
        const SizedBox(height: 16),

        // Value input
        if (_criterion.operator != FilterOperator.isNull &&
            _criterion.operator != FilterOperator.isNotNull)
          _buildValueInput(),
      ],
    );
  }

  /// Build the appropriate value input based on filter type
  Widget _buildValueInput() {
    // Handle between operator which needs two inputs
    if (_criterion.operator == FilterOperator.between) {
      return Row(
        children: [
          Expanded(child: _buildValueControl(isSecondary: false)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('and'),
          ),
          Expanded(child: _buildValueControl(isSecondary: true)),
        ],
      );
    }

    // For isIn and notIn operators
    if (_criterion.operator == FilterOperator.isIn ||
        _criterion.operator == FilterOperator.notIn) {
      return TextFormField(
        initialValue:
            _criterion.value is List
                ? (_criterion.value as List).join(', ')
                : _criterion.value?.toString() ?? '',
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

          _updateValue(valuesList);
        },
      );
    }

    // For all other operators
    return _buildValueControl();
  }

  /// Build input control based on value type
  Widget _buildValueControl({bool isSecondary = false}) {
    switch (_criterion.valueType) {
      case FilterValueType.text:
        return TextFormField(
          initialValue:
              isSecondary
                  ? _criterion.secondaryValue?.toString() ?? ''
                  : _criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Value',
            border: const OutlineInputBorder(),
            hintText: 'Enter text value',
          ),
          onChanged: (value) {
            if (isSecondary) {
              _updateSecondaryValue(value);
            } else {
              _updateValue(value);
            }
          },
        );

      case FilterValueType.number:
        return TextFormField(
          initialValue:
              isSecondary
                  ? _criterion.secondaryValue?.toString() ?? ''
                  : _criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Value',
            border: const OutlineInputBorder(),
            hintText: 'Enter numeric value',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final numericValue = double.tryParse(value);
            if (isSecondary) {
              _updateSecondaryValue(numericValue);
            } else {
              _updateValue(numericValue);
            }
          },
        );

      case FilterValueType.date:
        return TextFormField(
          initialValue:
              isSecondary
                  ? _criterion.secondaryValue?.toString() ?? ''
                  : _criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Date',
            border: const OutlineInputBorder(),
            hintText: 'YYYY-MM-DD',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                // Would show a date picker here
              },
            ),
          ),
          onChanged: (value) {
            if (isSecondary) {
              _updateSecondaryValue(value);
            } else {
              _updateValue(value);
            }
          },
        );

      case FilterValueType.boolean:
        final boolValue =
            isSecondary
                ? _criterion.secondaryValue == true
                : _criterion.value == true;

        return DropdownButtonFormField<bool>(
          value: boolValue,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem<bool>(value: true, child: Text('True')),
            DropdownMenuItem<bool>(value: false, child: Text('False')),
          ],
          onChanged: (value) {
            if (value != null) {
              if (isSecondary) {
                _updateSecondaryValue(value);
              } else {
                _updateValue(value);
              }
            }
          },
        );

      case FilterValueType.relation:
        return TextFormField(
          initialValue:
              isSecondary
                  ? _criterion.secondaryValue?.toString() ?? ''
                  : _criterion.value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Entity ID',
            border: const OutlineInputBorder(),
            hintText: 'Enter entity ID',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Would show an entity search dialog here
              },
            ),
          ),
          onChanged: (value) {
            if (isSecondary) {
              _updateSecondaryValue(value);
            } else {
              _updateValue(value);
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
