import 'dart:io';

import 'package:ednet_core/ednet_core.dart';

import '../lib/ednet_code_generation.dart';

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
