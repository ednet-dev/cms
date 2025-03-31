part of ednet_core;

/// Interface defining the contract for model entries in the domain model.
///
/// The [IModelEntries] interface provides functionality for managing and accessing
/// domain entities within a model. It supports:
/// - Retrieving concepts and entries
/// - Finding entities by OID
/// - Managing internal entity relationships
/// - JSON serialization/deserialization
///
/// Example usage:
/// ```dart
/// class DomainModel implements IModelEntries {
///   final Model _model;
///   final Map<String, IEntities> _entries = {};
///
///   DomainModel(this._model);
///
///   @override
///   Model get model => _model;
///
///   @override
///   Concept? getConcept(String conceptCode) {
///     return _model.concepts[conceptCode];
///   }
///
///   @override
///   IEntities getEntry(String entryConceptCode) {
///     return _entries[entryConceptCode]!;
///   }
///
///   // ... implement other methods
/// }
/// ```
abstract class IModelEntries {
  /// Gets the domain model associated with these entries.
  Model get model;

  /// Retrieves a concept by its code.
  ///
  /// [conceptCode] is the unique identifier for the concept.
  /// Returns the [Concept] if found, null otherwise.
  Concept? getConcept(String conceptCode);

  /// Gets the entry entities for a given concept code.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// Returns the collection of entities for that entry concept.
  IEntities getEntry(String entryConceptCode);

  /// Finds a single entity by its OID.
  ///
  /// [oid] is the object identifier of the entity to find.
  /// Returns the entity if found, null otherwise.
  IEntity? single(Oid oid);

  /// Finds a single entity by its OID within a specific entry.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// [oid] is the object identifier of the entity to find.
  /// Returns the entity if found, null otherwise.
  IEntity? internalSingle(String entryConceptCode, Oid oid);

  /// Gets the collection containing an entity with the given OID.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// [oid] is the object identifier of the entity to find.
  /// Returns the collection containing the entity if found, null otherwise.
  IEntities? internalChild(String entryConceptCode, Oid oid);

  /// Whether there are no entries in the model.
  bool get isEmpty;

  /// Removes all entries from the model.
  void clear();

  /// Converts the entries for a specific concept to JSON.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// Returns a JSON string representation of the entries.
  String fromEntryToJson(String entryConceptCode);

  /// Loads entries for a specific concept from JSON.
  ///
  /// [entryJson] is the JSON string containing the entries to load.
  void fromJsonToEntry(String entryJson);

  /// Populates references between entries from JSON.
  ///
  /// [entryJson] is the JSON string containing the reference data.
  void populateEntryReferences(String entryJson);

  /// Converts all entries to JSON.
  ///
  /// Returns a JSON string representation of all entries.
  String toJson();

  /// Loads all entries from JSON.
  ///
  /// [json] is the JSON string containing all entries to load.
  void fromJson(String json);
}
