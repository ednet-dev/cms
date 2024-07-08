part of project_user;
// Generated code for model entries in lib/gen/project/user/model_entries.dart

class UserEntries extends ModelEntries {
  UserEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("User");
    entries["User"] = Users(concept);

    concept = model.concepts.singleWhereCode("Avatar");
    entries["Avatar"] = Avatars(concept);

    concept = model.concepts.singleWhereCode("Profile");
    entries["Profile"] = Profiles(concept);

    concept = model.concepts.singleWhereCode("Bookmarks");
    entries["Bookmarks"] = Bookmarkss(concept);

    concept = model.concepts.singleWhereCode("Note");
    entries["Note"] = Notes(concept);

    concept = model.concepts.singleWhereCode("Comment");
    entries["Comment"] = Comments(concept);

    concept = model.concepts.singleWhereCode("Tag");
    entries["Tag"] = Tags(concept);

    concept = model.concepts.singleWhereCode("Category");
    entries["Category"] = Categories(concept);
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
    if (concept.code == "Avatar") {
      return Avatars(concept);
    }
    if (concept.code == "Profile") {
      return Profiles(concept);
    }
    if (concept.code == "Bookmarks") {
      return Bookmarkss(concept);
    }
    if (concept.code == "Note") {
      return Notes(concept);
    }
    if (concept.code == "Comment") {
      return Comments(concept);
    }
    if (concept.code == "Tag") {
      return Tags(concept);
    }
    if (concept.code == "Category") {
      return Categories(concept);
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
    if (concept.code == "Avatar") {
      return Avatar(concept);
    }
    if (concept.code == "Profile") {
      return Profile(concept);
    }
    if (concept.code == "Bookmarks") {
      return Bookmarks(concept);
    }
    if (concept.code == "Note") {
      return Note(concept);
    }
    if (concept.code == "Comment") {
      return Comment(concept);
    }
    if (concept.code == "Tag") {
      return Tag(concept);
    }
    if (concept.code == "Category") {
      return Category(concept);
    }
    return null;
  }

  Users get users => getEntry("User") as Users;
}
