part of communication_chat;
// Generated code for model entries in lib/gen/communication/chat/model_entries.dart

class ChatEntries extends ModelEntries {

  ChatEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("User");
    entries["User"] = Users(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Message") {
      return Messages(concept);
    }
    if (concept.code == "User") {
      return Users(concept);
    }
    if (concept.code == "ApiKey") {
      return ApiKeies(concept);
    }
    if (concept.code == "Chat") {
      return Chats(concept);
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
    if (concept.code == "Message") {
      return Message(concept);
    }
    if (concept.code == "User") {
      return User(concept);
    }
    if (concept.code == "ApiKey") {
      return ApiKey(concept);
    }
    if (concept.code == "Chat") {
      return Chat(concept);
    }
    if (concept.code == "Category") {
      return Category(concept);
    }
    return null;
  }
  Users get users => getEntry("User") as Users;
}
