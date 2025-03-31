part of ednet_core;

/// A concrete implementation of [IModelEntries] that manages domain model entries.
///
/// The [ModelEntries] class provides functionality for managing entities within a domain model,
/// including:
/// - Creating and managing entry entities
/// - Finding entities by OID
/// - Managing internal entity relationships
/// - JSON serialization/deserialization
/// - Reference population and management
///
/// Example usage:
/// ```dart
/// final model = Model(domain, 'MyModel');
/// final entries = ModelEntries(model);
///
/// // Create a new entity
/// final entity = entries.newEntity('Product');
///
/// // Get entry entities
/// final products = entries.getEntry('Product');
///
/// // Find an entity by OID
/// final found = entries.single(Oid.ts(1234567890));
/// ```
class ModelEntries implements IModelEntries {
  /// The domain model associated with these entries.
  final Model _model;

  /// Maps entry concept codes to their corresponding entity collections.
  late Map<String, Entities> _entryEntitiesMap;

  /// Creates a new [ModelEntries] instance.
  ///
  /// [model] is the domain model to associate with these entries.
  /// Initializes the entry entities map with empty collections for each entry concept.
  ModelEntries(this._model) {
    _entryEntitiesMap = newEntries();
  }

  /// Creates a new map of entry entities for each entry concept in the model.
  ///
  /// Returns a map where each key is an entry concept code and each value is
  /// an empty [Entities] collection for that concept.
  Map<String, Entities> newEntries() {
    var entries = <String, Entities>{};
    for (var entryConcept in _model.entryConcepts) {
      Entities? entryEntities = Entities<Concept>();

      entryEntities.concept = entryConcept;
      entries[entryConcept.code] = entryEntities;
    }
    return entries;
  }

  /// Creates a new [Entities] collection for a given concept.
  ///
  /// [conceptCode] is the code identifying the concept.
  /// Returns a new [Entities] collection if the concept exists and is not an entry concept.
  /// Throws [ConceptException] if the concept does not exist.
  Entities? newEntities(String conceptCode) {
    var concept = getConcept(conceptCode);

    if (concept == null) {
      throw new ConceptException('${conceptCode} concept does not exist.');
    }

    if (!concept.entry) {
      var entities = Entities<Concept>();
      entities.concept = concept;
      return entities;
    }
    return null;
  }

  /// Creates a new entity instance for a given concept.
  ///
  /// [conceptCode] is the code identifying the concept.
  /// Returns a new [Entity] instance if the concept exists.
  /// Throws [ConceptException] if the concept does not exist.
  Entity? newEntity(String conceptCode) {
    var concept = getConcept(conceptCode);

    if (concept == null) {
      throw ConceptException(
          'Concept with code does not exist: ' + conceptCode);
    }

    var conceptEntity = Entity<Concept>();
    conceptEntity.concept = concept;
    return conceptEntity;
  }

  /// Gets the domain model associated with these entries.
  @override
  Model get model => _model;

  /// Retrieves a concept by its code.
  ///
  /// [conceptCode] is the unique identifier for the concept.
  /// Returns the [Concept] if found, null otherwise.
  @override
  Concept? getConcept(String conceptCode) {
    return _model.getConcept(conceptCode);
  }

  /// Gets the entry entities for a given concept code.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// Returns the collection of entities for that entry concept.
  /// Throws [ConceptException] if the entry concept does not exist.
  @override
  Entities getEntry(String entryConceptCode) {
    if (!_entryEntitiesMap.containsKey(entryConceptCode)) {
      throw ConceptException(
          'Entry concept with code does not exist: ' + entryConceptCode);
    }
    return _entryEntitiesMap[entryConceptCode]!;
  }

  /// Finds a single entity by its OID across all entry concepts.
  ///
  /// [oid] is the object identifier of the entity to find.
  /// Returns the entity if found, null otherwise.
  @override
  Entity? single(Oid oid) {
    for (Concept entryConcept in _model.entryConcepts) {
      var entity = internalSingle(entryConcept.code, oid);
      if (entity != null) return entity;
    }
    return null;
  }

  /// Finds a single entity by its OID within a specific entry.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// [oid] is the object identifier of the entity to find.
  /// Returns the entity if found, null otherwise.
  @override
  Entity? internalSingle(String entryConceptCode, Oid oid) {
    Entities entryEntities = getEntry(entryConceptCode);
    return entryEntities.internalSingle(oid);
  }

  /// Gets the collection containing an entity with the given OID.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// [oid] is the object identifier of the entity to find.
  /// Returns the collection containing the entity if found, null otherwise.
  @override
  Entities? internalChild(String entryConceptCode, Oid oid) {
    Entities entryEntities = getEntry(entryConceptCode);
    return entryEntities.internalChild(oid);
  }

  /// Whether there are no entries in the model.
  ///
  /// Returns true if all entry collections are empty.
  @override
  bool get isEmpty {
    for (Concept entryConcept in _model.entryConcepts) {
      Entities entryEntities = getEntry(entryConcept.code);
      if (!entryEntities.isEmpty) {
        return false;
      }
    }
    return true;
  }

  /// Removes all entries from the model.
  ///
  /// Clears all entity collections for each entry concept.
  @override
  void clear() {
    for (var entryConcept in _model.entryConcepts) {
      var entryEntities = getEntry(entryConcept.code);
      entryEntities.clear();
    }
  }

  /// Converts the entries for a specific concept to JSON.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// Returns a JSON string representation of the entries.
  @override
  String fromEntryToJson(String entryConceptCode) =>
      jsonEncode(fromEntryToMap(entryConceptCode));

  /// Converts the entries for a specific concept to a map.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  /// Returns a map containing the domain, model, entry, and entities data.
  Map<String, Object> fromEntryToMap(String entryConceptCode) {
    Map<String, Object> entryMap = <String, Object>{};
    entryMap['domain'] = _model.domain.code;
    entryMap['model'] = _model.code;
    entryMap['entry'] = entryConceptCode;
    Entities entryEntities = getEntry(entryConceptCode);
    entryMap['entities'] = entryEntities.toJsonList();
    return entryMap;
  }

  /// Loads entries for a specific concept from JSON.
  ///
  /// [entryJson] is the JSON string containing the entries to load.
  @override
  void fromJsonToEntry(String entryJson) {
    var entryMap = jsonDecode(entryJson);
    fromMapToEntry(entryMap);
  }

  /// Loads entries for a specific concept from a map.
  ///
  /// [entryMap] is the map containing the entry data.
  /// Throws [CodeException] if the domain or model codes don't match.
  /// Throws [ConceptException] if the entry concept doesn't exist.
  /// Throws [JsonException] if the target entry collection is not empty.
  void fromMapToEntry(entryMap) {
    var domainCode = entryMap['domain'];
    var modelCode = entryMap['model'];
    var entryConceptCode = entryMap['entry'];
    if (_model.domain.code != domainCode) {
      throw CodeException('The $domainCode domain does not exist.');
    }
    if (_model.code != modelCode) {
      throw CodeException('The $modelCode model does not exist.');
    }
    var entryConcept = getConcept(entryConceptCode as String);
    if (entryConcept == null) {
      throw ConceptException('${entryConceptCode} concept does not exist.');
    }
    Entities entryEntities = getEntry(entryConceptCode);
    if (entryEntities.isNotEmpty) {
      throw JsonException(
          '$entryConceptCode entry receiving entities are not empty');
    }
    var entitiesList = entryMap['entities'];
    entryEntities.fromJsonList(entitiesList);
  }

  /// Populates entity references for a collection of entities.
  ///
  /// [entities] is the collection of entities to process.
  /// Throws [ParentException] if a referenced parent entity is not found.
  void populateEntityReferences(Entities entities) {
    for (var entity in entities) {
      for (Parent parent in entity.concept.externalParents) {
        Reference? reference = entity.getReference(parent.code);
        if (reference != null) {
          var parentEntity =
              internalSingle(reference.entryConceptCode, reference.oid);
          if (parentEntity == null) {
            throw ParentException('Parent not found for the reference: '
                '${reference.toString()}');
          }
          if (entity.getParent(parent.code) == null) {
            entity.setParent(parent.code, parentEntity);
            var parentChildEntities =
                parentEntity.getChild(parent.opposite?.code) as Entities?;
            parentChildEntities?.add(entity);
          }
        }
      }
      for (Child internalChild in entity.concept.internalChildren) {
        var childEntities = entity.getChild(internalChild.code) as Entities?;
        populateEntityReferences(childEntities!);
      }
    }
  }

  /// Populates entry references from a JSON map.
  ///
  /// [entryMap] is the map containing the entry data.
  void populateEntryReferencesFromJsonMap(entryMap) {
    var entryConceptCode = entryMap['entry'];
    var entryEntities = getEntry(entryConceptCode as String);
    populateEntityReferences(entryEntities);
  }

  /// Populates references between entries from JSON.
  ///
  /// [entryJson] is the JSON string containing the reference data.
  @override
  void populateEntryReferences(String entryJson) {
    Map<String, Object> entryMap = jsonDecode(entryJson);
    populateEntryReferencesFromJsonMap(entryMap);
  }

  /// Converts all entries to JSON.
  ///
  /// Returns a JSON string representation of all entries.
  @override
  String toJson() => jsonEncode(toJsonMap());

  /// Converts all entries to a map.
  ///
  /// Returns a map containing all entry data.
  Map<String, Object> toJsonMap() {
    var entriesMap = <String, Object>{};
    for (var entryConcept in _model.entryConcepts) {
      entriesMap[entryConcept.code] = fromEntryToMap(entryConcept.code);
    }
    return entriesMap;
  }

  /// Loads all entries from JSON.
  ///
  /// [entriesJson] is the JSON string containing all entries to load.
  @override
  void fromJson(String entriesJson) {
    var entriesMap = jsonDecode(entriesJson);
    fromJsonMap(entriesMap);
  }

  /// Loads all entries from a map.
  ///
  /// [entriesMap] is the map containing all entry data.
  void fromJsonMap(entriesMap) {
    for (var entryConcept in _model.entryConcepts) {
      var entryMap = entriesMap[entryConcept.code];
      fromMapToEntry(entryMap);
    }
    populateReferences(entriesMap);
  }

  /// Populates references between entries from a map.
  ///
  /// [entriesMap] is the map containing all entry data.
  void populateReferences(entriesMap) {
    for (var entryConcept in _model.entryConcepts) {
      var entryMap = entriesMap[entryConcept.code];
      populateEntryReferencesFromJsonMap(entryMap);
    }
  }

  /// Displays all entries in a formatted way.
  void display() {
    for (Concept entryConcept in _model.entryConcepts) {
      Entities entryEntities = getEntry(entryConcept.code);
      entryEntities.display(title: entryConcept.code);
    }
  }

  /// Displays the JSON representation of entries for a specific concept.
  ///
  /// [entryConceptCode] is the code identifying the entry concept.
  void displayEntryJson(String entryConceptCode) {
    print('==============================================================');
    print(
        '${_model.domain.code} ${_model.code} ${entryConceptCode} Data in JSON');
    print('==============================================================');
    print(fromEntryToJson(entryConceptCode));
    print('--------------------------------------------------------------');
    print('');
  }

  /// Displays the JSON representation of all entries.
  void displayJson() {
    print('==============================================================');
    print('${_model.domain.code} ${_model.code} Data in JSON');
    print('==============================================================');
    print(toJson());
    print('--------------------------------------------------------------');
    print('');
  }
}
