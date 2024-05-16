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
  var sc = 'part of ${domainName}_${modelName}; \n';
  sc = '${sc} \n';
  sc = '${sc}// http://www.json.org/ \n';
  sc = '${sc}// http://jsonformatter.curiousconcept.com/ \n';
  sc = '${sc} \n';
  sc = '${sc}// lib/${domainName}/${modelName}/json/data.dart \n';

  for (final entryConcept in ednetCoreModel.entryConcepts) {
    sc = '${sc}var ${domainName}${firstLetterToUpper(modelName)}'
        '${entryConcept.code}Entry = r""" \n';
    sc = '${sc} \n';
    sc = '${sc}"""; \n';
    sc = '${sc} \n';
  }

  sc = '${sc}var ${domainName}${firstLetterToUpper(modelName)}Model = r""" \n';
  sc = '${sc} \n';
  sc = '${sc}"""; \n';
  sc = '${sc} \n';

  addText(file, sc);
}

void genJsonModel(File file) {
  final text = """
part of ${domainName}_${modelName};

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/${domainName}/${modelName}/json/model.dart

var ${domainName}${firstLetterToUpper(modelName)}ModelJson = r'''
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
