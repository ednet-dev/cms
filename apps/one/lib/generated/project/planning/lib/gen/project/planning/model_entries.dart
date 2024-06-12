part of project_planning;
// Generated code for model entries in lib/gen/project/planning/model_entries.dart

class PlanningEntries extends ModelEntries {

  PlanningEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Plan");
    entries["Plan"] = Plans(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Plan") {
      return Plans(concept);
    }
    if (concept.code == "Schedule") {
      return Schedules(concept);
    }
    if (concept.code == "Task") {
      return Tasks(concept);
    }
    if (concept.code == "Resource") {
      return Resources(concept);
    }
    if (concept.code == "Project") {
      return Projects(concept);
    }
    if (concept.code == "Milestone") {
      return Milestones(concept);
    }
    if (concept.code == "Deliverable") {
      return Deliverables(concept);
    }
    if (concept.code == "Dependency") {
      return Dependencies(concept);
    }
    if (concept.code == "Risk") {
      return Risks(concept);
    }
    if (concept.code == "Issue") {
      return Issues(concept);
    }
    if (concept.code == "ChangeRequest") {
      return ChangeRequests(concept);
    }
    if (concept.code == "Document") {
      return Documents(concept);
    }
    if (concept.code == "Review") {
      return Reviews(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Plan") {
      return Plan(concept);
    }
    if (concept.code == "Schedule") {
      return Schedule(concept);
    }
    if (concept.code == "Task") {
      return Task(concept);
    }
    if (concept.code == "Resource") {
      return Resource(concept);
    }
    if (concept.code == "Project") {
      return Project(concept);
    }
    if (concept.code == "Milestone") {
      return Milestone(concept);
    }
    if (concept.code == "Deliverable") {
      return Deliverable(concept);
    }
    if (concept.code == "Dependency") {
      return Dependency(concept);
    }
    if (concept.code == "Risk") {
      return Risk(concept);
    }
    if (concept.code == "Issue") {
      return Issue(concept);
    }
    if (concept.code == "ChangeRequest") {
      return ChangeRequest(concept);
    }
    if (concept.code == "Document") {
      return Document(concept);
    }
    if (concept.code == "Review") {
      return Review(concept);
    }
    return null;
  }
  Plans get plans => getEntry("Plan") as Plans;
}
