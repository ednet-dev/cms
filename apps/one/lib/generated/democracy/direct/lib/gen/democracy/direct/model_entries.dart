part of democracy_direct;
// Generated code for model entries in lib/gen/democracy/direct/model_entries.dart

class DirectEntries extends ModelEntries {

  DirectEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = <String, Entities>{};
    var concept;
    
        concept = model.concepts.singleWhereCode("Citizen");
    entries["Citizen"] = Citizens(concept);
    
    concept = model.concepts.singleWhereCode("Election");
    entries["Election"] = Elections(concept);
    

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
    
    if (concept.code == "Proposal") {
      return Proposals(concept);
    }
    
    if (concept.code == "Vote") {
      return Votes(concept);
    }
    
    if (concept.code == "Comment") {
      return Comments(concept);
    }
    
    if (concept.code == "Election") {
      return Elections(concept);
    }
    
    if (concept.code == "Message") {
      return Messages(concept);
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
    
    if (concept.code == "Proposal") {
      return Proposal(concept);
    }
    
    if (concept.code == "Vote") {
      return Vote(concept);
    }
    
    if (concept.code == "Comment") {
      return Comment(concept);
    }
    
    if (concept.code == "Election") {
      return Election(concept);
    }
    
    if (concept.code == "Message") {
      return Message(concept);
    }
    

    return null;
  }

    Citizens get citizens => getEntry("Citizen") as Citizens;
  
  Elections get elections => getEntry("Election") as Elections;
  
}
