part of ednet_code_generation;

class EDNetCodeGenerator {
  static String generate({
    required String sourceDir,
    required String targetDir,
    required String domainName,
    required String models,
  }) {
    print([sourceDir, targetDir, domainName, models]);

    return '''
      Hello world!
    ''';
  }
}

String firstLetterToUpper(String text) {
  return '${text[0].toUpperCase()}${text.substring(1)}';
}

Directory genDir(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) {
    print('Directory ${path} already exists.');
  } else {
    dir.createSync(recursive: true); // create all non-existent directories
    print('Directory created: ${path}');
  }
  return dir;
}

File genFile(String path) {
  final file = File(path);
  if (file.existsSync()) {
    print('file ${path} exists already');
  } else {
    file.createSync();
    print('file created: ${path}');
  }
  return file;
}

void addText(File file, String text) {
  final writeSink = file.openWrite();
  writeSink.write(text);
  writeSink.close();
}

File getFile(String path) {
  return genFile(path);
}

String readTextFromFile(File file) {
  final fileText = file.readAsStringSync();
  return fileText;
}

void genGitignore(File file) {
  const text = '''
.DS_Store
.pub
build
packages
pubspec.lock
*~
  ''';
  addText(file, text);
}

void genReadme(File file) {
  var text = '';
  text = '${text}# ${domainName}_${modelName} \n';
  text = '${text}\n';
  text = '${text}**Categories**: ednet_core, domain models. \n';
  text = '${text}\n';
  text = '${text}## Description: \n';
  text = '${text}${domainName}_${modelName} project uses \n';
  text =
      '${text}[EDNetCore](https://github.com/context-dev/ednet_core) for the model.';
  addText(file, text);
}

void genPubspec(File file) {
  final text = '''
name: ${domainName}_${modelName}
version: 0.0.1

description: ${domainName}_${modelName} application that uses ednet_core for its model.

homepage: https://context.dev/

environment:
  sdk: '>=2.18.6 <3.0.0'
  
dependencies:
  ednet_core: ^0.0.1+2
  ednet_core_default_app:
    path: ../../../../experiments/ednet_core_default_app
  
  ''';
  addText(file, text);
}

void genProject(String gen, String projectPath) {
  if (gen == '--genall') {
    genDir(projectPath);
    genDoc(projectPath);
    genLib(gen, projectPath);
    genTest(projectPath, ednetCoreModel);
    genWeb(projectPath);
    final gitignore = genFile('${projectPath}/.gitignore');
    genGitignore(gitignore);
    final readme = genFile('${projectPath}/README.md');
    genReadme(readme);
    final pubspec = genFile('${projectPath}/pubspec.yaml');
    genPubspec(pubspec);
  } else if (gen == '--gengen') {
    genLib(gen, projectPath);
  } else {
    print('valid gen argument is either --genall or --gengen');
  }
}

void createDomainModel(String projectPath) {
  final modelJsonFilePath = '${projectPath}/model.json';
  final modelJsonFile = getFile(modelJsonFilePath);
  modelJson = readTextFromFile(modelJsonFile);
  if (modelJson == null || modelJson?.length == 0) {
    print('missing json of the model');
  } else {
    ednetCoreRepository = CoreRepository();
    ednetCoreDomain = Domain(firstLetterToUpper(domainName));
    ednetCoreModel = fromJsonToModel(
        modelJson ?? '', ednetCoreDomain, firstLetterToUpper(modelName), null);
    ednetCoreRepository.domains.add(ednetCoreDomain);
  }
}

void createDomainModelFromYaml({
  required String dir,
  required String domain,
  required String model,
}) {
  yamlString = loadYamlFile(
    domain: domain,
    model: model,
    dir: dir,
  );

  final yaml = loadYaml(yamlString!) as YamlMap;

  if (yaml == null || yaml.length == 0) {
    print('missing YAML of the ${domain} model ${model}');
  } else {
    ednetCoreRepository = CoreRepository();
    ednetCoreDomain = Domain(firstLetterToUpper(domainName));
    ednetCoreModel = fromJsonToModel(
        '', ednetCoreDomain, firstLetterToUpper(modelName), yaml);
    ednetCoreRepository.domains.add(ednetCoreDomain);
  }
}

/// --genall ~/projects/project domain model
/// --gengen ~/projects/project domain model
/// --gengen ~/projects/project/yaml ~/projects/project_mobile_app/domain domain model1 model2 ...
void main(List<String> args) {
  if (args.length >= 5 && (args[0] == '--genall' || args[0] == '--gengen')) {
    domainName = args[3];
    outputDir = args[2];
    domainName = domainName.toLowerCase();
    if (domainName == 'domain') {
      throw EDNetException('domain cannot be the domain name');
    }

    for (var i = 4; i < args.length; i++) {
      modelName = args[i].toLowerCase();
      if (modelName == 'model') {
        throw EDNetException('model cannot be the model name');
      }
      libraryName = '${domainName}_${modelName}';
      // displayYaml(domain: domainName, model: modelName, dir: args[1]);
      createDomainModelFromYaml(
        dir: args[1],
        domain: domainName,
        model: modelName,
      ); // project path as argument
      genProject(args[0], outputDir!);
    }
  } else if (args.length == 4 &&
      (args[0] == '--genall' || args[0] == '--gengen')) {
    domainName = args[2];
    modelName = args[3];
    domainName = domainName.toLowerCase();
    modelName = modelName.toLowerCase();
    if (domainName == modelName) {
      throw EDNetException('domain and model names must be different');
    }
    if (domainName == 'domain') {
      throw EDNetException('domain cannot be the domain name');
    }
    if (modelName == 'model') {
      throw EDNetException('model cannot be the model name');
    }
    libraryName = '${domainName}_${modelName}';
    createDomainModel(args[1]); // project path as argument
    genProject(args[0], args[1]);
  } else {
    print('arguments are not entered properly in Run/Manage Launches of IDE');
  }
}

void renderYaml(String yamlString, String outputTemplate) {
  if (yamlString.length == 0) {
    return;
  }
  final yaml = loadYaml(yamlString) as Map;
  final concepts = yaml['concepts'] as Iterable;
  for (final concept in concepts) {
    final conceptName = concept['name'] as String;
    print(outputTemplate
        .replaceAll('{conceptName}', conceptName)
        .replaceAll('{attributeName}', '')
        .replaceAll('{relationName}', ''));

    final attributes = concept['attributes'] as Iterable<Map>;
    for (final attribute in attributes) {
      final attributeName = attribute['name'] as String;
      print(outputTemplate
          .replaceAll('{conceptName}', conceptName)
          .replaceAll('{attributeName}', attributeName)
          .replaceAll('{relationName}', ''));
    }

    final relations = yaml['relations'] as Iterable;
    for (final relation in relations) {
      final from = relation['from'] as String;
      final to = relation['to'] as String;
      final fromToName = relation['fromToName'] as String;
      final toFromName = relation['toFromName'] as String;
      if (from == conceptName) {
        final relationName = '$fromToName $to';
        print(outputTemplate
            .replaceAll('{conceptName}', conceptName)
            .replaceAll('{attributeName}', '')
            .replaceAll('{relationName}', relationName));
      }
      if (to == conceptName) {
        final relationName = '$toFromName $from';
        print(outputTemplate
            .replaceAll('{conceptName}', conceptName)
            .replaceAll('{attributeName}', '')
            .replaceAll('{relationName}', relationName));
      }
    }
  }
}

String loadYamlFile({
  required String domain,
  required String model,
  required String dir,
}) {
  final yamlFilePath = p.join(dir, domain, model, '$model.yaml') as String;
  final yamlFile = File(yamlFilePath);
  return yamlFile.readAsStringSync();
}

void displayYaml({
  required String domain,
  required String model,
  required String dir,
}) {
  final yaml = loadYamlFile(
    domain: domain,
    model: model,
    dir: dir,
  );

  const outputTemplate = '''
|  Concept: {conceptName}
|    Attribute: {attributeName}
|    Relation: {relationName}
''';

  // renderYaml(yaml, outputTemplate);
}

void gen(String gen,
    {String? projectPath, String? dir, String? domain, String? model}) {
  if (gen == '--genall') {
    if (projectPath != null) {
      genDir(projectPath);
      genDoc(projectPath);
      genLib(gen, projectPath);
      genTest(projectPath, ednetCoreModel);
      genWeb(projectPath);
      final gitignore = genFile('${projectPath}/.gitignore');
      genGitignore(gitignore);
      final readme = genFile('${projectPath}/README.md');
      genReadme(readme);
      final pubspec = genFile('${projectPath}/pubspec.yaml');
      genPubspec(pubspec);
    } else {
      throw ArgumentError('projectPath is required when calling --genall');
    }
  } else if (gen == '--gengen') {
    if (projectPath != null) {
      genLib(gen, projectPath);
    } else if (dir != null && domain != null && model != null) {
      createDomainModelFromYaml(
        dir: dir,
        domain: domain,
        model: model,
      );
      if (outputDir != null) {
        genLib(gen, outputDir!);
      } else {
        throw ArgumentError(
            'outputDir is required when calling --gengen with dir, domain,'
            ' and model arguments');
      }
    } else {
      throw ArgumentError(
          'projectPath or dir, domain, and model arguments are required '
          'when calling --gengen');
    }
  } else {
    throw ArgumentError('valid gen argument is either --genall or --gengen');
  }
}
