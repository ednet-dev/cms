part of project_core;
// Generated code for model entries in lib/gen/project/core/model_entries.dart

class CoreEntries extends ModelEntries {
  CoreEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Task");
    entries["Task"] = Tasks(concept);
    concept = model.concepts.singleWhereCode("Project");
    entries["Project"] = Projects(concept);
    concept = model.concepts.singleWhereCode("Milestone");
    entries["Milestone"] = Milestones(concept);
    concept = model.concepts.singleWhereCode("Resource");
    entries["Resource"] = Resources(concept);
    concept = model.concepts.singleWhereCode("Role");
    entries["Role"] = Roles(concept);
    concept = model.concepts.singleWhereCode("Team");
    entries["Team"] = Teams(concept);
    concept = model.concepts.singleWhereCode("Skill");
    entries["Skill"] = Skills(concept);
    concept = model.concepts.singleWhereCode("Time");
    entries["Time"] = Times(concept);
    concept = model.concepts.singleWhereCode("Budget");
    entries["Budget"] = Budgets(concept);
    concept = model.concepts.singleWhereCode("Initiative");
    entries["Initiative"] = Initiatives(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Task") {
      return Tasks(concept);
    }
    if (concept.code == "Project") {
      return Projects(concept);
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
    if (concept.code == "Task") {
      return Task(concept);
    }
    if (concept.code == "Project") {
      return Project(concept);
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

  Tasks get tasks => getEntry("Task") as Tasks;

  Projects get projects => getEntry("Project") as Projects;

  Milestones get milestones => getEntry("Milestone") as Milestones;

  Resources get resources => getEntry("Resource") as Resources;

  Roles get roles => getEntry("Role") as Roles;

  Teams get teams => getEntry("Team") as Teams;

  Skills get skills => getEntry("Skill") as Skills;

  Times get times => getEntry("Time") as Times;

  Budgets get budgets => getEntry("Budget") as Budgets;

  Initiatives get initiatives => getEntry("Initiative") as Initiatives;
}
