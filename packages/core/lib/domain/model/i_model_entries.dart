part of ednet_core;

abstract class IModelEntries {
  Model get model;

  Concept? getConcept(String conceptCode);

  IEntities getEntry(String entryConceptCode);

  IEntity? single(Oid oid);

  IEntity? internalSingle(String entryConceptCode, Oid oid);

  IEntities? internalChild(String entryConceptCode, Oid oid);

  bool get isEmpty;

  void clear();

  String fromEntryToJson(String entryConceptCode);

  void fromJsonToEntry(String entryJson);

  void populateEntryReferences(String entryJson);

  String toJson();

  void fromJson(String json);
}