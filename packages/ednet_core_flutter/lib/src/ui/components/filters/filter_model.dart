part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Operator types for filter conditions in the UI
enum FilterOperator {
  equals('equals'),
  notEquals('not equals'),
  contains('contains'),
  notContains('does not contain'),
  startsWith('starts with'),
  endsWith('ends with'),
  greaterThan('greater than'),
  lessThan('less than'),
  greaterThanOrEquals('greater than or equals'),
  lessThanOrEquals('less than or equals'),
  between('between'),
  isIn('in'),
  notIn('not in'),
  isNull('is empty'),
  isNotNull('is not empty');

  /// Human-readable representation of the operator
  final String label;

  const FilterOperator(this.label);

  /// Get the appropriate operator for a value type
  static List<FilterOperator> getForType(FilterValueType type) {
    switch (type) {
      case FilterValueType.text:
        return [
          equals,
          notEquals,
          contains,
          notContains,
          startsWith,
          endsWith,
          isNull,
          isNotNull,
        ];
      case FilterValueType.number:
        return [
          equals,
          notEquals,
          greaterThan,
          lessThan,
          greaterThanOrEquals,
          lessThanOrEquals,
          between,
          isIn,
          isNull,
          isNotNull,
        ];
      case FilterValueType.date:
        return [
          equals,
          notEquals,
          greaterThan,
          lessThan,
          greaterThanOrEquals,
          lessThanOrEquals,
          between,
          isNull,
          isNotNull,
        ];
      case FilterValueType.boolean:
        return [
          equals,
          isNull,
          isNotNull,
        ];
      case FilterValueType.relation:
        return [
          isIn,
          notIn,
          isNull,
          isNotNull,
        ];
      case FilterValueType.entity:
        return [
          equals,
          notEquals,
          isIn,
          notIn,
          isNull,
          isNotNull,
        ];
    }
  }
}

/// Types of values that can be filtered
enum FilterValueType {
  text('Text'),
  number('Number'),
  date('Date'),
  boolean('Boolean'),
  relation('Relation'),
  entity('Entity');

  /// Human-readable label for this value type
  final String label;

  const FilterValueType(this.label);
}

/// A single filter criterion for filtering entities or components
///
/// Part of the Shell Architecture UX Component Filter implementation,
/// leveraging the Message Filter enterprise integration pattern.
class FilterCriteria with ProgressiveDisclosure {
  /// Unique identifier for this criterion
  final String id;

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

  /// The disclosure level at which this criterion should be visible
  @override
  final DisclosureLevel disclosureLevel;

  /// Constructor
  FilterCriteria({
    String? id,
    required this.field,
    required this.operator,
    required this.valueType,
    this.value,
    this.secondaryValue,
    this.isActive = true,
    this.disclosureLevel = DisclosureLevel.basic,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Create a copy of this filter criterion with updated properties
  FilterCriteria copyWith({
    String? field,
    FilterOperator? operator,
    FilterValueType? valueType,
    value,
    secondaryValue,
    bool? isActive,
    DisclosureLevel? disclosureLevel,
  }) {
    return FilterCriteria(
      id: id,
      field: field ?? this.field,
      operator: operator ?? this.operator,
      valueType: valueType ?? this.valueType,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      isActive: isActive ?? this.isActive,
      disclosureLevel: disclosureLevel ?? this.disclosureLevel,
    );
  }

  /// Toggle the active state of this filter
  FilterCriteria toggleActive() {
    return copyWith(isActive: !isActive);
  }

  /// Get a human-readable representation of the filter
  String get displayText {
    var valueText = '';

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

    return '$field ${operator.label} ${valueText.isNotEmpty ? valueText : ''}';
  }

  /// Convert to a predicate function for use with the Message Filter pattern
  MessagePredicate toPredicate() {
    return (message) {
      // Extract the field value from the message payload
      final payload = message.payload;
      if (payload is! Map<String, dynamic>) {
        return false;
      }

      // Get the field value (support nested fields with dot notation)
      final fieldParts = field.split('.');
      dynamic fieldValue = payload;
      for (final part in fieldParts) {
        if (fieldValue is! Map<String, dynamic> ||
            !fieldValue.containsKey(part)) {
          return false;
        }
        fieldValue = fieldValue[part];
      }

      // Apply the operator based on value type
      switch (operator) {
        case FilterOperator.equals:
          return _compareEquals(fieldValue, value);
        case FilterOperator.notEquals:
          return !_compareEquals(fieldValue, value);
        case FilterOperator.contains:
          return _compareContains(fieldValue, value);
        case FilterOperator.notContains:
          return !_compareContains(fieldValue, value);
        case FilterOperator.startsWith:
          return _compareStartsWith(fieldValue, value);
        case FilterOperator.endsWith:
          return _compareEndsWith(fieldValue, value);
        case FilterOperator.greaterThan:
          return _compareGreaterThan(fieldValue, value);
        case FilterOperator.lessThan:
          return _compareLessThan(fieldValue, value);
        case FilterOperator.greaterThanOrEquals:
          return _compareGreaterThanOrEquals(fieldValue, value);
        case FilterOperator.lessThanOrEquals:
          return _compareLessThanOrEquals(fieldValue, value);
        case FilterOperator.between:
          return _compareBetween(fieldValue, value, secondaryValue);
        case FilterOperator.isIn:
          return _compareIsIn(fieldValue, value);
        case FilterOperator.notIn:
          return !_compareIsIn(fieldValue, value);
        case FilterOperator.isNull:
          return fieldValue == null;
        case FilterOperator.isNotNull:
          return fieldValue != null;
      }
    };
  }

  /// Compare values for equality
  bool _compareEquals(a, b) {
    if (a == null || b == null) return a == b;

    // Handle special cases
    if (a is DateTime && b is DateTime) {
      return a.isAtSameMomentAs(b);
    } else if (a is num && b is num) {
      return a == b;
    } else if (a is String && b is String) {
      return a.toLowerCase() == b.toLowerCase();
    }

    return a == b;
  }

  /// Check if a value contains another
  bool _compareContains(a, b) {
    if (a == null || b == null) return false;

    if (a is String && b is String) {
      return a.toLowerCase().contains(b.toLowerCase());
    } else if (a is List) {
      return a.contains(b);
    }

    return false;
  }

  /// Check if a string starts with another
  bool _compareStartsWith(a, b) {
    if (a == null || b == null) return false;
    if (a is String && b is String) {
      return a.toLowerCase().startsWith(b.toLowerCase());
    }
    return false;
  }

  /// Check if a string ends with another
  bool _compareEndsWith(a, b) {
    if (a == null || b == null) return false;
    if (a is String && b is String) {
      return a.toLowerCase().endsWith(b.toLowerCase());
    }
    return false;
  }

  /// Compare if a is greater than b
  bool _compareGreaterThan(a, b) {
    if (a == null || b == null) return false;

    if (a is num && b is num) {
      return a > b;
    } else if (a is DateTime && b is DateTime) {
      return a.isAfter(b);
    } else if (a is String && b is String) {
      return a.compareTo(b) > 0;
    }

    return false;
  }

  /// Compare if a is less than b
  bool _compareLessThan(a, b) {
    if (a == null || b == null) return false;

    if (a is num && b is num) {
      return a < b;
    } else if (a is DateTime && b is DateTime) {
      return a.isBefore(b);
    } else if (a is String && b is String) {
      return a.compareTo(b) < 0;
    }

    return false;
  }

  /// Compare if a is greater than or equal to b
  bool _compareGreaterThanOrEquals(a, b) {
    return _compareEquals(a, b) || _compareGreaterThan(a, b);
  }

  /// Compare if a is less than or equal to b
  bool _compareLessThanOrEquals(a, b) {
    return _compareEquals(a, b) || _compareLessThan(a, b);
  }

  /// Compare if a is between b and c
  bool _compareBetween(a, b, c) {
    if (a == null || b == null || c == null) return false;

    if (a is num && b is num && c is num) {
      return a >= b && a <= c;
    } else if (a is DateTime && b is DateTime && c is DateTime) {
      return (a.isAfter(b) || a.isAtSameMomentAs(b)) &&
          (a.isBefore(c) || a.isAtSameMomentAs(c));
    } else if (a is String && b is String && c is String) {
      return a.compareTo(b) >= 0 && a.compareTo(c) <= 0;
    }

    return false;
  }

  /// Check if a value is in a list
  bool _compareIsIn(a, b) {
    if (a == null || b == null) return false;
    if (b is! List) return false;

    return b.contains(a);
  }

  /// Serialize to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field': field,
      'operator': operator.name,
      'valueType': valueType.name,
      'value': _serializeValue(value),
      'secondaryValue': _serializeValue(secondaryValue),
      'isActive': isActive,
      'disclosureLevel': disclosureLevel.name,
    };
  }

  /// Serialize a filter value to JSON
  dynamic _serializeValue(value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    } else if (value is List) {
      return value.map((item) => _serializeValue(item)).toList();
    }

    return value;
  }

  /// Create a filter criterion from JSON
  factory FilterCriteria.fromJson(Map<String, dynamic> json) {
    // Create a helper to deserialize values
    dynamic deserializeValue(value, FilterValueType type) {
      if (value == null) return null;

      switch (type) {
        case FilterValueType.date:
          return value is int
              ? DateTime.fromMillisecondsSinceEpoch(value)
              : null;
        case FilterValueType.number:
          return value is num ? value : num.tryParse(value.toString());
        case FilterValueType.boolean:
          return value is bool
              ? value
              : value.toString().toLowerCase() == 'true';
        default:
          return value;
      }
    }

    // Get the value type
    final valueTypeStr = json['valueType'] as String;
    final valueType = FilterValueType.values.firstWhere(
      (type) => type.name == valueTypeStr,
      orElse: () => FilterValueType.text,
    );

    // Get the operator
    final operatorStr = json['operator'] as String;
    final operator = FilterOperator.values.firstWhere(
      (op) => op.name == operatorStr,
      orElse: () => FilterOperator.equals,
    );

    // Get the value and deserialize it based on type
    final value = deserializeValue(json['value'], valueType);
    final secondaryValue = deserializeValue(json['secondaryValue'], valueType);

    // Get the disclosure level
    final disclosureLevelStr = json['disclosureLevel'] as String?;
    final disclosureLevel = disclosureLevelStr != null
        ? DisclosureLevel.values.firstWhere(
            (level) => level.name == disclosureLevelStr,
            orElse: () => DisclosureLevel.basic,
          )
        : DisclosureLevel.basic;

    return FilterCriteria(
      id: json['id'] as String,
      field: json['field'] as String,
      operator: operator,
      valueType: valueType,
      value: value,
      secondaryValue: secondaryValue,
      isActive: json['isActive'] as bool? ?? true,
      disclosureLevel: disclosureLevel,
    );
  }
}

/// Combines multiple filter criteria with logical operations
///
/// Part of the Shell Architecture UX Component Filter implementation,
/// enabling complex filtering logic with AND/OR operations.
class FilterGroup with ProgressiveDisclosure {
  /// Unique identifier for this filter group
  final String id;

  /// List of filter criteria in this group
  final List<FilterCriteria> criteria;

  /// How the criteria should be combined (AND/OR)
  final FilterGroupLogic logic;

  /// Optional name for saved filter groups
  final String? name;

  /// Optional description for saved filter groups
  final String? description;

  /// The disclosure level at which this group should be visible
  @override
  final DisclosureLevel disclosureLevel;

  /// Constructor
  FilterGroup({
    String? id,
    required this.criteria,
    this.logic = FilterGroupLogic.and,
    this.name,
    this.description,
    this.disclosureLevel = DisclosureLevel.basic,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Create a copy with new properties
  FilterGroup copyWith({
    List<FilterCriteria>? criteria,
    FilterGroupLogic? logic,
    String? name,
    String? description,
    DisclosureLevel? disclosureLevel,
  }) {
    return FilterGroup(
      id: id,
      criteria: criteria ?? this.criteria,
      logic: logic ?? this.logic,
      name: name ?? this.name,
      description: description ?? this.description,
      disclosureLevel: disclosureLevel ?? this.disclosureLevel,
    );
  }

  /// Add a criterion to this group
  FilterGroup addCriterion(FilterCriteria criterion) {
    return copyWith(criteria: [...criteria, criterion]);
  }

  /// Remove a criterion by ID
  FilterGroup removeCriterionById(String criterionId) {
    return copyWith(
      criteria: criteria.where((c) => c.id != criterionId).toList(),
    );
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

  /// Update a criterion by ID
  FilterGroup updateCriterionById(
      String criterionId, FilterCriteria criterion) {
    final index = criteria.indexWhere((c) => c.id == criterionId);
    if (index == -1) return this;

    return updateCriterion(index, criterion);
  }

  /// Toggle the logic between AND/OR
  FilterGroup toggleLogic() {
    return copyWith(
      logic: logic == FilterGroupLogic.and
          ? FilterGroupLogic.or
          : FilterGroupLogic.and,
    );
  }

  /// Check if this filter group has any active criteria
  bool get hasActiveCriteria => criteria.any((criterion) => criterion.isActive);

  /// Get only the active criteria
  List<FilterCriteria> get activeCriteria =>
      criteria.where((criterion) => criterion.isActive).toList();

  /// Convert to a Message Filter predicate
  MessagePredicate toPredicate() {
    // If there are no active criteria, allow all messages
    if (!hasActiveCriteria) {
      return (_) => true;
    }

    // Get predicates for active criteria
    final predicates = activeCriteria.map((c) => c.toPredicate()).toList();

    // Apply the appropriate logic (AND or OR)
    if (logic == FilterGroupLogic.and) {
      return (message) => predicates.every((predicate) => predicate(message));
    } else {
      return (message) => predicates.any((predicate) => predicate(message));
    }
  }

  /// Serialize to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'criteria': criteria.map((c) => c.toJson()).toList(),
      'logic': logic.name,
      'name': name,
      'description': description,
      'disclosureLevel': disclosureLevel.name,
    };
  }

  /// Create a filter group from JSON
  factory FilterGroup.fromJson(Map<String, dynamic> json) {
    final criteriaJson = json['criteria'] as List;
    final criteria = criteriaJson
        .map((c) => FilterCriteria.fromJson(c as Map<String, dynamic>))
        .toList();

    final logicStr = json['logic'] as String;
    final logic = FilterGroupLogic.values.firstWhere(
      (l) => l.name == logicStr,
      orElse: () => FilterGroupLogic.and,
    );

    final disclosureLevelStr = json['disclosureLevel'] as String?;
    final disclosureLevel = disclosureLevelStr != null
        ? DisclosureLevel.values.firstWhere(
            (level) => level.name == disclosureLevelStr,
            orElse: () => DisclosureLevel.basic,
          )
        : DisclosureLevel.basic;

    return FilterGroup(
      id: json['id'] as String,
      criteria: criteria,
      logic: logic,
      name: json['name'] as String?,
      description: json['description'] as String?,
      disclosureLevel: disclosureLevel,
    );
  }
}

/// Logic for combining filter criteria
enum FilterGroupLogic {
  and('Match ALL conditions'),
  or('Match ANY condition');

  /// Human-readable label
  final String label;

  const FilterGroupLogic(this.label);
}

/// A saved filter preset for reuse
class FilterPreset with ProgressiveDisclosure {
  /// Unique identifier for this preset
  final String id;

  /// Display name for this preset
  final String name;

  /// The filter group that defines this preset
  final FilterGroup filterGroup;

  /// Optional description for this preset
  final String? description;

  /// When this preset was created
  final DateTime createdAt;

  /// When this preset was last modified
  final DateTime updatedAt;

  /// Whether this preset is a system preset that can't be deleted
  final bool isSystem;

  /// The disclosure level at which this preset should be visible
  @override
  final DisclosureLevel disclosureLevel;

  /// Constructor
  FilterPreset({
    String? id,
    required this.name,
    required this.filterGroup,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSystem = false,
    this.disclosureLevel = DisclosureLevel.basic,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a copy with new properties
  FilterPreset copyWith({
    String? name,
    FilterGroup? filterGroup,
    String? description,
    bool? isSystem,
    DisclosureLevel? disclosureLevel,
  }) {
    return FilterPreset(
      id: id,
      name: name ?? this.name,
      filterGroup: filterGroup ?? this.filterGroup,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isSystem: isSystem ?? this.isSystem,
      disclosureLevel: disclosureLevel ?? this.disclosureLevel,
    );
  }

  /// Serialize to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filterGroup': filterGroup.toJson(),
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isSystem': isSystem,
      'disclosureLevel': disclosureLevel.name,
    };
  }

  /// Create a filter preset from JSON
  factory FilterPreset.fromJson(Map<String, dynamic> json) {
    final filterGroupJson = json['filterGroup'] as Map<String, dynamic>;
    final filterGroup = FilterGroup.fromJson(filterGroupJson);

    final disclosureLevelStr = json['disclosureLevel'] as String?;
    final disclosureLevel = disclosureLevelStr != null
        ? DisclosureLevel.values.firstWhere(
            (level) => level.name == disclosureLevelStr,
            orElse: () => DisclosureLevel.basic,
          )
        : DisclosureLevel.basic;

    return FilterPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      filterGroup: filterGroup,
      description: json['description'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      isSystem: json['isSystem'] as bool? ?? false,
      disclosureLevel: disclosureLevel,
    );
  }

  /// Convert to a Message Filter predicate
  MessagePredicate toPredicate() => filterGroup.toPredicate();
}
