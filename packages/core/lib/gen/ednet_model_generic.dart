part of ednet_core;

/// Generates Dart code for model entries.
String genEntries(Model model, String library) {
  Domain domain = model.domain;

  // Start of the generated code.
  String sc = '''
part of $library;
// Generated code for model entries in lib/gen/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/model_entries.dart

class ${model.code}Entries extends ModelEntries {

  ${model.code}Entries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
''';

  // Loop through each entry concept to generate entries.
  for (Concept entryConcept in model.entryConcepts) {
    sc += '''
    concept = model.concepts.singleWhereCode("${entryConcept.code}");
    entries["${entryConcept.code}"] = ${entryConcept.codes}(concept);
''';
  }

  sc += '''
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("\${conceptCode} concept does not exist.");
    }
''';

  // Loop through each concept to match and return the correct entities.
  for (Concept concept in model.concepts) {
    sc += '''
    if (concept.code == "${concept.code}") {
      return ${concept.codes}(concept);
    }
''';
  }

  sc += '''
    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("\${conceptCode} concept does not exist.");
    }
''';

  // Loop through each concept to match and return the correct entity.
  for (Concept concept in model.concepts) {
    sc += '''
    if (concept.code == "${concept.code}") {
      return ${concept.code}(concept);
    }
''';
  }

  sc += '''
    return null;
  }
''';

  // Getter for each entry concept.
  for (Concept entryConcept in model.entryConcepts) {
    sc += '''
  ${entryConcept.codes} get ${entryConcept.codesFirstLetterLower} => getEntry("${entryConcept.code}") as ${entryConcept.codes};
''';
  }

  // End of the generated code.
  sc += '''
}
''';

  return sc;
}
