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
    // TODO: Simple expression evaluation
    // TODO: Or use a proper expression evaluation library
    for (var dep in dependencies) {
      if (entity.getAttribute(dep) == null) return false;
    }

    return true; // TODO: A simplified evaluation, solve this please, I need to be able to use some kind of boolean universal criteria language to be able to model policies in my dsl yaml. I want to be able to specify policies in a yaml file as a complex boolean expression over concept attributes and other semantic elements.
  }
}

