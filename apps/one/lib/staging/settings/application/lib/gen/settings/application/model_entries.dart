part of settings_application;
// Generated code for model entries in lib/gen/settings/application/model_entries.dart

class ApplicationEntries extends ModelEntries {
  ApplicationEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;

    concept = model.concepts.singleWhereCode("User");
    entries["User"] = Users(concept);

    concept = model.concepts.singleWhereCode("Role");
    entries["Role"] = Roles(concept);

    concept = model.concepts.singleWhereCode("Status");
    entries["Status"] = Statuss(concept);

    concept = model.concepts.singleWhereCode("Theme");
    entries["Theme"] = Themes(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "User") {
      return Users(concept);
    }
    if (concept.code == "Role") {
      return Roles(concept);
    }
    if (concept.code == "Status") {
      return Statuss(concept);
    }
    if (concept.code == "Theme") {
      return Themes(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "User") {
      return User(concept);
    }
    if (concept.code == "Role") {
      return Role(concept);
    }
    if (concept.code == "Status") {
      return Status(concept);
    }
    if (concept.code == "Theme") {
      return Theme(concept);
    }
    return null;
  }
}
