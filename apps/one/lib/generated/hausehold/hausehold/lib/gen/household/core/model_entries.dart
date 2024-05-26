part of household_core;
// Generated code for model entries in lib/gen/household/core/model_entries.dart

class CoreEntries extends ModelEntries {

  CoreEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Household");
    entries["Household"] = Households(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Household") {
      return Households(concept);
    }
    if (concept.code == "Member") {
      return Members(concept);
    }
    if (concept.code == "Budget") {
      return Budgets(concept);
    }
    if (concept.code == "Initiative") {
      return Initiatives(concept);
    }
    if (concept.code == "Project") {
      return Projects(concept);
    }
    if (concept.code == "Bank") {
      return Banks(concept);
    }
    if (concept.code == "Event") {
      return Events(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Household") {
      return Household(concept);
    }
    if (concept.code == "Member") {
      return Member(concept);
    }
    if (concept.code == "Budget") {
      return Budget(concept);
    }
    if (concept.code == "Initiative") {
      return Initiative(concept);
    }
    if (concept.code == "Project") {
      return Project(concept);
    }
    if (concept.code == "Bank") {
      return Bank(concept);
    }
    if (concept.code == "Event") {
      return Event(concept);
    }
    return null;
  }
  Households get households => getEntry("Household") as Households;
}
