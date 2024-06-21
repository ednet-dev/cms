part of ednet_core_types;

// lib/gen/ednet_core/types/types.dart

abstract class TypeGen extends Entity<CoreType> {
  TypeGen(Concept concept) {
    this.concept = concept;
  }

  TypeGen.withId(Concept concept, int sequence) {
    this.concept = concept;
    setAttribute('sequence', sequence);
  }

  int get sequence => getAttribute('sequence');

  set sequence(int a) => setAttribute('sequence', a);

  String get title => getAttribute('title');

  set title(String a) => setAttribute('title', a);

  String get email => getAttribute('email');

  set email(String a) => setAttribute('email', a);

  DateTime get started => getAttribute('started');

  set started(DateTime a) => setAttribute('started', a);

  double get price => getAttribute('price');

  set price(double a) => setAttribute('price', a);

  num get qty => getAttribute('qty');

  set qty(num a) => setAttribute('qty', a);

  bool get completed => getAttribute('completed');

  set completed(bool a) => setAttribute('completed', a);

  dynamic get whatever => getAttribute('whatever');

  set whatever(a) => setAttribute('whatever', a);

  Uri get web => getAttribute('web');

  set web(Uri a) => setAttribute('web', a);

  dynamic get other => getAttribute('other');

  set other(a) => setAttribute('other', a);

  String get note => getAttribute('note');

  set note(String a) => setAttribute('note', a);

  @override
  CoreType newEntity() => CoreType(concept);

  @override
  CoreTypes newEntities() => CoreTypes(concept);

  int sequenceCompareTo(CoreType other) {
    return sequence.compareTo(other.sequence);
  }
}

abstract class TypesGen extends Entities<CoreType> {
  TypesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  CoreTypes newEntities() => CoreTypes(concept);

  @override
  CoreType newEntity() => CoreType(concept);
}
