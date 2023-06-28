library ednet_core_gen;

import 'dart:io';
import 'package:yaml/yaml.dart';

import 'package:ednet_core/ednet_core.dart';

part 'doc_gen.dart';

part 'lib_gen.dart';

part 'test_gen.dart';

part 'web_gen.dart';

late String libraryName;
late String domainName;
late String outputDir;
late String modelName;

late CoreRepository ednetCoreRepository;
late Domain ednetCoreDomain;
late Model ednetCoreModel;

String? modelJson;
late String yamlString;

String firstLetterToUpper(String text) {
  return '${text[0].toUpperCase()}${text.substring(1)}';
}

Directory genDir(String path) {
  var dir = new Directory(path);
  if (dir.existsSync()) {
    print('directory ${path} exists already');
  } else {
    dir.createSync();
    print('directory created: ${path}');
  }
  return dir;
}

File genFile(String path) {
  File file = new File(path);
  if (file.existsSync()) {
    print('file ${path} exists already');
  } else {
    file.createSync();
    print('file created: ${path}');
  }
  return file;
}

void addText(File file, String text) {
  IOSink writeSink = file.openWrite();
  writeSink.write(text);
  writeSink.close();
}

File getFile(String path) {
  return genFile(path);
}

String readTextFromFile(File file) {
  String fileText = file.readAsStringSync();
  return fileText;
}

void genGitignore(File file) {
  var text = '''
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

/*
void genPubspec(File file) {
  var text = '''
name: ${domainName}_${modelName}
version: 0.0.1

description: ${domainName}_${modelName} application that uses ednet_core for its model.

homepage: https://ednet.dev/

environment:
  sdk: '>=3.0.3 <4.0.0'

dependencies:
  ednet_core:
    git: https://github.com/ednet-dev/ednet_core.git
  ednet_core_default_app:
    git: https://github.com/ednet-dev/ednet_core_default_app.git
  ''';
  addText(file, text);
}
*/

void genPubspec(File file) {
  var text = '''
name: ${domainName}_${modelName}
version: 0.0.1

description: ${domainName}_${modelName} application that uses ednet_core for its model.

homepage: https://context.dev/

environment:
  sdk: '>=3.0.3 <4.0.0'
  
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
    File gitignore = genFile('${projectPath}/.gitignore');
    genGitignore(gitignore);
    File readme = genFile('${projectPath}/README.md');
    genReadme(readme);
    File pubspec = genFile('${projectPath}/pubspec.yaml');
    genPubspec(pubspec);
  } else if (gen == '--gengen') {
    genLib(gen, projectPath);
  } else {
    print('valid gen argument is either --genall or --gengen');
  }
}

void createDomainModel(String projectPath) {
  var modelJsonFilePath = '${projectPath}/model.json';
  File modelJsonFile = getFile(modelJsonFilePath);
  modelJson = readTextFromFile(modelJsonFile);
  if (modelJson == null || modelJson?.length == 0) {
    print('missing json of the model');
  } else {
    ednetCoreRepository = new CoreRepository();
    ednetCoreDomain = new Domain(firstLetterToUpper(domainName));
    ednetCoreModel = fromJsonToModel(
        modelJson ?? '', ednetCoreDomain, firstLetterToUpper(modelName), null);
    ednetCoreRepository.domains.add(ednetCoreDomain);
  }
}

void createDomainModelFromYaml({dir, domain, model}) {
  yamlString = loadYamlFile(
    domain: domain,
    model: model,
    dir: dir,
  );

  final yaml = loadYaml(yamlString);

  if (yaml == null || yaml.length == 0) {
    print('missing YAML of the ${domain} model ${model}');
  } else {
    ednetCoreRepository = new CoreRepository();
    ednetCoreDomain = new Domain(firstLetterToUpper(domainName));
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
      throw new EDNetException('domain cannot be the domain name');
    }

    for (var i = 4; i < args.length; i++) {
      modelName = args[i].toLowerCase();
      if (modelName == 'model') {
        throw new EDNetException('model cannot be the model name');
      }
      libraryName = '${domainName}_${modelName}';
      displayYaml(domain: domainName, model: modelName, dir: args[1]);
      createDomainModelFromYaml(
        dir: args[1],
        domain: domainName,
        model: modelName,
      ); // project path as argument
      genProject(args[0], outputDir);
    }
  } else if (args.length == 4 &&
      (args[0] == '--genall' || args[0] == '--gengen')) {
    domainName = args[2];
    modelName = args[3];
    domainName = domainName.toLowerCase();
    modelName = modelName.toLowerCase();
    if (domainName == modelName) {
      throw new EDNetException('domain and model names must be different');
    }
    if (domainName == 'domain') {
      throw new EDNetException('domain cannot be the domain name');
    }
    if (modelName == 'model') {
      throw new EDNetException('model cannot be the model name');
    }
    libraryName = '${domainName}_${modelName}';
    createDomainModel(args[1]); // project path as argument
    genProject(args[0], args[1]);
  } else {
    print('arguments are not entered properly in Run/Manage Launches of IDE');
  }
}

void renderYaml(dynamic yamlString, String outputTemplate) {
  if (yamlString == null || yamlString.length == 0) {
    return;
  }
  final yaml = loadYaml(yamlString);
  final concepts = yaml['concepts'];
  for (final concept in concepts) {
    final conceptName = concept['name'];
    print(outputTemplate
        .replaceAll('{conceptName}', conceptName)
        .replaceAll('{attributeName}', '')
        .replaceAll('{relationName}', ''));

    final attributes = concept['attributes'] ?? [];
    for (final attribute in attributes) {
      final attributeName = attribute['name'];
      print(outputTemplate
          .replaceAll('{conceptName}', conceptName)
          .replaceAll('{attributeName}', attributeName)
          .replaceAll('{relationName}', ''));
    }

    final relations = yaml['relations'];
    for (final relation in relations) {
      final from = relation['from'];
      final to = relation['to'];
      final fromToName = relation['fromToName'];
      final toFromName = relation['toFromName'];
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
  var yamlFile = File("$dir/$domain/${model}/$model.yaml");
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

  final outputTemplate = '''
|  Concept: {conceptName}
|    Attribute: {attributeName}
|    Relation: {relationName}
''';

  renderYaml(yaml, outputTemplate);
}
