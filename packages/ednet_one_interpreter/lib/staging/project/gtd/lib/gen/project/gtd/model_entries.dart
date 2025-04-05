part of project_gtd;
// Generated code for model entries in lib/gen/project/gtd/model_entries.dart

class GtdEntries extends ModelEntries {

  GtdEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Inbox");
    entries["Inbox"] = Inboxes(concept);
    concept = model.concepts.singleWhereCode("ClarifiedItem");
    entries["ClarifiedItem"] = ClarifiedItems(concept);
    concept = model.concepts.singleWhereCode("Task");
    entries["Task"] = Tasks(concept);
    concept = model.concepts.singleWhereCode("Project");
    entries["Project"] = Projects(concept);
    concept = model.concepts.singleWhereCode("Calendar");
    entries["Calendar"] = Calendars(concept);
    concept = model.concepts.singleWhereCode("ContextList");
    entries["ContextList"] = ContextLists(concept);
    concept = model.concepts.singleWhereCode("Review");
    entries["Review"] = Reviews(concept);
    concept = model.concepts.singleWhereCode("NextAction");
    entries["NextAction"] = NextActions(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Inbox") {
      return Inboxes(concept);
    }
    if (concept.code == "ClarifiedItem") {
      return ClarifiedItems(concept);
    }
    if (concept.code == "Task") {
      return Tasks(concept);
    }
    if (concept.code == "Project") {
      return Projects(concept);
    }
    if (concept.code == "Calendar") {
      return Calendars(concept);
    }
    if (concept.code == "ContextList") {
      return ContextLists(concept);
    }
    if (concept.code == "Review") {
      return Reviews(concept);
    }
    if (concept.code == "NextAction") {
      return NextActions(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Inbox") {
      return Inbox(concept);
    }
    if (concept.code == "ClarifiedItem") {
      return ClarifiedItem(concept);
    }
    if (concept.code == "Task") {
      return Task(concept);
    }
    if (concept.code == "Project") {
      return Project(concept);
    }
    if (concept.code == "Calendar") {
      return Calendar(concept);
    }
    if (concept.code == "ContextList") {
      return ContextList(concept);
    }
    if (concept.code == "Review") {
      return Review(concept);
    }
    if (concept.code == "NextAction") {
      return NextAction(concept);
    }
    return null;
  }
  Inboxes get inboxes => getEntry("Inbox") as Inboxes;
  ClarifiedItems get clarifiedItems => getEntry("ClarifiedItem") as ClarifiedItems;
  Tasks get tasks => getEntry("Task") as Tasks;
  Projects get projects => getEntry("Project") as Projects;
  Calendars get calendars => getEntry("Calendar") as Calendars;
  ContextLists get contextLists => getEntry("ContextList") as ContextLists;
  Reviews get reviews => getEntry("Review") as Reviews;
  NextActions get nextActions => getEntry("NextAction") as NextActions;
}
