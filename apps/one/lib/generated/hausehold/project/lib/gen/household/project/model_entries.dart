part of household_project;
// Generated code for model entries in lib/gen/household/project/model_entries.dart

class ProjectEntries extends ModelEntries {

  ProjectEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Project");
    entries["Project"] = Projects(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Project") {
      return Projects(concept);
    }
    if (concept.code == "Task") {
      return Tasks(concept);
    }
    if (concept.code == "Milestone") {
      return Milestones(concept);
    }
    if (concept.code == "Resource") {
      return Resources(concept);
    }
    if (concept.code == "Role") {
      return Roles(concept);
    }
    if (concept.code == "Team") {
      return Teams(concept);
    }
    if (concept.code == "Skill") {
      return Skills(concept);
    }
    if (concept.code == "Time") {
      return Times(concept);
    }
    if (concept.code == "Budget") {
      return Budgets(concept);
    }
    if (concept.code == "Initiative") {
      return Initiatives(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Project") {
      return Project(concept);
    }
    if (concept.code == "Task") {
      return Task(concept);
    }
    if (concept.code == "Milestone") {
      return Milestone(concept);
    }
    if (concept.code == "Resource") {
      return Resource(concept);
    }
    if (concept.code == "Role") {
      return Role(concept);
    }
    if (concept.code == "Team") {
      return Team(concept);
    }
    if (concept.code == "Skill") {
      return Skill(concept);
    }
    if (concept.code == "Time") {
      return Time(concept);
    }
    if (concept.code == "Budget") {
      return Budget(concept);
    }
    if (concept.code == "Initiative") {
      return Initiative(concept);
    }
    return null;
  }
  Projects get projects => getEntry("Project") as Projects;
}
