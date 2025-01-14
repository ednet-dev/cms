part of project_kanban;
// Generated code for model entries in lib/gen/project/kanban/model_entries.dart

class KanbanEntries extends ModelEntries {
  KanbanEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Library");
    entries["Library"] = Libraries(concept);

    concept = model.concepts.singleWhereCode("Item");
    entries["Item"] = Items(concept);

    concept = model.concepts.singleWhereCode("Author");
    entries["Author"] = Authors(concept);

    concept = model.concepts.singleWhereCode("Publisher");
    entries["Publisher"] = Publishers(concept);

    concept = model.concepts.singleWhereCode("Genre");
    entries["Genre"] = Genres(concept);

    concept = model.concepts.singleWhereCode("Series");
    entries["Series"] = Seriess(concept);

    concept = model.concepts.singleWhereCode("Location");
    entries["Location"] = Locations(concept);

    concept = model.concepts.singleWhereCode("Book");
    entries["Book"] = Books(concept);

    concept = model.concepts.singleWhereCode("Magazine");
    entries["Magazine"] = Magazines(concept);

    concept = model.concepts.singleWhereCode("Newspaper");
    entries["Newspaper"] = Newspapers(concept);

    concept = model.concepts.singleWhereCode("AudioBook");
    entries["AudioBook"] = AudioBooks(concept);

    concept = model.concepts.singleWhereCode("eBook");
    entries["eBook"] = eBooks(concept);

    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Library") {
      return Libraries(concept);
    }
    if (concept.code == "Item") {
      return Items(concept);
    }
    if (concept.code == "Author") {
      return Authors(concept);
    }
    if (concept.code == "Publisher") {
      return Publishers(concept);
    }
    if (concept.code == "Genre") {
      return Genres(concept);
    }
    if (concept.code == "Series") {
      return Seriess(concept);
    }
    if (concept.code == "Location") {
      return Locations(concept);
    }
    if (concept.code == "Book") {
      return Books(concept);
    }
    if (concept.code == "Magazine") {
      return Magazines(concept);
    }
    if (concept.code == "Newspaper") {
      return Newspapers(concept);
    }
    if (concept.code == "AudioBook") {
      return AudioBooks(concept);
    }
    if (concept.code == "eBook") {
      return eBooks(concept);
    }
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
    }
    if (concept.code == "Library") {
      return Library(concept);
    }
    if (concept.code == "Item") {
      return Item(concept);
    }
    if (concept.code == "Author") {
      return Author(concept);
    }
    if (concept.code == "Publisher") {
      return Publisher(concept);
    }
    if (concept.code == "Genre") {
      return Genre(concept);
    }
    if (concept.code == "Series") {
      return Series(concept);
    }
    if (concept.code == "Location") {
      return Location(concept);
    }
    if (concept.code == "Book") {
      return Book(concept);
    }
    if (concept.code == "Magazine") {
      return Magazine(concept);
    }
    if (concept.code == "Newspaper") {
      return Newspaper(concept);
    }
    if (concept.code == "AudioBook") {
      return AudioBook(concept);
    }
    if (concept.code == "eBook") {
      return eBook(concept);
    }
    return null;
  }

  Libraries get libraries => getEntry("Library") as Libraries;
}
