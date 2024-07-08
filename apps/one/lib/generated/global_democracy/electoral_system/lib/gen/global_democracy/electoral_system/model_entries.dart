part of global_democracy_electoral_system;
// Generated code for model entries in lib/gen/global_democracy/electoral_system/model_entries.dart

class Electoral_systemEntries extends ModelEntries {

  Electoral_systemEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = <String, Entities>{};
    var concept;
    
        concept = model.concepts.singleWhereCode("Citizen");
    entries["Citizen"] = Citizens(concept);
    

    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("$conceptCode concept does not exist.");
    }

        if (concept.code == "Citizen") {
      return Citizens(concept);
    }
    

    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("$conceptCode concept does not exist.");
    }

        if (concept.code == "Citizen") {
      return Citizen(concept);
    }
    

    return null;
  }

    Citizens get citizens => getEntry("Citizen") as Citizens;
  
}
