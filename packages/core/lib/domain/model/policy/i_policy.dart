part of ednet_core;

abstract class IPolicy {
  String get name;

  String get description;

  bool evaluate(Entity entity);
}

class Policy implements IPolicy {
  final String name;
  final String description;
  final bool Function(Entity entity) _evaluate;

  Policy(this.name, this.description, this._evaluate);

  @override
  bool evaluate(Entity entity) => _evaluate(entity);
}
