part of ednet_code_generation;

void genDomainModelLibrary(File file) {
  addText(file, genEDNetLibrary(ednetCoreModel));
}

void genDomainModelAppLibrary(File file) {
  addText(file, genEDNetLibraryApp(ednetCoreModel));
}

void genEDNetCoreRepository(File file) {
  addText(file, genRepository(ednetCoreRepository, libraryName));
}

void genEDNetCoreModels(File file) {
  addText(file, genModels(ednetCoreDomain, libraryName));
}

void genEDNetCoreDomain(File file) {
  addText(file, genDomain(ednetCoreDomain, libraryName));
}

void genEDNetCoreEntries(File file) {
  addText(file, genEntries(ednetCoreModel, libraryName));
}

void genEDNetCoreModel(File file) {
  addText(file, genModel(ednetCoreModel, libraryName));
}

void genConceptEntitiesGen(File file, Concept concept) {
  addText(file, genConceptGen(concept, libraryName));
}

void genConceptEntities(File file, Concept concept) {
  addText(file, genConcept(concept, libraryName));
}

void genJsonData(File file) {
  final buffer = StringBuffer()
    ..writeln('part of \'../../../${domainName}_${modelName}.dart\';')
    ..writeln()
    ..writeln(
        '// DSL: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/SCHEMA.md')
    ..writeln(
        '// DSL Schema: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/schema/yaml/schema.json')
    ..writeln()
    ..writeln('// lib/${domainName}/${modelName}/json/data.dart');

  for (final entryConcept in ednetCoreModel.entryConcepts) {
    buffer
      ..writeln(
          'String ${domainName}${firstLetterToUpper(modelName)}${entryConcept.code}Entry = \'\'\'')
      ..writeln('\'\'\';')
      ..writeln();
  }

  buffer
    ..writeln(
        'String ${domainName}${firstLetterToUpper(modelName)}Model = \'\'\'')
    ..writeln('\'\'\';')
    ..writeln();

  addText(file, buffer.toString());
}

void genJsonModel(File file) {
  final text = """
part of \'../../../${domainName}_${modelName}.dart\';

// DSL: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/SCHEMA.md
// DSL Schema: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/schema/yaml/schema.json

// lib/${domainName}/${modelName}/json/model.dart
String ${domainName}${firstLetterToUpper(modelName)}ModelYaml = '''
${modelJson ?? yamlString}
''';

  """;
  addText(file, text);
}

void genAll(String path) {
  final libPath = '${path}/lib';
  genDir(libPath);
  final repository = genFile('${libPath}/repository.dart');
  genEDNetCoreRepository(repository);
  final domainModelLibrary =
      genFile('${libPath}/${domainName}_${modelName}.dart');
  genDomainModelLibrary(domainModelLibrary);
  final domainModelAppLibrary =
      genFile('${libPath}/${domainName}_${modelName}_app.dart');
  genDomainModelAppLibrary(domainModelAppLibrary);

  final domainPath = '${libPath}/${domainName}';
  genDir(domainPath);
  final domain = genFile('${domainPath}/domain.dart');
  genEDNetCoreDomain(domain);

  final modelPath = '${domainPath}/${modelName}';
  genDir(modelPath);
  final model = genFile('${modelPath}/model.dart');
  genEDNetCoreModel(model);
  for (final concept in ednetCoreModel.concepts) {
    final conceptEntities =
        genFile('${modelPath}/${concept.codesLowerUnderscore}.dart');
    genConceptEntities(conceptEntities, concept);
  }

  final jsonPath = '${modelPath}/json';
  genDir(jsonPath);
  final jsonData = genFile('${jsonPath}/data.dart');
  genJsonData(jsonData);
  final jsonModel = genFile('${jsonPath}/model.dart');
  genJsonModel(jsonModel);

  genGen(path);
}

void genGen(String path) {
  final genPath = '${path}/lib/gen';
  genDir(genPath);

  final genDomainPath = '${genPath}/${domainName}';
  genDir(genDomainPath);
  final models = genFile('${genDomainPath}/i_domain_models.dart');
  genEDNetCoreModels(models);

  final genModelPath = '${genDomainPath}/${modelName}';
  genDir(genModelPath);
  final entries = genFile('${genModelPath}/model_entries.dart');
  genEDNetCoreEntries(entries);
  for (final concept in ednetCoreModel.concepts) {
    final conceptEntitiesGen =
        genFile('${genModelPath}/${concept.codesLowerUnderscore}.dart');
    genConceptEntitiesGen(conceptEntitiesGen, concept);
  }
}

void genLib(String gen, String path) {
  if (gen == '--genall') {
    genAll(path);
  } else {
    genGen(path);
  }
}
