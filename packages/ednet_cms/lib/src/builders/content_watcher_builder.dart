import 'dart:io';

import 'package:build/build.dart';
import 'package:ednet_code_generation/ednet_code_generation.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class ContentWatcherBuilder implements Builder {
  String rootDir = 'lib';
  String contentDir = 'requirements';

  ContentWatcherBuilder();

  @override
  Map<String, List<String>> get buildExtensions => {
        '.ednet.yaml': ['_ednet.g.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    log.info('DEBUG: ${buildStep.inputId.path}');

    // Get the path of the requirements directory
    final requirementsDir = '$rootDir/$contentDir';

    // Create the generated directory if it does not exist
    final generatedDir = '$rootDir/generated';
    final generatedDirExists = await Directory(generatedDir).exists();
    if (!generatedDirExists) {
      await Directory(generatedDir).create(recursive: true);
    }

    // Iterate over each file in the requirements directory
    final requirementsGlob = Glob('$requirementsDir/**.ednet.yaml');
    final requirementsFiles =
        await buildStep.findAssets(requirementsGlob).toList();

    for (var file in requirementsFiles) {
      // Get the relative path of the file from the requirements directory
      final relativeFilePath = p.relative(file.path, from: requirementsDir);

      // Replace the .ednet.yaml suffix with an empty string to get the directory name
      final directoryName = relativeFilePath.replaceAll('.ednet.yaml', '');

      // Create a directory in the generated directory with the same relative path
      final newDirPath = '$generatedDir/$directoryName';
      final newDirExists = await Directory(newDirPath).exists();
      if (!newDirExists) {
        await Directory(newDirPath).create(recursive: true);
      }

      // Read the contents of the YAML file
      final yamlFile = File(file.path);
      String yamlContent;
      try {
        yamlContent = await yamlFile.readAsString();
      } catch (e) {
        log.severe('Error reading YAML file: $file.path, Error: $e');
        continue;
      }

      // Parse YAML content to ensure it's valid
      try {
        final yamlData = loadYaml(yamlContent);
        if (yamlData is! YamlMap) {
          log.severe('Invalid YAML structure in file: $file.path');
          continue;
        }
      } catch (e) {
        log.severe('Error parsing YAML file: $file.path, Error: $e');
        continue;
      }

      // Generate the code for the YAML file
      try {
        await EDNetCodeGenerator.generate(
          sourceDir: p.dirname(file.path),
          targetDir: newDirPath,
          domainName: directoryName,
          models: yamlContent,
          yamlFile: yamlFile,
        );
      } catch (e) {
        log.severe('Error generating code for file: $file.path, Error: $e');
      }
    }

    return;
  }

  List<Map<String, dynamic>> parseYaml(String yamlContent) {
    final yamlData = loadYaml(yamlContent);
    List yamlList;

    if (yamlData is YamlList) {
      yamlList = yamlData;
    } else if (yamlData is YamlMap) {
      yamlList = [yamlData];
    } else {
      throw Exception('Unsupported YAML structure');
    }

    return yamlList.map((item) {
      final entity = item as YamlMap;
      final properties =
          entity['properties'] != null ? entity['properties'] as List : [];
      return {
        'name': entity['name'],
        'extends': entity['extends'],
        'properties': properties.map((property) {
          final prop = property as YamlMap;
          return {
            'name': prop['name'],
            'type': prop['type'],
            'relation': prop['relation'],
          };
        }).toList(),
      };
    }).toList();
  }
}

Builder contentWatcherBuilder(BuilderOptions options) =>
    ContentWatcherBuilder();
