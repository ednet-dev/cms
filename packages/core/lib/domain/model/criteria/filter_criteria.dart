// part of ednet_core;
//
// /// Represents a filter criterion for querying domain entities.
// ///
// /// The [FilterCriteria] class provides a structured way to define filtering
// /// conditions for repositories and queries. It supports:
// /// - Attribute filtering based on comparison operators
// /// - Type-safe value comparisons
// /// - Extensible operator set
// /// - Integration with the repository and query system
// ///
// /// This class implements [model.ValueObject] for serialization compatibility
// /// and forms a foundation for the application layer's more sophisticated
// /// criteria system.
// ///
// /// Example usage:
// /// ```dart
// /// final criteria = FilterCriteria(
// ///   attribute: 'price',
// ///   operator: FilterOperator.lessThan,
// ///   value: 100.0,
// /// );
// ///
// /// repository.findByCriteria(criteria);
// /// ```
// class FilterCriteria implements model.ValueObject {
//   /// The attribute name to filter on.
//   final String attribute;
//
//   /// The comparison operator to use.
//   final String operator;
//
//   /// The value to compare against.
//   final dynamic value;
//
//   /// Creates a new filter criterion.
//   ///
//   /// [attribute] is the name of the attribute to filter on.
//   /// [operator] is the comparison operator to use.
//   /// [value] is the value to compare against.
//   FilterCriteria({
//     required this.attribute,
//     required this.operator,
//     required this.value,
//   });
//
//   /// Converts this filter criterion to a JSON representation.
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'attribute': attribute,
//       'operator': operator,
//       'value': value is model.ValueObject ? (value as model.ValueObject).toJson() : value,
//     };
//   }
//
//   /// Creates a filter criterion from its JSON representation.
//   static FilterCriteria fromJson(Map<String, dynamic> json) {
//     return FilterCriteria(
//       attribute: json['attribute'],
//       operator: json['operator'],
//       value: json['value'],
//     );
//   }
//
//   /// Applies this filter criterion to a collection of entities.
//   ///
//   /// This method filters a collection based on this criterion.
//   ///
//   /// [entities] is the collection to filter.
//   /// Returns a filtered collection of entities.
//   Iterable<Entity> apply(Iterable<Entity> entities) {
//     switch (operator) {
//       case FilterOperator.equals:
//         return entities.where((e) => e.getAttribute(attribute) == value);
//       case FilterOperator.notEquals:
//         return entities.where((e) => e.getAttribute(attribute) != value);
//       case FilterOperator.greaterThan:
//         return entities.where((e) {
//           var attrValue = e.getAttribute(attribute);
//           if (attrValue is Comparable && value is Comparable) {
//             return attrValue.compareTo(value) > 0;
//           }
//           return false;
//         });
//       case FilterOperator.lessThan:
//         return entities.where((e) {
//           var attrValue = e.getAttribute(attribute);
//           if (attrValue is Comparable && value is Comparable) {
//             return attrValue.compareTo(value) < 0;
//           }
//           return false;
//         });
//       case FilterOperator.contains:
//         return entities.where((e) {
//           var attrValue = e.getAttribute(attribute);
//           if (attrValue is String && value is String) {
//             return attrValue.contains(value);
//           }
//           return false;
//         });
//       default:
//         throw ArgumentError('Unsupported operator: $operator');
//     }
//   }
// }
//
// /// Defines standard filter operators for [FilterCriteria].
// ///
// /// This class provides constants for commonly used filter operators
// /// to ensure consistency across the framework.
// class FilterOperator {
//   /// Equals comparison (==)
//   static const String equals = 'equals';
//
//   /// Not equals comparison (!=)
//   static const String notEquals = 'notEquals';
//
//   /// Greater than comparison (>)
//   static const String greaterThan = 'greaterThan';
//
//   /// Less than comparison (<)
//   static const String lessThan = 'lessThan';
//
//   /// Contains comparison (String.contains)
//   static const String contains = 'contains';
//
//   /// Starts with comparison (String.startsWith)
//   static const String startsWith = 'startsWith';
//
//   /// Ends with comparison (String.endsWith)
//   static const String endsWith = 'endsWith';
// }
//
// /// Combines multiple [FilterCriteria] into a composite filter.
// ///
// /// The [CompositeCriteria] class allows combining multiple criteria
// /// using logical operators (AND, OR) to create complex filtering conditions.
// ///
// /// Example usage:
// /// ```dart
// /// final priceCriteria = FilterCriteria(
// ///   attribute: 'price',
// ///   operator: FilterOperator.lessThan,
// ///   value: 100.0,
// /// );
// ///
// /// final categoryCriteria = FilterCriteria(
// ///   attribute: 'category',
// ///   operator: FilterOperator.equals,
// ///   value: 'electronics',
// /// );
// ///
// /// final criteria = CompositeCriteria(
// ///   criteria: [priceCriteria, categoryCriteria],
// ///   operator: LogicalOperator.and,
// /// );
// /// ```
// class CompositeCriteria implements model.ValueObject {
//   /// The list of criteria to combine.
//   final List<FilterCriteria> criteria;
//
//   /// The logical operator to use for combining criteria.
//   final String operator;
//
//   /// Creates a new composite criteria.
//   ///
//   /// [criteria] is the list of criteria to combine.
//   /// [operator] is the logical operator to use.
//   CompositeCriteria({
//     required this.criteria,
//     required this.operator,
//   });
//
//   /// Converts this composite criteria to a JSON representation.
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'criteria': criteria.map((c) => c.toJson()).toList(),
//       'operator': operator,
//     };
//   }
//
//   /// Creates a composite criteria from its JSON representation.
//   static CompositeCriteria fromJson(Map<String, dynamic> json) {
//     return CompositeCriteria(
//       criteria: (json['criteria'] as List)
//           .map((c) => FilterCriteria.fromJson(c))
//           .toList(),
//       operator: json['operator'],
//     );
//   }
//
//   /// Applies this composite criteria to a collection of entities.
//   ///
//   /// This method filters a collection based on all criteria combined
//   /// using the specified logical operator.
//   ///
//   /// [entities] is the collection to filter.
//   /// Returns a filtered collection of entities.
//   Iterable<Entity> apply(Iterable<Entity> entities) {
//     if (criteria.isEmpty) {
//       return entities;
//     }
//
//     // Apply the first criterion
//     var result = criteria.first.apply(entities);
//
//     // Apply the rest of the criteria
//     for (var i = 1; i < criteria.length; i++) {
//       var nextResult = criteria[i].apply(entities);
//
//       if (operator == LogicalOperator.and) {
//         // Intersection
//         result = result.where((e) => nextResult.contains(e));
//       } else if (operator == LogicalOperator.or) {
//         // Union
//         result = {...result, ...nextResult};
//       }
//     }
//
//     return result;
//   }
// }
//
// /// Defines standard logical operators for [CompositeCriteria].
// ///
// /// This class provides constants for logical operators used to
// /// combine multiple filter criteria.
// class LogicalOperator {
//   /// Logical AND (&&)
//   static const String and = 'and';
//
//   /// Logical OR (||)
//   static const String or = 'or';
// }
