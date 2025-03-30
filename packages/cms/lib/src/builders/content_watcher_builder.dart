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
    final result = await Process.run('dart', [
      'pub',
      'get',
    ], workingDirectory: path);
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
      rethrow;
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
      rethrow;
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
      final meta = await EDNetCodeGenerator.generateFromYaml(
        targetDir: targetDir,
        yamlFile: yamlFile,
      );

      updateOneApplication(meta);
    } catch (e) {
      log.severe('Error generating code for file: $sourceDir, Error: $e');
      rethrow;
    }
  }

  void updateOneApplication(MetaInfo meta) {
    final oneApplicationFile = File('lib/generated/one_application.dart');
    final alias =
        '${meta.domain[0]}${meta.domain[meta.domain.length - 1]}${meta.model[0]}${meta.model[meta.model.length - 1]}';
    final importPath =
        'package:ednet_one/generated/${meta.domain}/${meta.model}/lib/${meta.domain}_${meta.model}.dart';

    // Placeholder for the imports section
    const importsPlaceholder = '// IMPORTS PLACEHOLDER';
    // Placeholder for the initialization section
    const initPlaceholder = '// INIT PLACEHOLDER';
    // Placeholder for the lookup table section
    const lookupTablePlaceholder = '// LOOKUP TABLE PLACEHOLDER';

    if (!oneApplicationFile.existsSync()) {
      oneApplicationFile.writeAsStringSync("""
import 'package:ednet_core/ednet_core.dart';

$importsPlaceholder

class OneApplication implements IOneApplication {
  final Domains _domains = Domains();
  final Domains _groupedDomains = Domains();
  final Map<String, DomainModels> _domainModelsTable = {};

  OneApplication() {
    _initializeDomains();
    _groupDomains();
  }

  void _initializeDomains() {
    $initPlaceholder
  }
  
  @override
  DomainModels getDomainModels(String domain, String model) {
    final domainModel = _domainModelsTable['\${domain}_\$model'];
  
    if (domainModel == null) {
      throw Exception('Domain model not found: \$domain, \$model');
    }
  
    return domainModel;
  }

  void _groupDomains() {
    for (var domain in _domains) {
      var existingDomain = _groupedDomains.singleWhereCode(domain.code);
      if (existingDomain == null) {
        _groupedDomains.add(domain);
      } else {
        _mergeDomainModels(existingDomain, domain);
      }
    }
  }

  void _mergeDomainModels(Domain targetDomain, Domain sourceDomain) {
    for (var model in sourceDomain.models) {
      if (!targetDomain.models.any((m) => m.code == model.code)) {
        targetDomain.models.add(model);
      } else {
        var targetModel =
            targetDomain.models.singleWhere((m) => m.code == model.code);
        _mergeModelEntries(targetModel, model);
      }
    }
  }

  void _mergeModelEntries(Model targetModel, Model sourceModel) {
    for (var concept in sourceModel.concepts) {
      if (!targetModel.concepts.any((c) => c.code == concept.code)) {
        targetModel.concepts.add(concept);
      }
    }
  }

  @override
  Domains get domains => _domains;
  @override
  Domains get groupedDomains => _groupedDomains;
  Map<String, DomainModels> get domainModels => _domainModelsTable;
}
""");
    }

    var content = oneApplicationFile.readAsStringSync();

    // Add import if it doesn't already exist
    if (!content.contains("import '$importPath' as $alias;")) {
      content = content.replaceFirst(
        importsPlaceholder,
        "import '$importPath' as $alias;\n$importsPlaceholder",
      );
    }

    // Prepare the initialization code
    final repoVarName =
        '${firstLetterLower(meta.domain)}${firstLetterUpper(meta.model)}Repo';
    final domainVarName =
        '${firstLetterLower(meta.domain)}${firstLetterUpper(meta.model)}Domain';
    final modelVarName = '${firstLetterLower(meta.model)}Model';

    final initCode = """
    // ${meta.domain} ${meta.model}
    final $repoVarName = $alias.${firstLetterUpper(meta.domain)}${firstLetterUpper(meta.model)}Repo();
    $alias.${firstLetterUpper(meta.domain)}Domain $domainVarName = $repoVarName
        .getDomainModels("${firstLetterUpper(meta.domain)}") as $alias.${firstLetterUpper(meta.domain)}Domain;
    $alias.${firstLetterUpper(meta.model)}Model $modelVarName =
        $domainVarName.getModelEntries("${firstLetterUpper(meta.model)}") as $alias.${firstLetterUpper(meta.model)}Model;
    $modelVarName.init();

    _domains..add($domainVarName.domain);
    _domainModelsTable['${meta.domain}_${meta.model}'] = $domainVarName;
""";

    // Add initialization if it doesn't already exist
    if (!content.contains(initCode.trim())) {
      content = content.replaceFirst(
        initPlaceholder,
        "$initCode\n$initPlaceholder",
      );
    }

    // Add to the lookup table
    final lookupEntry = "'${meta.domain}${meta.model}': $domainVarName";
    if (!content.contains(lookupEntry.trim())) {
      content = content.replaceFirst(
        lookupTablePlaceholder,
        "'${meta.domain}${meta.model}': $domainVarName,\n$lookupTablePlaceholder",
      );
    }

    // Write the updated content back to the file
    oneApplicationFile.writeAsStringSync(content);
  }

  String firstLetterUpper(String text) {
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  String firstLetterLower(String text) {
    return '${text[0].toLowerCase()}${text.substring(1)}';
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
    String rootDir,
    String contentDir,
    BuildStep buildStep,
  ) async {
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
        domainName: yamlParsed['domain'] ?? 'EDNet',
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
      'lib',
      'requirements',
      buildStep,
    );
  }
}

Builder contentWatcherBuilder(BuilderOptions options) =>
    ContentWatcherBuilder();
