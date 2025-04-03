part of ednet_core;

/// Filter criteria for repository queries.
///
/// This class represents a set of criteria for filtering entities
/// in repository queries, with support for sorting.
///
/// Type parameters:
/// - [T]: The entity type these criteria apply to
class FilterCriteria<T extends Entity<T>> {
  /// The list of criteria.
  final List<Criterion> criteria = [];

  /// The attribute to sort by.
  String? sortAttribute;

  /// Whether to sort in ascending order.
  bool sortAscending = true;

  /// Creates a new filter criteria.
  FilterCriteria();

  /// Adds a criterion to these criteria.
  ///
  /// Parameters:
  /// - [criterion]: The criterion to add
  void addCriterion(Criterion criterion) {
    criteria.add(criterion);
  }

  /// Sets the attribute to sort by.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to sort by
  /// - [ascending]: Whether to sort in ascending order
  void orderBy(String attribute, {bool ascending = true}) {
    sortAttribute = attribute;
    sortAscending = ascending;
  }

  /// Checks if these criteria are empty.
  ///
  /// Returns:
  /// True if there are no criteria, false otherwise
  bool get isEmpty => criteria.isEmpty;

  /// Checks if these criteria are not empty.
  ///
  /// Returns:
  /// True if there are criteria, false otherwise
  bool get isNotEmpty => criteria.isNotEmpty;

  /// Gets the number of criteria.
  ///
  /// Returns:
  /// The number of criteria
  int get length => criteria.length;
}

/// A single criterion for filtering entities.
///
/// This class represents a criterion that compares an attribute
/// of an entity to a value.
class Criterion {
  /// The attribute to compare.
  final String attribute;

  /// The value to compare to.
  final dynamic value;

  /// The comparison operator.
  final ComparisonOperator operator;

  /// Creates a new criterion.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  /// - [operator]: The comparison operator
  Criterion(
    this.attribute,
    this.value, {
    this.operator = ComparisonOperator.equals,
  });

  /// Creates a criterion with the equals operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the equals operator
  factory Criterion.equals(String attribute, dynamic value) {
    return Criterion(attribute, value, operator: ComparisonOperator.equals);
  }

  /// Creates a criterion with the not equals operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the not equals operator
  factory Criterion.notEquals(String attribute, dynamic value) {
    return Criterion(attribute, value, operator: ComparisonOperator.notEquals);
  }

  /// Creates a criterion with the greater than operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the greater than operator
  factory Criterion.greaterThan(String attribute, dynamic value) {
    return Criterion(
      attribute,
      value,
      operator: ComparisonOperator.greaterThan,
    );
  }

  /// Creates a criterion with the greater than or equals operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the greater than or equals operator
  factory Criterion.greaterThanOrEquals(String attribute, dynamic value) {
    return Criterion(
      attribute,
      value,
      operator: ComparisonOperator.greaterThanOrEquals,
    );
  }

  /// Creates a criterion with the less than operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the less than operator
  factory Criterion.lessThan(String attribute, dynamic value) {
    return Criterion(attribute, value, operator: ComparisonOperator.lessThan);
  }

  /// Creates a criterion with the less than or equals operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the less than or equals operator
  factory Criterion.lessThanOrEquals(String attribute, dynamic value) {
    return Criterion(
      attribute,
      value,
      operator: ComparisonOperator.lessThanOrEquals,
    );
  }

  /// Creates a criterion with the contains operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the contains operator
  factory Criterion.contains(String attribute, String value) {
    return Criterion(attribute, value, operator: ComparisonOperator.contains);
  }

  /// Creates a criterion with the starts with operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the starts with operator
  factory Criterion.startsWith(String attribute, String value) {
    return Criterion(attribute, value, operator: ComparisonOperator.startsWith);
  }

  /// Creates a criterion with the ends with operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [value]: The value to compare to
  ///
  /// Returns:
  /// A new criterion with the ends with operator
  factory Criterion.endsWith(String attribute, String value) {
    return Criterion(attribute, value, operator: ComparisonOperator.endsWith);
  }

  /// Creates a criterion with the in operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [values]: The values to compare to
  ///
  /// Returns:
  /// A new criterion with the in operator
  factory Criterion.in_(String attribute, List<dynamic> values) {
    return Criterion(attribute, values, operator: ComparisonOperator.in_);
  }

  /// Creates a criterion with the not in operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to compare
  /// - [values]: The values to compare to
  ///
  /// Returns:
  /// A new criterion with the not in operator
  factory Criterion.notIn(String attribute, List<dynamic> values) {
    return Criterion(attribute, values, operator: ComparisonOperator.notIn);
  }

  /// Creates a criterion with the is null operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to check
  ///
  /// Returns:
  /// A new criterion with the is null operator
  factory Criterion.isNull(String attribute) {
    return Criterion(attribute, null, operator: ComparisonOperator.isNull);
  }

  /// Creates a criterion with the is not null operator.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to check
  ///
  /// Returns:
  /// A new criterion with the is not null operator
  factory Criterion.isNotNull(String attribute) {
    return Criterion(attribute, null, operator: ComparisonOperator.isNotNull);
  }
}

/// Comparison operators for filter criteria.
enum ComparisonOperator {
  /// Equal to.
  equals,

  /// Not equal to.
  notEquals,

  /// Greater than.
  greaterThan,

  /// Greater than or equal to.
  greaterThanOrEquals,

  /// Less than.
  lessThan,

  /// Less than or equal to.
  lessThanOrEquals,

  /// Contains (for strings).
  contains,

  /// Starts with (for strings).
  startsWith,

  /// Ends with (for strings).
  endsWith,

  /// In a list of values.
  in_,

  /// Not in a list of values.
  notIn,

  /// Is null.
  isNull,

  /// Is not null.
  isNotNull,
}
