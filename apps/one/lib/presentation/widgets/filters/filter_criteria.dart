
/// Operator types for filter conditions
enum FilterOperator {
  equals,
  notEquals,
  contains,
  notContains,
  startsWith,
  endsWith,
  greaterThan,
  lessThan,
  greaterThanOrEquals,
  lessThanOrEquals,
  between,
  isIn,
  notIn,
  isNull,
  isNotNull,
}

/// Types of values that can be filtered
enum FilterValueType { text, number, date, boolean, relation }

/// A class representing a single filter criterion
class FilterCriteria {
  /// The attribute or property name to filter on
  final String field;

  /// The operation to apply in the filter
  final FilterOperator operator;

  /// The data type of the field being filtered
  final FilterValueType valueType;

  /// The value(s) to compare with
  final dynamic value;

  /// Optional secondary value for operations like 'between'
  final dynamic secondaryValue;

  /// Whether this filter is currently active
  final bool isActive;

  const FilterCriteria({
    required this.field,
    required this.operator,
    required this.valueType,
    this.value,
    this.secondaryValue,
    this.isActive = true,
  });

  /// Create a copy of this filter with updated properties
  FilterCriteria copyWith({
    String? field,
    FilterOperator? operator,
    FilterValueType? valueType,
    dynamic value,
    dynamic secondaryValue,
    bool? isActive,
  }) {
    return FilterCriteria(
      field: field ?? this.field,
      operator: operator ?? this.operator,
      valueType: valueType ?? this.valueType,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Toggle the active state of this filter
  FilterCriteria toggleActive() {
    return copyWith(isActive: !isActive);
  }

  /// Get a human-readable representation of the operator
  String get operatorLabel {
    switch (operator) {
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

  /// Get a string representation of the filter
  String get displayText {
    String valueText = '';

    if (operator == FilterOperator.between && secondaryValue != null) {
      valueText = '$value and $secondaryValue';
    } else if (operator == FilterOperator.isNull ||
        operator == FilterOperator.isNotNull) {
      valueText = '';
    } else if (value is List) {
      valueText = (value as List).join(', ');
    } else {
      valueText = value?.toString() ?? '';
    }

    return '$field $operatorLabel ${valueText.isNotEmpty ? valueText : ''}';
  }
}

/// Combines multiple filter criteria
class FilterGroup {
  /// List of filter criteria in this group
  final List<FilterCriteria> criteria;

  /// How the criteria should be combined (AND/OR)
  final FilterGroupLogic logic;

  /// Optional name for saved filter groups
  final String? name;

  const FilterGroup({
    required this.criteria,
    this.logic = FilterGroupLogic.and,
    this.name,
  });

  /// Create a copy with new properties
  FilterGroup copyWith({
    List<FilterCriteria>? criteria,
    FilterGroupLogic? logic,
    String? name,
  }) {
    return FilterGroup(
      criteria: criteria ?? this.criteria,
      logic: logic ?? this.logic,
      name: name ?? this.name,
    );
  }

  /// Add a criterion to this group
  FilterGroup addCriterion(FilterCriteria criterion) {
    return copyWith(criteria: [...criteria, criterion]);
  }

  /// Remove a criterion at the specified index
  FilterGroup removeCriterion(int index) {
    if (index < 0 || index >= criteria.length) return this;

    final newCriteria = List<FilterCriteria>.from(criteria);
    newCriteria.removeAt(index);
    return copyWith(criteria: newCriteria);
  }

  /// Update a criterion at the specified index
  FilterGroup updateCriterion(int index, FilterCriteria criterion) {
    if (index < 0 || index >= criteria.length) return this;

    final newCriteria = List<FilterCriteria>.from(criteria);
    newCriteria[index] = criterion;
    return copyWith(criteria: newCriteria);
  }

  /// Toggle the logic between AND/OR
  FilterGroup toggleLogic() {
    return copyWith(
      logic:
          logic == FilterGroupLogic.and
              ? FilterGroupLogic.or
              : FilterGroupLogic.and,
    );
  }

  /// Check if this filter group has any active criteria
  bool get hasActiveCriteria => criteria.any((criterion) => criterion.isActive);

  /// Get only the active criteria
  List<FilterCriteria> get activeCriteria =>
      criteria.where((criterion) => criterion.isActive).toList();
}

/// Logic for combining filter criteria
enum FilterGroupLogic { and, or }
