part of ednet_code_generation;

void genDomainModelGen(File file) {
  addText(file, genEDNetGen(ednetCoreModel));
}

void genDomainModelTest(File file, Concept entryConcept) {
  addText(
      file, genEDNetTest(ednetCoreRepository, ednetCoreModel, entryConcept));
}

void genTest(String path, Model ednetCoreModel) {
  final testPath = '${path}/test';
  genDir(testPath);

  final domainPath = '${testPath}/${domainName}';
  genDir(domainPath);

  final modelPath = '${domainPath}/${modelName}';
  genDir(modelPath);
  final domainModelGen =
      genFile('${modelPath}/${domainName}_${modelName}_gen.dart');
  genDomainModelGen(domainModelGen);
  for (final entryConcept in ednetCoreModel.entryConcepts) {
    final domainModelTest = genFile('${modelPath}/${domainName}_${modelName}_'
        '${entryConcept.codeLowerUnderscore}_test.dart');
    genDomainModelTest(domainModelTest, entryConcept);
  }
}
