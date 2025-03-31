part of ednet_core;

/// Interface for domain policies that define business rules and constraints.
///
/// The [IPolicy] interface defines the contract for domain policies that can be
/// evaluated against domain entities. A policy represents a business rule or
/// constraint that must be satisfied by entities in the domain model.
///
/// Example usage:
/// ```dart
/// class PricePolicy implements IPolicy {
///   @override
///   String get name => 'PricePolicy';
///
///   @override
///   String get description => 'Product price must be positive';
///
///   @override
///   PolicyScope? get scope => PolicyScope.entity;
///
///   @override
///   bool evaluate(Entity entity) {
///     final price = entity.getAttribute('price') as double?;
///     return price != null && price > 0;
///   }
///
///   @override
///   PolicyEvaluationResult evaluateWithDetails(Entity entity) {
///     final result = evaluate(entity);
///     return PolicyEvaluationResult(
///       result,
///       result ? [] : [PolicyViolation(name, description)],
///     );
///   }
/// }
/// ```
abstract class IPolicy {
  /// Gets the unique name of this policy.
  String get name;

  /// Gets a human-readable description of what this policy enforces.
  String get description;

  /// Gets the scope at which this policy should be evaluated.
  /// If null, the policy can be evaluated at any scope.
  PolicyScope? get scope;

  /// Evaluates this policy against the given entity.
  ///
  /// [entity] is the entity to evaluate.
  /// Returns true if the policy is satisfied, false otherwise.
  bool evaluate(Entity entity);

  /// Evaluates this policy against the given entity and returns detailed results.
  ///
  /// [entity] is the entity to evaluate.
  /// Returns a [PolicyEvaluationResult] containing the evaluation result and any violations.
  PolicyEvaluationResult evaluateWithDetails(Entity entity);
}

/// A concrete implementation of [IPolicy] that uses a function for evaluation.
///
/// The [Policy] class provides a simple way to create policies by providing
/// a function that evaluates an entity.
///
/// Example usage:
/// ```dart
/// final pricePolicy = Policy(
///   'PricePolicy',
///   'Product price must be positive',
///   (entity) {
///     final price = entity.getAttribute('price') as double?;
///     return price != null && price > 0;
///   },
///   scope: PolicyScope.entity,
/// );
/// ```
class Policy implements IPolicy {
  @override
  final String name;

  @override
  final String description;

  /// The function that evaluates the policy.
  bool Function(Entity) _evaluationFunction;

  /// Creates a new [Policy] instance.
  ///
  /// [name] is the unique name of the policy.
  /// [description] is a human-readable description of what the policy enforces.
  /// [_evaluationFunction] is the function that evaluates the policy.
  /// [scope] is the scope at which the policy should be evaluated.
  Policy(this.name, this.description, this._evaluationFunction, {this.scope});

  @override
  bool evaluate(Entity entity) {
    return _evaluationFunction(entity);
  }

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    bool result = evaluate(entity);
    return PolicyEvaluationResult(
        result,
        result
            ? []
            : [
                PolicyViolation(
                  name,
                  description,
                )
              ]);
  }

  @override
  PolicyScope? scope;
}

/// A concrete implementation of [IPolicy] that uses an expression for evaluation.
///
/// The [PolicyWithDependencies] class allows policies to be defined using
/// expressions that reference entity attributes. It automatically handles
/// dependency tracking and evaluation.
///
/// Example usage:
/// ```dart
/// final pricePolicy = PolicyWithDependencies(
///   'PricePolicy',
///   'Product price must be positive',
///   'price > 0',
///   {'price'},
///   scope: PolicyScope.entity,
/// );
/// ```
class PolicyWithDependencies implements IPolicy {
  final String name;
  final String description;
  final String expression;
  final Set<String> dependencies;

  /// Creates a new [PolicyWithDependencies] instance.
  ///
  /// [name] is the unique name of the policy.
  /// [description] is a human-readable description of what the policy enforces.
  /// [expression] is the expression to evaluate.
  /// [dependencies] is the set of attribute names that the expression depends on.
  /// [scope] is the scope at which the policy should be evaluated.
  PolicyWithDependencies(
      this.name, this.description, this.expression, this.dependencies,
      {this.scope});

  @override
  bool evaluate(Entity entity) {
    final evaluator = ExpressionEvaluator();
    final exp = Expression.parse(expression);

    final context = <String, dynamic>{};
    for (var dep in dependencies) {
      context[dep] = entity.getAttribute(dep);
    }

    try {
      return evaluator.eval(exp, context) as bool;
    } catch (e) {
      print('Error evaluating policy $name: $e');
      return false;
    }
  }

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    bool result = evaluate(entity);
    return PolicyEvaluationResult(
        result,
        result
            ? []
            : [
                PolicyViolation(
                  name,
                  'Evaluation failed',
                )
              ]);
  }

  @override
  PolicyScope? scope;
}
