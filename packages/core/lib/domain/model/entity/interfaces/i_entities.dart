part of ednet_core;

/// Interface for collections of domain entities.
///
/// The [IEntities] interface defines the contract for collections of domain entities.
/// It provides functionality for:
/// - Managing a collection of entities of type [E]
/// - Validating entities against domain rules
/// - Managing entity relationships and references
/// - Serializing/deserializing entities to/from JSON
/// - Applying domain policies and validations
///
/// The interface extends [Iterable] to allow iteration over the entities.
///
/// Example usage:
/// ```dart
/// class ProductCollection implements IEntities<Product> {
///   final Concept? concept;
///   final IValidationExceptions exceptions;
///   final List<Product> _entities;
///
///   ProductCollection(this.concept)
///       : exceptions = ValidationExceptions(),
///         _entities = [];
///
///   @override
///   Concept? get concept => concept;
///
///   @override
///   IValidationExceptions get exceptions => exceptions;
///
///   @override
///   Iterator<Product> get iterator => _entities.iterator;
///
///   @override
///   bool add(Product entity) {
///     if (isValid(entity)) {
///       _entities.add(entity);
///       return true;
///     }
///     return false;
///   }
///
///   @override
///   bool remove(Product entity) {
///     if (preRemove(entity)) {
///       _entities.remove(entity);
///       return postRemove(entity);
///     }
///     return false;
///   }
/// }
/// ```
abstract class IEntities<E extends IEntity<E>> implements Iterable<E> {
  /// Gets the [Concept] that defines the metadata for this collection.
  Concept? get concept;

  /// Gets the validation exceptions for this collection.
  IValidationExceptions get exceptions;

  /// Gets the source collection if this is a derived collection.
  IEntities<E>? get source;

  /// Returns the first entity that has the given attribute value.
  E firstWhereAttribute(String code, Object attribute);

  /// Returns a random entity from the collection.
  E random();

  /// Returns the entity with the given [oid], or null if not found.
  E? singleWhereOid(Oid oid);

  /// Returns the entity with the given [oid] from this collection or its internal children.
  IEntity? internalSingle(Oid oid);

  /// Returns the entity with the given [code], or null if not found.
  E? singleWhereCode(String code);

  /// Returns the entity with the given [id], or null if not found.
  E? singleWhereId(Id id);

  /// Returns the entity with the given attribute value.
  E? singleWhereAttributeId(String code, Object attribute);

  /// Creates a shallow copy of this collection.
  IEntities<E> copy();

  /// Orders the entities using the given [compare] function.
  /// If [compare] is not provided, uses the entity's [compareTo] method.
  IEntities<E> order([int Function(E a, E b) compare]);

  /// Returns entities that satisfy the predicate [f].
  IEntities<E> selectWhere(bool Function(E entity) f);

  /// Returns entities that have the given attribute value.
  IEntities<E> selectWhereAttribute(String code, Object attribute);

  /// Returns entities that have the given parent.
  IEntities<E> selectWhereParent(String code, IEntity parent);

  /// Returns all entities except the first [n].
  IEntities<E> skipFirst(int n);

  /// Returns all entities after the first one that doesn't satisfy [f].
  IEntities<E> skipFirstWhile(bool Function(E entity) f);

  /// Returns the first [n] entities.
  IEntities<E> takeFirst(int n);

  /// Returns all entities up to but not including the first one that doesn't satisfy [f].
  IEntities<E> takeFirstWhile(bool Function(E entity) f);

  /// Returns the collection containing the entity with the given [oid].
  IEntities? internalChild(Oid oid);

  /// Removes all entities from the collection.
  void clear();

  /// Sorts the entities using the given [compare] function.
  /// If [compare] is not provided, uses the entity's [compareTo] method.
  void sort([int Function(E a, E b) compare]);

  /// Validates an entity before adding it to the collection.
  bool isValid(E entity);

  /// Adds an entity to the collection if it passes validation.
  bool add(E entity);

  /// Validates an entity after adding it to the collection.
  bool postAdd(E entity);

  /// Validates an entity before removing it from the collection.
  bool preRemove(E entity);

  /// Removes an entity from the collection if it passes validation.
  bool remove(E entity);

  /// Validates an entity after removing it from the collection.
  bool postRemove(E entity);

  /// Converts the collection to a JSON string.
  String toJson();

  /// Loads entities from a JSON string.
  void fromJson(String entitiesJson);

  /// Integrates entities from another collection.
  void integrate(IEntities<E> fromEntities);

  /// Integrates entities to add from another collection.
  void integrateAdd(IEntities<E> addEntities);

  /// Integrates entities to set from another collection.
  void integrateSet(IEntities<E> setEntities);

  /// Integrates entities to remove from another collection.
  void integrateRemove(IEntities<E> removeEntities);

  /// Converts the collection to a graph structure.
  Map<String, dynamic> toGraph();
}
//
// extension IEntitiesExtension<E extends IEntity<E>> on IEntities<E> {
//   Map<String, dynamic> toGraph() {
//     return {
//       'type': runtimeType.toString(),
//       'entities': _entityList.map((entity) => entity.toGraph()).toList(),
//     };
//   }
// }
