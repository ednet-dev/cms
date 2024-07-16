part of ednet_core;

abstract class IPolicy {
  String get name;

  String get description;

  PolicyScope? get scope;

  bool evaluate(Entity entity);

  PolicyEvaluationResult evaluateWithDetails(Entity entity);
}

class Policy implements IPolicy {
  @override
  final String name;

  @override
  final String description;

  bool Function(Entity) _evaluationFunction;

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

class PolicyWithDependencies implements IPolicy {
  final String name;
  final String description;
  final String expression;
  final Set<String> dependencies;

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
