part of ednet_core;

/// Generates Dart code for model entries.
String genEntries(Model model, String library) {
  Domain domain = model.domain;

  return '''
part of '../../../$library.dart';
// Generated code for model entries in lib/gen/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/model_entries.dart

class ${model.code}Entries extends ModelEntries {

  ${model.code}Entries(super.model);

  /// Creates a map of new entries for each concept in the model.
  @override
  Map<String, Entities> newEntries() {
    final entries = <String, Entities>{};    
    
    ${model.entryConcepts.isEmpty ? '' : model.entryConcepts.map((entryConcept) => '''
    final ${entryConcept.codesFirstLetterLower}Concept = model.concepts.singleWhereCode(\'${entryConcept.code}\');
    entries[\'${entryConcept.code}\'] = ${entryConcept.codePlural}(${entryConcept.codesFirstLetterLower}Concept!);
    ''').where((item) => item.trim().length > 0).join('\n')}

    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  @override
  Entities? newEntities(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('\$conceptCode concept does not exist.');
    }

    ${model.concepts.isEmpty ? '' : model.concepts.map((concept) => '''
    if (concept.code == '${concept.code}') {
      return ${concept.codes}(concept);
    }
    ''').where((item) => item.trim().length > 0).join('\n')}

    return null;
  }

  /// Returns a new entity for the given concept code.
  @override
  Entity? newEntity(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('\$conceptCode concept does not exist.');
    }

    ${model.concepts.isEmpty ? '' : model.concepts.map((concept) => '''
    if (concept.code == '${concept.code}') {
      return ${concept.code}(concept);
    }
    ''').where((item) => item.trim().length > 0).join('\n')}

    return null;
  }

  ${model.entryConcepts.isEmpty ? '' : model.entryConcepts.map((entryConcept) => '''
  ${entryConcept.codes} get ${entryConcept.codesFirstLetterLower} => getEntry('${entryConcept.code}') as ${entryConcept.codes};
  ''').where((item) => item.trim().length > 0).join('\n')}
}
''';
}
