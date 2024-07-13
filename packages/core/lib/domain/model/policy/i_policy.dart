part of ednet_core;

abstract class IPolicy {
  String get name;

  String get description;

  bool evaluate(Entity entity);
}

class Policy implements IPolicy {
  final String name;
  final String description;
  final String expression;
  final Set<String> dependencies;

  Policy(this.name, this.description, this.expression, this.dependencies);

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
}