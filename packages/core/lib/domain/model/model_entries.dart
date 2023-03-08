part of ednet_core;

class ModelEntries implements IModelEntries {
  final Model _model;

  late Map<String, Entities> _entryEntitiesMap;

  ModelEntries(this._model) {
    _entryEntitiesMap = newEntries();
  }

  Map<String, Entities> newEntries() {
    var entries = <String, Entities>{};
    for (var entryConcept in _model.entryConcepts) {
      Entities? entryEntities = Entities<Concept>();

      entryEntities.concept = entryConcept;
      entries[entryConcept.code!] = entryEntities;
    }
    return entries;
  }

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

  @override
  Model get model => _model;

  @override
  Concept? getConcept(String conceptCode) {
    return _model.getConcept(conceptCode);
  }

  @override
  Entities getEntry(String entryConceptCode) =>
      _entryEntitiesMap[entryConceptCode]!;

  @override
  Entity? single(Oid oid) {
    for (Concept entryConcept in _model.entryConcepts) {
      var entity = internalSingle(entryConcept.code!, oid);
      if (entity != null) return entity;
    }
    return null;
  }

  @override
  Entity? internalSingle(String entryConceptCode, Oid oid) {
    Entities entryEntities = getEntry(entryConceptCode);
    return entryEntities.internalSingle(oid);
  }

  @override
  Entities? internalChild(String entryConceptCode, Oid oid) {
    Entities entryEntities = getEntry(entryConceptCode);
    return entryEntities.internalChild(oid);
  }

  @override
  bool get isEmpty {
    for (Concept entryConcept in _model.entryConcepts) {
      Entities entryEntities = getEntry(entryConcept.code!);
      if (!entryEntities.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  void clear() {
    for (var entryConcept in _model.entryConcepts) {
      var entryEntities = getEntry(entryConcept.code!);
      entryEntities.clear();
    }
  }

  @override
  String fromEntryToJson(String entryConceptCode) =>
      jsonEncode(fromEntryToMap(entryConceptCode));

  Map<String, Object> fromEntryToMap(String entryConceptCode) {
    Map<String, Object> entryMap = <String, Object>{};
    entryMap['domain'] = _model.domain.code!;
    entryMap['model'] = _model.code!;
    entryMap['entry'] = entryConceptCode;
    Entities entryEntities = getEntry(entryConceptCode);
    entryMap['entities'] = entryEntities.toJsonList();
    return entryMap;
  }

  @override
  void fromJsonToEntry(String entryJson) {
    var entryMap = jsonDecode(entryJson);
    fromMapToEntry(entryMap);
  }

  void fromMapToEntry(entryMap) {
    var domainCode = entryMap['domain'];
    var modelCode = entryMap['model'];
    var entryConceptCode = entryMap['entry'];
    if (_model.domain.code! != domainCode) {
      throw CodeException('The $domainCode domain does not exist.');
    }
    if (_model.code! != modelCode) {
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

  void populateEntityReferences(Entities entities) {
    for (var entity in entities) {
      for (Parent parent in entity.concept.externalParents) {
        Reference? reference = entity.getReference(parent.code!);
        if (reference != null) {
          //String parentOidString = reference.parentOidString;
          //String parentConceptCode = reference.parentConceptCode;
          //String entryConceptCode = reference.entryConceptCode;
          var parentEntity =
              internalSingle(reference.entryConceptCode, reference.oid);
          if (parentEntity == null) {
            throw ParentException('Parent not found for the reference: '
                '${reference.toString()}');
          }
          if (entity.getParent(parent.code!) == null) {
            entity.setParent(parent.code!, parentEntity);
            //print('parent.opposite.code!: ${parent.opposite.code!}');
            var parentChildEntities =
                parentEntity.getChild(parent.opposite?.code!) as Entities?;
            //print('parentChildEntities.length before add: ${parentChildEntities.length}');
            parentChildEntities?.add(entity);
            //print('parentChildEntities.length after add: ${parentChildEntities.length}');
          }
        }
      }
      for (Child internalChild in entity.concept.internalChildren) {
        var childEntities = entity.getChild(internalChild.code!) as Entities?;
        populateEntityReferences(childEntities!);
      }
    }
  }

  void populateEntryReferencesFromJsonMap(entryMap) {
    //var domainCode = entryMap['domain'];
    //var modelCode = entryMap['model'];
    var entryConceptCode = entryMap['entry'];
    var entryEntities = getEntry(entryConceptCode as String);
    populateEntityReferences(entryEntities);
  }

  @override
  void populateEntryReferences(String entryJson) {
    Map<String, Object> entryMap = jsonDecode(entryJson);
    populateEntryReferencesFromJsonMap(entryMap);
  }

  @override
  String toJson() => jsonEncode(toJsonMap());

  Map<String, Object> toJsonMap() {
    var entriesMap = <String, Object>{};
    for (var entryConcept in _model.entryConcepts) {
      entriesMap[entryConcept.code!] = fromEntryToMap(entryConcept.code!);
    }
    return entriesMap;
  }

  @override
  void fromJson(String entriesJson) {
    var entriesMap = jsonDecode(entriesJson);
    fromJsonMap(entriesMap);
  }

  void fromJsonMap(entriesMap) {
    for (var entryConcept in _model.entryConcepts) {
      var entryMap = entriesMap[entryConcept.code!];
      fromMapToEntry(entryMap);
    }
    populateReferences(entriesMap);
  }

  void populateReferences(entriesMap) {
    for (var entryConcept in _model.entryConcepts) {
      var entryMap = entriesMap[entryConcept.code!];
      populateEntryReferencesFromJsonMap(entryMap);
    }
  }

  void display() {
    for (Concept entryConcept in _model.entryConcepts) {
      Entities entryEntities = getEntry(entryConcept.code!);
      entryEntities.display(title: entryConcept.code!);
    }
  }

  void displayEntryJson(String entryConceptCode) {
    print('==============================================================');
    print(
        '${_model.domain.code!} ${_model.code!} ${entryConceptCode} Data in JSON');
    print('==============================================================');
    print(fromEntryToJson(entryConceptCode));
    print('--------------------------------------------------------------');
    print('');
  }

  void displayJson() {
    print('==============================================================');
    print('${_model.domain.code!} ${_model.code!} Data in JSON');
    print('==============================================================');
    print(toJson());
    print('--------------------------------------------------------------');
    print('');
  }
}
