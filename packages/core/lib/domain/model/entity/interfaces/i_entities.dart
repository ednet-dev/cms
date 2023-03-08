part of ednet_core;

// http://dartlangfr.net/dart-cheat-sheet/
abstract class IEntities<E extends IEntity<E>> implements Iterable<E> {
  Concept? get concept;

  IValidationExceptions get exceptions;

  IEntities<E>? get source;

  E firstWhereAttribute(String code, Object attribute);

  E random();

  E? singleWhereOid(Oid oid);

  IEntity? internalSingle(Oid oid);

  E? singleWhereCode(String code);

  E? singleWhereId(Id id);

  E? singleWhereAttributeId(String code, Object attribute);

  IEntities<E> copy();

  IEntities<E> order(
      [int Function(E a, E b) compare]); // sort, but not in place
  IEntities<E> selectWhere(bool Function(E entity) f);

  IEntities<E> selectWhereAttribute(String code, Object attribute);

  IEntities<E> selectWhereParent(String code, IEntity parent);

  IEntities<E> skipFirst(int n);

  IEntities<E> skipFirstWhile(bool Function(E entity) f);

  IEntities<E> takeFirst(int n);

  IEntities<E> takeFirstWhile(bool Function(E entity) f);

  IEntities? internalChild(Oid oid);

  void clear();

  void sort([int Function(E a, E b) compare]); // in place sort
  bool isValid(E entity);

  bool add(E entity);

  bool postAdd(E entity);

  bool preRemove(E entity);

  bool remove(E entity);

  bool postRemove(E entity);

  String toJson();

  void fromJson(String entitiesJson);

  void integrate(IEntities<E> fromEntities);

  void integrateAdd(IEntities<E> addEntities);

  void integrateSet(IEntities<E> setEntities);

  void integrateRemove(IEntities<E> removeEntities);
}
