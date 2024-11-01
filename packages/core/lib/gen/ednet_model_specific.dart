part of ednet_core;

const int ENTRY_ENTITIES_COUNT = 2;
const int CHILD_ENTITIES_COUNT = 1;

String genModel(Model model, String library) {
  Domain domain = model.domain;

  return '''
part of \'../../$library.dart\';
// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/model.dart

class ${model.code}Model extends ${model.code}Entries {
  ${model.code}Model(super.model);

  ${model.entryConcepts.isEmpty ? '' : model.entryConcepts.map((entryConcept) => '''
void fromJsonTo${entryConcept.code}Entry() {
    fromJsonToEntry(${domain.codeFirstLetterLower}${model.code}${entryConcept.code}Entry);
  }
  ''').where((item) => item.trim().length > 0).join('\n')}
  void fromJsonToModel() {
    fromJson(${domain.codeFirstLetterLower}${model.code}Model);
  }

  void init() {
    ${model.orderedEntryConcepts.isEmpty ? '' : model.orderedEntryConcepts.map((entryConcept) => 'init${entryConcept.codePluralFirstLetterUpper}();').where((item) => item.trim().length > 0).join('\n    ')}
  }
  ${model.entryConcepts.isEmpty ? '' : model.entryConcepts.map((entryConcept) => '''
void init${entryConcept.codePluralFirstLetterUpper}() {
    ${createInitEntryEntitiesRandomly(entryConcept)}
  }
  ''').where((item) => item.trim().length > 0).join('\n')}
  // added after code gen - begin

  // added after code gen - end

}
''';
}

extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
