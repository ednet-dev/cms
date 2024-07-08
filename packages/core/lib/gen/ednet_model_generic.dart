part of ednet_core;

/// Generates Dart code for model entries.
String genEntries(Model model, String library) {
  Domain domain = model.domain;

  return '''
part of $library;
// Generated code for model entries in lib/gen/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/model_entries.dart

class ${model.code}Entries extends ModelEntries {

  ${model.code}Entries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = <String, Entities>{};
    var concept;
    
    ${model.entryConcepts.map((entryConcept) => '''
    concept = model.concepts.singleWhereCode("${entryConcept.code}");
    entries["${entryConcept.code}"] = ${entryConcept.codes}(concept);
    ''').join('\n')}

    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("\$conceptCode concept does not exist.");
    }

    ${model.concepts.map((concept) => '''
    if (concept.code == "${concept.code}") {
      return ${concept.codes}(concept);
    }
    ''').join('\n')}

    return null;
  }

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("\$conceptCode concept does not exist.");
    }

    ${model.concepts.map((concept) => '''
    if (concept.code == "${concept.code}") {
      return ${concept.code}(concept);
    }
    ''').join('\n')}

    return null;
  }

  ${model.entryConcepts.map((entryConcept) => '''
  ${entryConcept.codes} get ${entryConcept.codesFirstLetterLower} => getEntry("${entryConcept.code}") as ${entryConcept.codes};
  ''').join('\n')}
}
''';
}
