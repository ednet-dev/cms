part of ednet_core;

const int ENTRY_ENTITIES_COUNT = 2;
const int CHILD_ENTITIES_COUNT = 1;

String genModel(Model model, String library) {
  Domain domain = model.domain;

  return '''
part of $library;

// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/model.dart

class ${model.code}Model extends ${model.code}Entries {

  ${model.code}Model(Model model) : super(model);

  ${model.entryConcepts.map((entryConcept) => '''
  void fromJsonTo${entryConcept.code}Entry() {
    fromJsonToEntry(${domain.codeFirstLetterLower}${model.code}${entryConcept.code}Entry);
  }
  ''').join('\n')}

  void fromJsonToModel() {
    fromJson(${domain.codeFirstLetterLower}${model.code}Model);
  }

  void init() {
    ${model.orderedEntryConcepts.map((entryConcept) => 'init${entryConcept.codePluralFirstLetterUpper}();').join('\n    ')}
  }

  ${model.entryConcepts.map((entryConcept) => '''
  void init${entryConcept.codePluralFirstLetterUpper}() {
${createInitEntryEntitiesRandomly(entryConcept)}
  }
  ''').join('\n')}

  // added after code gen - begin

  // added after code gen - end

}
''';
}

extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
