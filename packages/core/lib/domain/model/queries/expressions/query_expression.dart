// part of ednet_core;
//
// /// Base class for all query expressions in the EDNet query language.
// ///
// /// This abstract class serves as the foundation for a rich, composable
// /// query expression system that allows developers to express complex
// /// filtering, sorting, and traversal operations in a type-safe way.
// ///
// /// The expression system is designed to be:
// /// - Composable: expressions can be combined to form more complex expressions
// /// - Type-safe: expressions validate against concept metadata
// /// - Serializable: expressions can be serialized for storage or transmission
// /// - Extensible: new expression types can be added to enhance capabilities
// abstract class QueryExpression implements model.ValueObject {
//   /// Evaluates this expression against an entity.
//   ///
//   /// [entity] is the entity to evaluate against.
//   /// Returns true if the expression matches the entity, false otherwise.
//   bool evaluate(Entity entity);
//
//   /// Creates a logical AND with another expression.
//   ///
//   /// [other] is the expression to combine with.
//   /// Returns a new expression representing the logical AND.
//   QueryExpression and(QueryExpression other) {
//     return LogicalExpression(this, other, LogicalOperator.and);
//   }
//
//   /// Creates a logical OR with another expression.
//   ///
//   /// [other] is the expression to combine with.
//   /// Returns a new expression representing the logical OR.
//   QueryExpression or(QueryExpression other) {
//     return LogicalExpression(this, other, LogicalOperator.or);
//   }
//
//   /// Creates a logical NOT of this expression.
//   ///
//   /// Returns a new expression representing the logical NOT.
//   QueryExpression not() {
//     return NotExpression(this);
//   }
//
//   /// Converts this expression to JSON.
//   @override
//   Map<String, dynamic> toJson();
//
//   /// Creates an expression from its JSON representation.
//   /// This is implemented by concrete subclasses.
//   static QueryExpression fromJson(Map<String, dynamic> json) {
//     final type = json['type'] as String;
//
//     switch (type) {
//       case 'attribute':
//         return AttributeExpression.fromJson(json);
//       case 'logical':
//         return LogicalExpression.fromJson(json);
//       case 'not':
//         return NotExpression.fromJson(json);
//       case 'relationship':
//         return RelationshipExpression.fromJson(json);
//       case 'constant':
//         return ConstantExpression.fromJson(json);
//       case 'function':
//         return FunctionExpression.fromJson(json);
//       default:
//         throw ArgumentError('Unknown expression type: $type');
//     }
//   }
// }
//
// /// Expression for filtering by attribute values.
// ///
// /// This expression type allows filtering entities based on their attribute
// /// values using various comparison operators.
// ///
// /// Example usage:
// /// ```dart
// /// // Find entities where 'price' is less than 100
// /// final expression = AttributeExpression(
// ///   'price',
// ///   ComparisonOperator.lessThan,
// ///   100
// /// );
// /// ```
// class AttributeExpression extends QueryExpression {
//   /// The code of the attribute to filter by.
//   final String attributeCode;
//
//   /// The comparison operator to use.
//   final ComparisonOperator operator;
//
//   /// The value to compare against.
//   final dynamic value;
//
//   /// Creates a new attribute expression.
//   AttributeExpression(this.attributeCode, this.operator, this.value);
//
//   @override
//   bool evaluate(Entity entity) {
//     final attributeValue = entity.getAttribute(attributeCode);
//
//     switch (operator) {
//       case ComparisonOperator.equals:
//         return attributeValue == value;
//       case ComparisonOperator.notEquals:
//         return attributeValue != value;
//       case ComparisonOperator.greaterThan:
//         if (attributeValue is Comparable && value is Comparable) {
//           return attributeValue.compareTo(value) > 0;
//         }
//         return false;
//       case ComparisonOperator.greaterThanOrEqual:
//         if (attributeValue is Comparable && value is Comparable) {
//           return attributeValue.compareTo(value) >= 0;
//         }
//         return false;
//       case ComparisonOperator.lessThan:
//         if (attributeValue is Comparable && value is Comparable) {
//           return attributeValue.compareTo(value) < 0;
//         }
//         return false;
//       case ComparisonOperator.lessThanOrEqual:
//         if (attributeValue is Comparable && value is Comparable) {
//           return attributeValue.compareTo(value) <= 0;
//         }
//         return false;
//       case ComparisonOperator.contains:
//         if (attributeValue is String && value is String) {
//           return attributeValue.contains(value);
//         }
//         return false;
//       case ComparisonOperator.startsWith:
//         if (attributeValue is String && value is String) {
//           return attributeValue.startsWith(value);
//         }
//         return false;
//       case ComparisonOperator.endsWith:
//         if (attributeValue is String && value is String) {
//           return attributeValue.endsWith(value);
//         }
//         return false;
//       case ComparisonOperator.isNull:
//         return attributeValue == null;
//       case ComparisonOperator.isNotNull:
//         return attributeValue != null;
//       case ComparisonOperator.inList:
//         if (value is List) {
//           return value.contains(attributeValue);
//         }
//         return false;
//       case ComparisonOperator.notInList:
//         if (value is List) {
//           return !value.contains(attributeValue);
//         }
//         return false;
//       case ComparisonOperator.between:
//         if (attributeValue is Comparable && value is List && value.length == 2) {
//           return attributeValue.compareTo(value[0]) >= 0 &&
//                  attributeValue.compareTo(value[1]) <= 0;
//         }
//         return false;
//       default:
//         return false;
//     }
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': 'attribute',
//       'attributeCode': attributeCode,
//       'operator': operator.toString(),
//       'value': value is model.ValueObject ? (value as model.ValueObject).toJson() : value,
//     };
//   }
//
//   static AttributeExpression fromJson(Map<String, dynamic> json) {
//     return AttributeExpression(
//       json['attributeCode'],
//       ComparisonOperator.fromString(json['operator']),
//       json['value'],
//     );
//   }
// }
//
// /// Logical expression combining two expressions with AND or OR.
// ///
// /// This expression type allows creating complex expressions by combining
// /// simpler expressions with logical operators.
// ///
// /// Example usage:
// /// ```dart
// /// final priceExpression = AttributeExpression(
// ///   'price',
// ///   ComparisonOperator.lessThan,
// ///   100
// /// );
// ///
// /// final nameExpression = AttributeExpression(
// ///   'name',
// ///   ComparisonOperator.contains,
// ///   'Laptop'
// /// );
// ///
// /// // Find entities where price < 100 AND name contains 'Laptop'
// /// final combinedExpression = LogicalExpression(
// ///   priceExpression,
// ///   nameExpression,
// ///   LogicalOperator.and
// /// );
// /// ```
// class LogicalExpression extends QueryExpression {
//   /// The left operand expression.
//   final QueryExpression left;
//
//   /// The right operand expression.
//   final QueryExpression right;
//
//   /// The logical operator to use.
//   final LogicalOperator operator;
//
//   /// Creates a new logical expression.
//   LogicalExpression(this.left, this.right, this.operator);
//
//   @override
//   bool evaluate(Entity entity) {
//     switch (operator) {
//       case LogicalOperator.and:
//         return left.evaluate(entity) && right.evaluate(entity);
//       case LogicalOperator.or:
//         return left.evaluate(entity) || right.evaluate(entity);
//       default:
//         return false;
//     }
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': 'logical',
//       'left': left.toJson(),
//       'right': right.toJson(),
//       'operator': operator.toString(),
//     };
//   }
//
//   static LogicalExpression fromJson(Map<String, dynamic> json) {
//     return LogicalExpression(
//       QueryExpression.fromJson(json['left']),
//       QueryExpression.fromJson(json['right']),
//       LogicalOperator.fromString(json['operator']),
//     );
//   }
// }
//
// /// Negation of an expression.
// ///
// /// This expression type negates the result of another expression.
// ///
// /// Example usage:
// /// ```dart
// /// final priceExpression = AttributeExpression(
// ///   'price',
// ///   ComparisonOperator.lessThan,
// ///   100
// /// );
// ///
// /// // Find entities where price is NOT < 100 (i.e., price >= 100)
// /// final notExpression = NotExpression(priceExpression);
// /// ```
// class NotExpression extends QueryExpression {
//   /// The expression to negate.
//   final QueryExpression expression;
//
//   /// Creates a new NOT expression.
//   NotExpression(this.expression);
//
//   @override
//   bool evaluate(Entity entity) {
//     return !expression.evaluate(entity);
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': 'not',
//       'expression': expression.toJson(),
//     };
//   }
//
//   static NotExpression fromJson(Map<String, dynamic> json) {
//     return NotExpression(
//       QueryExpression.fromJson(json['expression']),
//     );
//   }
// }
//
// /// Expression for traversing and filtering by relationships.
// ///
// /// This expression type allows filtering entities based on their relationships
// /// with other entities, supporting parent and child traversal.
// ///
// /// Example usage:
// /// ```dart
// /// // Find tasks where the assigned user's name contains 'John'
// /// final userNameExpression = AttributeExpression(
// ///   'name',
// ///   ComparisonOperator.contains,
// ///   'John'
// /// );
// ///
// /// final expression = RelationshipExpression(
// ///   'assignedUser',
// ///   RelationshipType.parent,
// ///   userNameExpression
// /// );
// /// ```
// class RelationshipExpression extends QueryExpression {
//   /// The code of the relationship to traverse.
//   final String relationshipCode;
//
//   /// The type of relationship (parent or child).
//   final RelationshipType relationshipType;
//
//   /// The expression to apply to the related entity.
//   final QueryExpression expression;
//
//   /// Creates a new relationship expression.
//   RelationshipExpression(
//     this.relationshipCode,
//     this.relationshipType,
//     this.expression
//   );
//
//   @override
//   bool evaluate(Entity entity) {
//     if (relationshipType == RelationshipType.parent) {
//       final parent = entity.getParent(relationshipCode);
//       if (parent is Entity) {
//         return expression.evaluate(parent);
//       }
//       return false;
//     } else if (relationshipType == RelationshipType.child) {
//       final children = entity.getChild(relationshipCode);
//       if (children is Entities) {
//         // For child relationships, we check if ANY child matches
//         return children.any((child) => expression.evaluate(child));
//       }
//       return false;
//     }
//     return false;
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': 'relationship',
//       'relationshipCode': relationshipCode,
//       'relationshipType': relationshipType.toString(),
//       'expression': expression.toJson(),
//     };
//   }
//
//   static RelationshipExpression fromJson(Map<String, dynamic> json) {
//     return RelationshipExpression(
//       json['relationshipCode'],
//       RelationshipType.fromString(json['relationshipType']),
//       QueryExpression.fromJson(json['expression']),
//     );
//   }
// }
//
// /// Constant expression that always evaluates to a fixed value.
// ///
// /// This expression type is useful for creating conditional expressions
// /// or as placeholders in complex expressions.
// ///
// /// Example usage:
// /// ```dart
// /// // Always evaluates to true
// /// final trueExpression = ConstantExpression(true);
// /// ```
// class ConstantExpression extends QueryExpression {
//   /// The constant value of this expression.
//   final bool value;
//
//   /// Creates a new constant expression.
//   ConstantExpression(this.value);
//
//   @override
//   bool evaluate(Entity entity) {
//     return value;
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': 'constant',
//       'value': value,
//     };
//   }
//
//   static ConstantExpression fromJson(Map<String, dynamic> json) {
//     return ConstantExpression(json['value']);
//   }
// }
//
// /// Function-based expression for advanced filtering.
// ///
// /// This expression type allows applying functions to attributes
// /// for more complex filtering operations.
// ///
// /// Example usage:
// /// ```dart
// /// // Find entities where the date attribute is within the current month
// /// final expression = FunctionExpression(
// ///   'currentMonth',
// ///   'createdDate',
// ///   {}
// /// );
// /// ```
// class FunctionExpression extends QueryExpression {
//   /// The name of the function to apply.
//   final String functionName;
//
//   /// The code of the attribute to apply the function to.
//   final String attributeCode;
//
//   /// Parameters for the function.
//   final Map<String, dynamic> parameters;
//
//   /// Creates a new function expression.
//   FunctionExpression(this.functionName, this.attributeCode, this.parameters);
//
//   @override
//   bool evaluate(Entity entity) {
//     final attributeValue = entity.getAttribute(attributeCode);
//
//     switch (functionName) {
//       case 'currentMonth':
//         if (attributeValue is DateTime) {
//           final now = DateTime.now();
//           return attributeValue.year == now.year &&
//                  attributeValue.month == now.month;
//         }
//         return false;
//       case 'lastNDays':
//         if (attributeValue is DateTime && parameters.containsKey('days')) {
//           final days = parameters['days'] as int;
//           final now = DateTime.now();
//           final difference = now.difference(attributeValue).inDays;
//           return difference <= days;
//         }
//         return false;
//       case 'length':
//         if (attributeValue is String && parameters.containsKey('operator') && parameters.containsKey('value')) {
//           final operator = ComparisonOperator.fromString(parameters['operator']);
//           final value = parameters['value'] as int;
//
//           switch (operator) {
//             case ComparisonOperator.equals:
//               return attributeValue.length == value;
//             case ComparisonOperator.notEquals:
//               return attributeValue.length != value;
//             case ComparisonOperator.greaterThan:
//               return attributeValue.length > value;
//             case ComparisonOperator.greaterThanOrEqual:
//               return attributeValue.length >= value;
//             case ComparisonOperator.lessThan:
//               return attributeValue.length < value;
//             case ComparisonOperator.lessThanOrEqual:
//               return attributeValue.length <= value;
//             default:
//               return false;
//           }
//         }
//         return false;
//       default:
//         return false;
//     }
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'type': 'function',
//       'functionName': functionName,
//       'attributeCode': attributeCode,
//       'parameters': parameters,
//     };
//   }
//
//   static FunctionExpression fromJson(Map<String, dynamic> json) {
//     return FunctionExpression(
//       json['functionName'],
//       json['attributeCode'],
//       Map<String, dynamic>.from(json['parameters']),
//     );
//   }
// }
//
// /// Enumeration of comparison operators for attribute expressions.
// enum ComparisonOperator {
//   equals,
//   notEquals,
//   greaterThan,
//   greaterThanOrEqual,
//   lessThan,
//   lessThanOrEqual,
//   contains,
//   startsWith,
//   endsWith,
//   isNull,
//   isNotNull,
//   inList,
//   notInList,
//   between;
//
//   static ComparisonOperator fromString(String value) {
//     return ComparisonOperator.values.firstWhere(
//       (op) => op.toString() == value ||
//               op.toString() == 'ComparisonOperator.$value',
//       orElse: () => throw ArgumentError('Unknown operator: $value'),
//     );
//   }
// }
//
// /// Enumeration of logical operators for logical expressions.
// enum LogicalOperator {
//   and,
//   or;
//
//   static LogicalOperator fromString(String value) {
//     return LogicalOperator.values.firstWhere(
//       (op) => op.toString() == value ||
//               op.toString() == 'LogicalOperator.$value',
//       orElse: () => throw ArgumentError('Unknown operator: $value'),
//     );
//   }
// }
//
// /// Enumeration of relationship types for relationship expressions.
// enum RelationshipType {
//   parent,
//   child;
//
//   static RelationshipType fromString(String value) {
//     return RelationshipType.values.firstWhere(
//       (type) => type.toString() == value ||
//                 type.toString() == 'RelationshipType.$value',
//       orElse: () => throw ArgumentError('Unknown relationship type: $value'),
//     );
//   }
// }