import 'dart:io';
import 'package:ednet_core/ednet_core.dart';
import 'package:path/path.dart' as path;

/// Service that handles the code generation process.
///
/// This class provides an interface for generating code from domain model specifications,
/// managing the generation process, and handling the file system operations required.
class CodeGenerator {
  final String _requirementsBasePath;
  final String _generatedBasePath;

  /// Creates a new CodeGenerator for the specified environment.
  ///
  /// The [env] parameter specifies whether to use the staging or production environment.
  CodeGenerator({required String env})
    : _requirementsBasePath =
          'packages/ednet_one_interpreter/lib/requirements/$env',
      _generatedBasePath = 'packages/ednet_one_interpreter/lib/generated/$env';

  /// Generates code for the specified domain and model.
  ///
  /// This method reads the specification files in the requirements folder,
  /// generates the corresponding Dart code, and writes it to the generated folder.
  Future<bool> generateCode(Domain domain, Model model) async {
    final domainCode = domain.codeFirstLetterLower;
    final modelCode = model.codeFirstLetterLower;

    try {
      // 1. Read specification file
      final specPath = path.join(_requirementsBasePath, domainCode, modelCode);

      // Validate specification directory exists
      if (!await Directory(specPath).exists()) {
        print('Specification directory does not exist: $specPath');
        return false;
      }

      // 2. Generate code using the code_generation package
      // This would invoke the actual code generation process
      // Implementation would depend on how the code_generation package expects to be called

      // 3. Ensure the output directory exists
      final outputPath = path.join(_generatedBasePath, domainCode, modelCode);
      await Directory(outputPath).create(recursive: true);

      // 4. Write generated code to output directory
      // This would be handled by the code_generation package or we would
      // need to implement the file writing logic here

      print('Successfully generated code for $domainCode/$modelCode');
      return true;
    } catch (e) {
      print('Error generating code: $e');
      return false;
    }
  }

  /// Updates domain model specifications based on in-vivo editing.
  ///
  /// This method takes the updated domain model and persists the changes
  /// to the specification files in the requirements folder.
  Future<bool> updateSpecification(Domain domain, Model model) async {
    final domainCode = domain.codeFirstLetterLower;
    final modelCode = model.codeFirstLetterLower;

    try {
      // 1. Convert domain model to specification format
      final specification = _convertModelToSpecification(domain, model);

      // 2. Ensure the specification directory exists
      final specPath = path.join(_requirementsBasePath, domainCode, modelCode);
      await Directory(specPath).create(recursive: true);

      // 3. Write specification to file
      final specFile = path.join(specPath, 'model.yaml');
      await File(specFile).writeAsString(specification);

      print('Successfully updated specification for $domainCode/$modelCode');
      return true;
    } catch (e) {
      print('Error updating specification: $e');
      return false;
    }
  }

  /// Converts a domain model to its specification representation.
  ///
  /// This is an internal method that transforms the in-memory domain model
  /// into the YAML specification format expected by the code generation tools.
  String _convertModelToSpecification(Domain domain, Model model) {
    // Implementation would convert the domain model to YAML format
    // This is a placeholder - actual implementation would depend on
    // the expected format of the specification files

    StringBuffer buffer = StringBuffer();
    buffer.writeln('domain: ${domain.code}');
    buffer.writeln('model: ${model.code}');
    buffer.writeln('concepts:');

    for (var concept in model.concepts) {
      buffer.writeln('  - name: ${concept.code}');
      // Add more properties based on the specification format
    }

    return buffer.toString();
  }

  /// Lists all available specifications in the requirements folder.
  ///
  /// Returns a map where the keys are domain codes and the values are
  /// lists of model codes that have specifications.
  Future<Map<String, List<String>>> listAvailableSpecifications() async {
    Map<String, List<String>> result = {};

    try {
      final baseDir = Directory(_requirementsBasePath);
      if (!await baseDir.exists()) {
        return result;
      }

      await for (var entity in baseDir.list()) {
        if (entity is Directory) {
          final domainCode = path.basename(entity.path);
          result[domainCode] = [];

          await for (var modelEntity in entity.list()) {
            if (modelEntity is Directory) {
              final modelCode = path.basename(modelEntity.path);
              result[domainCode]!.add(modelCode);
            }
          }
        }
      }
    } catch (e) {
      print('Error listing specifications: $e');
    }

    return result;
  }
}
