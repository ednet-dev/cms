part of ednet_core;

/// Interface for domain entities.
///
/// The [IEntity] interface defines the contract for domain entities in the system.
/// An entity represents a domain object with:
/// - A unique identifier (OID)
/// - A business identifier (ID)
/// - A code for human-readable identification
/// - Attributes and relationships (parents and children)
/// - Validation rules and exceptions
///
/// The interface extends [Comparable] to allow entities to be ordered.
///
/// Example usage:
/// ```dart
/// class Product implements IEntity<Product> {
///   final Concept concept;
///   final Oid oid;
///   final IId? id;
///   final String? code;
///   final IValidationExceptions exceptions;
///
///   Product(this.concept)
///       : oid = Oid(),
///         exceptions = ValidationExceptions();
///
///   @override
///   Concept get concept => concept;
///
///   @override
///   IValidationExceptions get exceptions => exceptions;
///
///   @override
///   Oid get oid => oid;
///
///   @override
///   IId? get id => id;
///
///   @override
///   String? get code => code;
///
///   @override
///   K? getAttribute<K>(String attributeCode) {
///     // Implement attribute retrieval
///     return null;
///   }
///
///   @override
///   bool setAttribute(String name, Object value) {
///     // Implement attribute setting
///     return true;
///   }
///
///   @override
///   Product copy() {
///     // Implement copying
///     return Product(concept);
///   }
///
///   @override
///   int compareTo(Object other) {
///     // Implement comparison
///     return 0;
///   }
/// }
/// ```
abstract class IEntity<E extends IEntity<E>> implements Comparable {
  /// Gets the [Concept] that defines the metadata for this entity.
  Concept get concept;

  /// Gets the validation exceptions for this entity.
  IValidationExceptions get exceptions;

  /// Gets the object identifier (OID) for this entity.
  Oid get oid;

  /// Gets the business identifier (ID) for this entity.
  IId? get id;

  /// Gets the human-readable code for this entity.
  String? get code;

  /// Timestamp when the entity was added to its collection.
  DateTime? whenAdded;

  /// Timestamp when the entity's attributes were last set.
  DateTime? whenSet;

  /// Timestamp when the entity was removed from its collection.
  DateTime? whenRemoved;

  /// Gets the value of the attribute with the given [attributeCode].
  /// Returns null if the attribute doesn't exist or has no value.
  K? getAttribute<K>(String attributeCode);

  /// Validates and prepares to set an attribute value.
  /// Returns true if the pre-validation passes.
  bool preSetAttribute(String name, Object value);

  /// Sets the value of the attribute with the given [name].
  /// Returns true if the operation was successful.
  bool setAttribute(String name, Object value);

  /// Validates the attribute value after setting.
  /// Returns true if the post-validation passes.
  bool postSetAttribute(String name, Object value);

  /// Gets the string value of the attribute with the given [name].
  /// Returns null if the attribute doesn't exist or has no value.
  String? getStringFromAttribute(String name);

  /// Gets the string value of the attribute with the given [name].
  /// Returns null if the attribute doesn't exist or has no value.
  String? getStringOrNullFromAttribute(String name);

  /// Sets the string value of the attribute with the given [name].
  /// Returns true if the operation was successful.
  bool setStringToAttribute(String name, String string);

  /// Gets the parent entity with the given [name].
  /// Returns null if the parent doesn't exist.
  Object? getParent(String name);

  /// Sets the parent entity with the given [name].
  /// Returns true if the operation was successful.
  bool setParent(String name, entity);

  /// Removes the parent entity with the given [name].
  removeParent(String name);

  /// Gets the child entities with the given [name].
  /// Returns null if the child doesn't exist.
  Object? getChild(String name);

  /// Sets the child entities with the given [name].
  /// Returns true if the operation was successful.
  bool setChild(String name, Object entities);

  /// Creates a deep copy of this entity.
  E copy();

  /// Converts this entity to a JSON string.
  String toJson();

  /// Loads this entity from a JSON string.
  void fromJson<K extends Entity<K>>(String entityJson);

  /// Converts this entity to a graph structure.
  Map<String, dynamic> toGraph();
}

// extension IEntityExtension<E extends IEntity<E>> on IEntity<E> {
//   Map<String, dynamic> toGraph() {
//     return {
//       'code': code,
//       'oid': oid.toString(),
//       'type': runtimeType.toString(),
//       'attributes': _attributeMap,
//       'references': _referenceMap,
//       'parents': _parentMap.map((k, v) => MapEntry(k, v.toGraph())),
//       'children': _childMap.map((k, v) => MapEntry(k, v.toGraph())),
//     };
//   }
// }
