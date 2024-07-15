import 'package:ednet_core/ednet_core.dart';

abstract class ConcreteEntityGen extends Entity<ConcreteEntity> {
  ConcreteEntityGen(Concept concept) {
    this.concept = concept;
  }

  String get name => getAttribute('name');

  void set name(String a) => setAttribute('name', a);

  String get description => getAttribute('description');

  void set description(String a) => setAttribute('description', a);

  ConcreteEntity newEntity() => ConcreteEntity(concept);

  ConcreteEntities newEntities() => ConcreteEntities(concept);
}

abstract class ConcreteEntitiesGen extends Entities<ConcreteEntity> {
  ConcreteEntitiesGen(Concept concept) {
    this.concept = concept;
  }

  ConcreteEntities newEntities() => ConcreteEntities(concept);

  ConcreteEntity newEntity() => ConcreteEntity(concept);
}

class ConcreteEntity extends ConcreteEntityGen {
  ConcreteEntity(super.concept);
}

class ConcreteEntities extends ConcreteEntitiesGen {
  ConcreteEntities(super.concept);
}
