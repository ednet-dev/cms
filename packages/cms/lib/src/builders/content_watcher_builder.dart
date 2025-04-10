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

  String fixRelationshipIssues(String yamlContent, dynamic yamlParsed) {
    if (yamlParsed == null ||
        yamlParsed is! YamlMap ||
        yamlParsed['relations'] == null) {
      return yamlContent; // No relations to fix
    }

    final relations = yamlParsed['relations'] as YamlList;
    final relationPairs = <String, List<YamlMap>>{};

    // Group relations by entity pairs
    for (var relation in relations) {
      if (relation is YamlMap) {
        final from = relation['from'] as String?;
        final to = relation['to'] as String?;

        if (from != null && to != null) {
          // Create a canonical representation of the relation pair
          final entities = [from, to]..sort();
          final relationKey = "${entities[0]}_${entities[1]}";

          relationPairs.putIfAbsent(relationKey, () => []).add(relation);
        }
      }
    }

    // Check for inheritance relationships that might cause conflicts
    final potentialConflicts = detectInheritanceConflicts(yamlParsed);
    if (potentialConflicts.isNotEmpty) {
      log.warning(
        'Potential inheritance conflicts detected: $potentialConflicts',
      );
    }

    // Check for direct multiple relationships between Inquiry and ProviderCompany
    final modifiedContent = fixInquiryProviderRelationship(
      yamlContent,
      relationPairs,
    );
    if (modifiedContent != yamlContent) {
      return modifiedContent;
    }

    // If we have the specific Inquiry-ProviderCompany issue
    final inquiryProviderKey = "Inquiry_ProviderCompany";
    if (relationPairs.containsKey(inquiryProviderKey) &&
        relationPairs[inquiryProviderKey]!.length > 1) {
      log.info(
        'Found multiple relationships between Inquiry and ProviderCompany. Attempting to fix...',
      );

      // Find the offending relations in the original YAML
      for (var relation in relationPairs[inquiryProviderKey]!) {
        final from = relation['from'] as String;
        final to = relation['to'] as String;

        if (from == "Inquiry" && to == "ProviderCompany") {
          // This is the relation we want to keep and potentially fix

          // Rename the relation to make it more specific
          final originalYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${relation['fromToName']}"
    fromToMin: "${relation['fromToMin']}"
    fromToMax: "${relation['fromToMax']}"
    toFromName: "${relation['toFromName']}"
    toFromMin: "${relation['toFromMin']}"
    toFromMax: "${relation['toFromMax']}"
    category: "${relation['category']}"
""";

          // Create a more specific relation name
          final modifiedYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "assignedProviders"
    fromToMin: "${relation['fromToMin']}"
    fromToMax: "${relation['fromToMax']}"
    toFromName: "assignedInquiries" 
    toFromMin: "${relation['toFromMin']}"
    toFromMax: "${relation['toFromMax']}"
    category: "${relation['category']}"
    uniqueRelationIdentifier: "inquiry_provider_assignment"
""";

          // Replace this specific relation in the YAML content
          return yamlContent.replaceFirst(
            originalYamlSnippet,
            modifiedYamlSnippet,
          );
        }
      }
    }

    return yamlContent; // No changes made
  }

  String fixInquiryProviderRelationship(
    String yamlContent,
    Map<String, List<YamlMap>> relationPairs,
  ) {
    // Specifically addressing "Inquiry -- ProviderCompany relation has two children" error
    final inquiryProviderKey = "Inquiry_ProviderCompany";

    if (relationPairs.containsKey(inquiryProviderKey)) {
      final inqProvRelations = relationPairs[inquiryProviderKey]!;

      // If we have exactly one association relationship, we might still need to fix it
      if (inqProvRelations.length == 1 &&
          inqProvRelations.single['category'] == 'association') {
        // Extract the relation details
        final relation = inqProvRelations.single;
        final from = relation['from'] as String;
        final to = relation['to'] as String;

        // Check if this is the specific relationship that's causing issues
        if ((from == "Inquiry" && to == "ProviderCompany") ||
            (from == "ProviderCompany" && to == "Inquiry")) {
          // Prepare the replacement snippet with explicit child relationship identifiers
          String originalYamlSnippet;
          String modifiedYamlSnippet;

          if (from == "Inquiry" && to == "ProviderCompany") {
            originalYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${relation['fromToName']}"
    fromToMin: "${relation['fromToMin']}"
    fromToMax: "${relation['fromToMax']}"
    toFromName: "${relation['toFromName']}"
    toFromMin: "${relation['toFromMin']}"
    toFromMax: "${relation['toFromMax']}"
    category: "${relation['category']}"
""";

            modifiedYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${relation['fromToName']}"
    fromToMin: "${relation['fromToMin']}"
    fromToMax: "${relation['fromToMax']}"
    toFromName: "${relation['toFromName']}"
    toFromMin: "${relation['toFromMin']}"
    toFromMax: "${relation['toFromMax']}"
    category: "${relation['category']}"
    childRelationName: "inquiryToProviderAssignment"
""";
          } else {
            // Handle the case where ProviderCompany is the "from" entity
            originalYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${relation['fromToName']}"
    fromToMin: "${relation['fromToMin']}"
    fromToMax: "${relation['fromToMax']}"
    toFromName: "${relation['toFromName']}"
    toFromMin: "${relation['toFromMin']}"
    toFromMax: "${relation['toFromMax']}"
    category: "${relation['category']}"
""";

            modifiedYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${relation['fromToName']}"
    fromToMin: "${relation['fromToMin']}"
    fromToMax: "${relation['fromToMax']}"
    toFromName: "${relation['toFromName']}"
    toFromMin: "${relation['toFromMin']}"
    toFromMax: "${relation['toFromMax']}"
    category: "${relation['category']}"
    childRelationName: "providerToInquiryAssignment"
""";
          }

          log.info(
            'Adding explicit child relation name to ${from}-${to} relationship',
          );
          return yamlContent.replaceFirst(
            originalYamlSnippet,
            modifiedYamlSnippet,
          );
        }
      }

      // Check for multiple relations and fix by merging or removing duplicates
      if (inqProvRelations.length > 1) {
        log.warning(
          'Found ${inqProvRelations.length} relationships between Inquiry and ProviderCompany',
        );

        // Find if we have a mix of inheritance and association
        final hasInheritance = inqProvRelations.any(
          (r) => r['category'] == 'inheritance',
        );
        final associations =
            inqProvRelations
                .where((r) => r['category'] == 'association')
                .toList();

        if (hasInheritance && associations.isNotEmpty) {
          // We have both inheritance and association - prioritize inheritance and add unique identifiers to associations
          String currentContent = yamlContent;

          for (var assoc in associations) {
            final from = assoc['from'] as String;
            final to = assoc['to'] as String;

            final originalYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${assoc['fromToName']}"
    fromToMin: "${assoc['fromToMin']}"
    fromToMax: "${assoc['fromToMax']}"
    toFromName: "${assoc['toFromName']}"
    toFromMin: "${assoc['toFromMin']}"
    toFromMax: "${assoc['toFromMax']}"
    category: "association"
""";

            final modifiedYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${assoc['fromToName']}"
    fromToMin: "${assoc['fromToMin']}"
    fromToMax: "${assoc['fromToMax']}"
    toFromName: "${assoc['toFromName']}"
    toFromMin: "${assoc['toFromMin']}"
    toFromMax: "${assoc['toFromMax']}"
    category: "association"
    uniqueRelationIdentifier: "${from.toLowerCase()}_${to.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}"
""";

            currentContent = currentContent.replaceFirst(
              originalYamlSnippet,
              modifiedYamlSnippet,
            );
          }

          return currentContent;
        }

        // If we have multiple associations, keep only one and modify it
        if (associations.length > 1) {
          // Keep only the first association and remove others
          final keepAssoc = associations.first;
          String currentContent = yamlContent;

          // Add a unique identifier to the one we're keeping
          final from = keepAssoc['from'] as String;
          final to = keepAssoc['to'] as String;

          final originalYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${keepAssoc['fromToName']}"
    fromToMin: "${keepAssoc['fromToMin']}"
    fromToMax: "${keepAssoc['fromToMax']}"
    toFromName: "${keepAssoc['toFromName']}"
    toFromMin: "${keepAssoc['toFromMin']}"
    toFromMax: "${keepAssoc['toFromMax']}"
    category: "association"
""";

          final modifiedYamlSnippet = """
  - from: "${from}"
    to: "${to}"
    fromToName: "${keepAssoc['fromToName']}"
    fromToMin: "${keepAssoc['fromToMin']}"
    fromToMax: "${keepAssoc['fromToMax']}"
    toFromName: "${keepAssoc['toFromName']}"
    toFromMin: "${keepAssoc['toFromMin']}"
    toFromMax: "${keepAssoc['toFromMax']}"
    category: "association"
    uniqueRelationIdentifier: "primary_${from.toLowerCase()}_${to.toLowerCase()}"
""";

          currentContent = currentContent.replaceFirst(
            originalYamlSnippet,
            modifiedYamlSnippet,
          );

          // For the rest, we'll remove them
          for (var i = 1; i < associations.length; i++) {
            final removeAssoc = associations[i];
            final removeFrom = removeAssoc['from'] as String;
            final removeTo = removeAssoc['to'] as String;

            final removeYamlSnippet = """
  - from: "${removeFrom}"
    to: "${removeTo}"
    fromToName: "${removeAssoc['fromToName']}"
    fromToMin: "${removeAssoc['fromToMin']}"
    fromToMax: "${removeAssoc['fromToMax']}"
    toFromName: "${removeAssoc['toFromName']}"
    toFromMin: "${removeAssoc['toFromMin']}"
    toFromMax: "${removeAssoc['toFromMax']}"
    category: "association"
""";

            // Replace with an empty string (effectively removing it)
            currentContent = currentContent.replaceFirst(removeYamlSnippet, "");
          }

          log.info(
            'Removed ${associations.length - 1} duplicate associations between Inquiry and ProviderCompany',
          );
          return currentContent;
        }
      }
    }

    return yamlContent; // No changes needed
  }

  List<String> detectInheritanceConflicts(dynamic yamlData) {
    if (yamlData == null || yamlData is! YamlMap) {
      return []; // No data to analyze
    }

    final conflicts = <String>[];

    // Extract all concepts
    final concepts = yamlData['concepts'] as YamlList?;
    if (concepts == null) return [];

    // Map to keep track of inheritance relationships
    final inheritanceMap = <String, String>{};

    // Find inheritance relationships from concept definitions ("is" field)
    for (var concept in concepts) {
      if (concept is YamlMap) {
        final name = concept['name'] as String?;
        final isA = concept['is'] as String?;

        if (name != null && isA != null) {
          inheritanceMap[name] = isA;
        }
      }
    }

    // Now check relations for potential conflicts
    final relations = yamlData['relations'] as YamlList?;
    if (relations == null) return [];

    for (var relation in relations) {
      if (relation is YamlMap) {
        final from = relation['from'] as String?;
        final to = relation['to'] as String?;
        final category = relation['category'] as String?;

        if (from != null && to != null && category == 'association') {
          // Check if there's an inheritance relationship between these entities
          if (inheritanceMap[from] == to || inheritanceMap[to] == from) {
            conflicts.add(
              '$from -- $to: has both inheritance and association relationships',
            );
          }

          // Also check for indirect inheritance (through a parent class)
          var currentFrom = from;
          while (inheritanceMap.containsKey(currentFrom)) {
            if (inheritanceMap[currentFrom] == to) {
              conflicts.add(
                '$from -- $to: has association but $from inherits from $to',
              );
              break;
            }
            currentFrom = inheritanceMap[currentFrom]!;
          }

          var currentTo = to;
          while (inheritanceMap.containsKey(currentTo)) {
            if (inheritanceMap[currentTo] == from) {
              conflicts.add(
                '$from -- $to: has association but $to inherits from $from',
              );
              break;
            }
            currentTo = inheritanceMap[currentTo]!;
          }
        }
      }
    }

    return conflicts;
  }

  void validateRelations(dynamic yamlData) {
    if (yamlData == null ||
        yamlData is! YamlMap ||
        yamlData['relations'] == null) {
      return; // No relations to validate
    }

    final relations = yamlData['relations'] as YamlList;
    final relationPairs = <String>{};
    final duplicateRelations = <String>[];

    for (var relation in relations) {
      if (relation is YamlMap) {
        final from = relation['from'] as String?;
        final to = relation['to'] as String?;

        if (from != null && to != null) {
          // Create a canonical representation of the relation pair
          // Sort the entity names to ensure consistent key format regardless of direction
          final entities = [from, to]..sort();
          final relationKey = "${entities[0]}_${entities[1]}";

          if (relationPairs.contains(relationKey)) {
            duplicateRelations.add("$from -- $to");
          } else {
            relationPairs.add(relationKey);
          }
        }
      }
    }

    // Check for inheritance relations that might conflict with associations
    final inheritanceRelations =
        relations
            .where((r) {
              return r is YamlMap && r['category'] == 'inheritance';
            })
            .map((r) {
              final from = r['from'] as String;
              final to = r['to'] as String;
              return ['${from}_$to', '${to}_$from'];
            })
            .expand((i) => i)
            .toSet();

    // Find association relations that might conflict with inheritance
    final associationRelations =
        relations
            .where((r) {
              return r is YamlMap && r['category'] == 'association';
            })
            .map((r) {
              final from = r['from'] as String;
              final to = r['to'] as String;
              return '${from}_$to';
            })
            .toSet();

    // Check for conflicts between inheritance and association relations
    final conflictingRelations = inheritanceRelations.intersection(
      associationRelations,
    );

    if (conflictingRelations.isNotEmpty) {
      throw Exception(
        'Conflicting inheritance and association relations found: ${conflictingRelations.join(', ')}',
      );
    }

    if (duplicateRelations.isNotEmpty) {
      throw Exception(
        'Multiple relation definitions found between: ${duplicateRelations.join(', ')}',
      );
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

      try {
        final yamlParsed = yamlReader.parseYaml(yamlContent);

        // First check for inheritance-related conflicts
        final conflicts = yamlReader.detectInheritanceConflicts(yamlParsed);
        if (conflicts.isNotEmpty) {
          log.warning(
            'Inheritance conflicts in ${file.path}: ${conflicts.join(', ')}',
          );
        }

        // Try to fix any relationship issues
        final fixedYamlContent = yamlReader.fixRelationshipIssues(
          yamlContent,
          yamlParsed,
        );

        // If the content was modified, re-parse it
        final finalYamlContent =
            fixedYamlContent != yamlContent ? fixedYamlContent : yamlContent;

        final finalYamlParsed =
            fixedYamlContent != yamlContent
                ? yamlReader.parseYaml(fixedYamlContent)
                : yamlParsed;

        // Validate relationships before generating code
        yamlReader.validateRelations(finalYamlParsed);

        var dirname = p.dirname(file.path);
        var yamlFileLocal = File(file.path);

        // If we fixed the content, write it back to the file
        if (fixedYamlContent != yamlContent) {
          log.info('Fixed relationship issues in ${file.path}');
          yamlFileLocal.writeAsStringSync(fixedYamlContent);
        }

        final domain = finalYamlParsed['domain'] ?? {'name': 'EDNet'};
        await codeGenerator.generateCode(
          sourceDir: dirname,
          targetDir: newDirPath,
          domainName: domain['name'],
          models: finalYamlContent,
          yamlFile: yamlFileLocal,
        );

        await Future.delayed(Duration(seconds: 1));
        await directoryManager.runPubGet(newDirPath);
      } catch (e) {
        log.severe('Error processing YAML file: ${file.path}, Error: $e');
        // Continue processing other files even if one fails
      }
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
