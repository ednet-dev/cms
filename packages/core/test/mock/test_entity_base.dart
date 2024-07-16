import 'package:ednet_core/ednet_core.dart';

abstract class TestEntityBase extends Entity<TestEntity> {
  TestEntityBase(Concept concept) {
    this.concept = concept;
  }

  String get name => getAttribute('name');

  void set name(String a) => setAttribute('name', a);

  String get description => getAttribute('description');

  void set description(String a) => setAttribute('description', a);

  TestEntity newEntity() => TestEntity(concept);

  ConcreteEntities newEntities() => ConcreteEntities(concept);
}

abstract class TestEntitiesBase extends Entities<TestEntity> {
  TestEntitiesBase(Concept concept) {
    this.concept = concept;
  }

  ConcreteEntities newEntities() => ConcreteEntities(concept);

  TestEntity newEntity() => TestEntity(concept);
}

class TestEntity extends TestEntityBase {
  TestEntity(super.concept);
}

class ConcreteEntities extends TestEntitiesBase {
  ConcreteEntities(super.concept);
}
