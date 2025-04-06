part of project_brainstorming;
// Generated code for model entries in lib/gen/project/brainstorming/model_entries.dart

class BrainstormingEntries extends ModelEntries {
  BrainstormingEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("MindMap");
    entries["MindMap"] = MindMaps(concept);

    concept = model.concepts.singleWhereCode("Node");
    entries["Node"] = Nodes(concept);

    concept = model.concepts.singleWhereCode("Edge");
    entries["Edge"] = Edges(concept);

    concept = model.concepts.singleWhereCode("Link");
    entries["Link"] = Links(concept);

    concept = model.concepts.singleWhereCode("Idea");
    entries["Idea"] = Ideas(concept);

    concept = model.concepts.singleWhereCode("Topic");
    entries["Topic"] = Topics(concept);

    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "MindMap") {
      return MindMaps(concept);
    }
    if (concept.code == "Node") {
      return Nodes(concept);
    }
    if (concept.code == "Edge") {
      return Edges(concept);
    }
    if (concept.code == "Link") {
      return Links(concept);
    }
    if (concept.code == "Idea") {
      return Ideas(concept);
    }
    if (concept.code == "Topic") {
      return Topics(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "MindMap") {
      return MindMap(concept);
    }
    if (concept.code == "Node") {
      return Node(concept);
    }
    if (concept.code == "Edge") {
      return Edge(concept);
    }
    if (concept.code == "Link") {
      return Link(concept);
    }
    if (concept.code == "Idea") {
      return Idea(concept);
    }
    if (concept.code == "Topic") {
      return Topic(concept);
    }
    return null;
  }

  MindMaps get mindMaps => getEntry("MindMap") as MindMaps;
}
