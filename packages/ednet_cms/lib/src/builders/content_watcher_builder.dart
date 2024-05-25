import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
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
    // Only run the CmsBuilder if the changed file is in the content directory
    final inputId = buildStep.inputId;
    final inputPath = inputId.path;
    log.warning('FROM CONTENT WATCHER Processing ${buildStep.inputId.path}');

    // final rootDir = await _getRootDir(buildStep);

    final contentGlob = Glob('$rootDir/$contentDir/**');
    final isInContentDir = contentGlob.matches(inputPath);
    if (isInContentDir) {
      final outputId = AssetId(inputId.package,
          'lib/src/domain/${_toCamelCase(inputId.changeExtension('.g.dart').pathSegments.last)}');
      final rootDir = '${buildStep.inputId.package}/lib';
      final contentDir = '$rootDir/${this.contentDir}';

      // Create the content directory if it does not exist
      final contentDirExists = await Directory(contentDir).exists();
      if (!contentDirExists) {
        await Directory(contentDir).create(recursive: true);
      }

      // Read the contents of the YAML file
      final yamlFile = File(inputPath);
      final yamlContent = await yamlFile.readAsString();

      // Parse the YAML content
      final yamlMap = loadYaml(yamlContent);
      final entities = parseYaml(yamlContent);
      this.printEntities(entities);
      // Parse the YAML content
      // final yamlMap = loadYaml(yamlContent);
      //
      // // Generate the domain model code
      // final generator = EdnetCodeGenerator();
      // final generatedCode = generator.generate(yamlMap);

      // Write the generated code to a file
      final domainDir = '$rootDir/src/domain';
      final domainFile = File('$domainDir/domain_model.dart');
      // await domainFile.writeAsString(generatedCode);
    }
  }

  void printEntities(List<Map<String, dynamic>> entities) {
    for (var entity in entities) {
      log.warning('Entity: ${entity['name']}, Extends: ${entity['extends']}');
      for (var property in entity['properties']) {
        log.warning(
            '  Property: ${property['name']}, Type: ${property['type']}, Relation: ${property['relation']}');
      }
    }
  }

  List<Map<String, dynamic>> parseYaml(String yamlContent) {
    final yamlList = loadYaml(yamlContent) as List;
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

  String _toCamelCase(String input) {
    final parts = input.split('_');
    return parts.first +
        parts.skip(1).map((part) => part.capitalize()).join('');
  }

// Future<String> _getRootDir(BuildStep buildStep) async {
//   if (rootDir != null) {
//     return rootDir;
//   }
//
//   final inputId = buildStep.inputId;
//   final packageUri = inputId.packageUri;
//   final packagePath = packageUri.toFilePath(windows: Platform.isWindows);
//   final rootPubspecFile = File('$packagePath/../pubspec.yaml');
//   final pubspec = await loadYamlDocument(rootPubspecFile.readAsString());
//   final packageName = pubspec.contents.value['name'].value as String;
//   final assetReader = buildStep.readAsset;
//
//   final rootAssetId = AssetId(packageName, 'lib/$packageName.dart');
//   final rootAsset = await assetReader(rootAssetId);
//   final rootAssetPath = rootAsset.id.path;
//
//   _rootDir = rootAssetPath.substring(0, rootAssetPath.lastIndexOf('/'));
//   return _rootDir!;
// }
}

extension CapExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

Builder contentWatcherBuilder(BuilderOptions options) =>
    ContentWatcherBuilder();
