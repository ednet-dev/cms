import 'dart:io';

import 'package:build/build.dart';
import 'package:ednet_code_generation/ednet_code_generation.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class DirectoryManager {
  Future<void> ensureDirectoryExists(String path) async {
    final dirExists = await Directory(path).exists();
    if (!dirExists) {
      await Directory(path).create(recursive: true);
    }
  }

  Future<void> runPubGet(String path) async {
    final result =
        await Process.run('dart', ['pub', 'get'], workingDirectory: path);
    if (result.exitCode != 0) {
      log.severe('Failed to run dart pub get in $path: ${result.stderr}');
      throw Exception('dart pub get failed');
    }
  }
}

class YamlReader {
  Future<String> readYamlFile(String path) async {
    final yamlFile = File(path);
    try {
      return await yamlFile.readAsString();
    } catch (e) {
      log.severe('Error reading YAML file: $path, Error: $e');
      throw e;
    }
  }

  dynamic parseYaml(String yamlContent) {
    try {
      final yamlData = loadYaml(yamlContent);
      if (yamlData is! YamlMap && yamlData is! YamlList) {
        throw Exception('Invalid YAML structure');
      }
      return yamlData;
    } catch (e) {
      log.severe('Error parsing YAML content: $yamlContent, Error: $e');
      throw e;
    }
  }
}

class CodeGenerator {
  Future<void> generateCode({
    required String sourceDir,
    required String targetDir,
    required String domainName,
    required String models,
    required File yamlFile,
  }) async {
    try {
      await EDNetCodeGenerator.generateFromYaml(
        targetDir: targetDir,
        yamlFile: yamlFile,
      );
      // Execute dart pub get in the root folder of the generated lib
    } catch (e) {
      log.severe('Error generating code for file: $sourceDir, Error: $e');
      throw e;
    }
  }
}

class RequirementsProcessor {
  final DirectoryManager directoryManager;
  final YamlReader yamlReader;
  final CodeGenerator codeGenerator;

  RequirementsProcessor({
    required this.directoryManager,
    required this.yamlReader,
    required this.codeGenerator,
  });

  Future<void> processRequirements(
      String rootDir, String contentDir, BuildStep buildStep) async {
    final requirementsDir = '$rootDir/$contentDir';
    final generatedDir = '$rootDir/generated';
    await directoryManager.ensureDirectoryExists(generatedDir);

    final requirementsGlob = Glob('$requirementsDir/**.ednet.yaml');
    final requirementsFiles =
        await buildStep.findAssets(requirementsGlob).toList();

    for (var file in requirementsFiles) {
      final relativeFilePath = p.relative(file.path, from: requirementsDir);
      final directoryName = relativeFilePath.replaceAll('.ednet.yaml', '');
      final newDirPath = '$generatedDir/$directoryName';
      await directoryManager.ensureDirectoryExists(newDirPath);

      final yamlContent = await yamlReader.readYamlFile(file.path);
      final yamlParsed = yamlReader.parseYaml(yamlContent);

      var dirname = p.dirname(file.path);
      var yamlFileLocal = File(file.path);
      await codeGenerator.generateCode(
        sourceDir: dirname,
        targetDir: newDirPath,
        domainName: yamlParsed['domain'],
        models: yamlContent,
        yamlFile: yamlFileLocal,
      );

      //defer 1 second await directoryManager.runPubGet(newDirPath);
      await Future.delayed(Duration(seconds: 1));
      await directoryManager.runPubGet(newDirPath);
    }
  }
}

class ContentWatcherBuilder implements Builder {
  final RequirementsProcessor requirementsProcessor;

  ContentWatcherBuilder()
      : requirementsProcessor = RequirementsProcessor(
          directoryManager: DirectoryManager(),
          yamlReader: YamlReader(),
          codeGenerator: CodeGenerator(),
        );

  @override
  Map<String, List<String>> get buildExtensions => {
        '.ednet.yaml': ['_ednet.g.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // continue if path is in /lib/generated
    if (!buildStep.inputId.path.contains('requirements')) {
      return;
    }

    log.info('DEBUG: ${buildStep.inputId.path}');
    await requirementsProcessor.processRequirements(
        'lib', 'requirements', buildStep);
  }
}

Builder contentWatcherBuilder(BuilderOptions options) =>
    ContentWatcherBuilder();
