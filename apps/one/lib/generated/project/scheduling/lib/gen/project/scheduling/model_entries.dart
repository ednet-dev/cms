part of project_scheduling;
// Generated code for model entries in lib/gen/project/scheduling/model_entries.dart

class SchedulingEntries extends ModelEntries {

  SchedulingEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("InitiationPhase");
    entries["InitiationPhase"] = InitiationPhases(concept);
    concept = model.concepts.singleWhereCode("PlanningPhase");
    entries["PlanningPhase"] = PlanningPhases(concept);
    concept = model.concepts.singleWhereCode("ExecutionPhase");
    entries["ExecutionPhase"] = ExecutionPhases(concept);
    concept = model.concepts.singleWhereCode("MonitoringAndControllingPhase");
    entries["MonitoringAndControllingPhase"] = MonitoringAndControllingPhases(concept);
    concept = model.concepts.singleWhereCode("ClosingPhase");
    entries["ClosingPhase"] = ClosingPhases(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "InitiationPhase") {
      return InitiationPhases(concept);
    }
    if (concept.code == "PlanningPhase") {
      return PlanningPhases(concept);
    }
    if (concept.code == "ExecutionPhase") {
      return ExecutionPhases(concept);
    }
    if (concept.code == "MonitoringAndControllingPhase") {
      return MonitoringAndControllingPhases(concept);
    }
    if (concept.code == "ClosingPhase") {
      return ClosingPhases(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "InitiationPhase") {
      return InitiationPhase(concept);
    }
    if (concept.code == "PlanningPhase") {
      return PlanningPhase(concept);
    }
    if (concept.code == "ExecutionPhase") {
      return ExecutionPhase(concept);
    }
    if (concept.code == "MonitoringAndControllingPhase") {
      return MonitoringAndControllingPhase(concept);
    }
    if (concept.code == "ClosingPhase") {
      return ClosingPhase(concept);
    }
    return null;
  }
  InitiationPhases get initiationPhases => getEntry("InitiationPhase") as InitiationPhases;
  PlanningPhases get planningPhases => getEntry("PlanningPhase") as PlanningPhases;
  ExecutionPhases get executionPhases => getEntry("ExecutionPhase") as ExecutionPhases;
  MonitoringAndControllingPhases get monitoringAndControllingPhases => getEntry("MonitoringAndControllingPhase") as MonitoringAndControllingPhases;
  ClosingPhases get closingPhases => getEntry("ClosingPhase") as ClosingPhases;
}
