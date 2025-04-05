import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:ednet_core/ednet_core.dart';

/// Manages drafts and versioning for domain models.
///
/// This class provides functionality to save, load, and manage draft versions
/// of domain models that are being edited. It ensures that no work is lost
/// due to application crashes or unexpected exits.
class DraftManager {
  final String _draftBasePath;
  final String _versionBasePath;

  /// Creates a new DraftManager with the specified environment.
  ///
  /// The [env] parameter specifies whether to use the staging or production environment.
  DraftManager({required String env})
    : _draftBasePath = 'packages/ednet_one_interpreter/lib/drafts/$env',
      _versionBasePath =
          'packages/ednet_one_interpreter/lib/requirements/$env/_versions';

  /// Saves a draft of the current domain model.
  ///
  /// This method stores the current state of the domain model being edited
  /// to the drafts folder, allowing recovery in case of application crashes.
  Future<bool> saveDraft(Domain domain, Model model) async {
    try {
      final domainCode = domain.codeFirstLetterLower;
      final modelCode = model.codeFirstLetterLower;
      final draftPath = path.join(_draftBasePath, domainCode, modelCode);

      // Ensure draft directory exists
      await Directory(draftPath).create(recursive: true);

      // Convert model to YAML specification and save
      final specification = _convertModelToSpecification(domain, model);
      final draftFile = path.join(draftPath, 'draft.yaml');
      await File(draftFile).writeAsString(specification);

      // Save metadata about the draft
      final metadataFile = path.join(draftPath, 'metadata.json');
      final metadata = {
        'timestamp': DateTime.now().toIso8601String(),
        'isDirty': true,
        'domainCode': domainCode,
        'modelCode': modelCode,
        'domainName': domain.description,
        'modelName': model.description,
      };
      await File(metadataFile).writeAsString(jsonEncode(metadata));

      return true;
    } catch (e) {
      print('Error saving draft: $e');
      return false;
    }
  }

  /// Loads a draft of a domain model.
  ///
  /// Returns the draft as a YAML string that can be parsed into a domain model.
  Future<String?> loadDraft(String domainCode, String modelCode) async {
    try {
      final draftFile = path.join(
        _draftBasePath,
        domainCode,
        modelCode,
        'draft.yaml',
      );
      if (await File(draftFile).exists()) {
        return await File(draftFile).readAsString();
      }
      return null;
    } catch (e) {
      print('Error loading draft: $e');
      return null;
    }
  }

  /// Checks if a draft exists for the specified domain and model.
  Future<bool> hasDraft(String domainCode, String modelCode) async {
    final draftFile = path.join(
      _draftBasePath,
      domainCode,
      modelCode,
      'draft.yaml',
    );
    return await File(draftFile).exists();
  }

  /// Gets metadata for a draft if it exists.
  Future<Map<String, dynamic>?> getDraftMetadata(
    String domainCode,
    String modelCode,
  ) async {
    try {
      final metadataFile = path.join(
        _draftBasePath,
        domainCode,
        modelCode,
        'metadata.json',
      );
      if (await File(metadataFile).exists()) {
        final content = await File(metadataFile).readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting draft metadata: $e');
      return null;
    }
  }

  /// Commits a draft to the main specification, creating a version.
  ///
  /// This method moves the draft to the main specification folder and
  /// creates a versioned copy in the versions folder for tracking history.
  Future<bool> commitDraft(String domainCode, String modelCode) async {
    try {
      final draftFile = path.join(
        _draftBasePath,
        domainCode,
        modelCode,
        'draft.yaml',
      );

      if (!await File(draftFile).exists()) {
        return false;
      }

      final draftContent = await File(draftFile).readAsString();

      // Create version in versions folder
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final versionPath = path.join(_versionBasePath, domainCode, modelCode);
      await Directory(versionPath).create(recursive: true);

      final versionFile = path.join(versionPath, 'model_$timestamp.yaml');
      await File(versionFile).writeAsString(draftContent);

      // Update main specification
      final specPath = path.join(
        'packages/ednet_one_interpreter/lib/requirements',
        domainCode,
        modelCode,
      );
      await Directory(specPath).create(recursive: true);

      final specFile = path.join(specPath, 'model.yaml');
      await File(specFile).writeAsString(draftContent);

      // Update draft metadata
      final metadataFile = path.join(
        _draftBasePath,
        domainCode,
        modelCode,
        'metadata.json',
      );
      if (await File(metadataFile).exists()) {
        final content = await File(metadataFile).readAsString();
        final metadata = jsonDecode(content) as Map<String, dynamic>;
        metadata['isDirty'] = false;
        metadata['lastCommit'] = DateTime.now().toIso8601String();
        await File(metadataFile).writeAsString(jsonEncode(metadata));
      }

      return true;
    } catch (e) {
      print('Error committing draft: $e');
      return false;
    }
  }

  /// Discards a draft.
  Future<bool> discardDraft(String domainCode, String modelCode) async {
    try {
      final draftPath = path.join(_draftBasePath, domainCode, modelCode);
      if (await Directory(draftPath).exists()) {
        await Directory(draftPath).delete(recursive: true);
      }
      return true;
    } catch (e) {
      print('Error discarding draft: $e');
      return false;
    }
  }

  /// Lists all available drafts.
  ///
  /// Returns a map where the keys are domain codes and the values are
  /// lists of model codes that have drafts.
  Future<Map<String, List<String>>> listAvailableDrafts() async {
    Map<String, List<String>> result = {};

    try {
      final baseDir = Directory(_draftBasePath);
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
              final draftFile = path.join(modelEntity.path, 'draft.yaml');

              if (await File(draftFile).exists()) {
                result[domainCode]!.add(modelCode);
              }
            }
          }

          // Remove empty domain entries
          if (result[domainCode]!.isEmpty) {
            result.remove(domainCode);
          }
        }
      }
    } catch (e) {
      print('Error listing drafts: $e');
    }

    return result;
  }

  /// Lists all available versions for a domain model.
  ///
  /// Returns a list of version timestamps that can be used to load
  /// specific versions of the domain model.
  Future<List<String>> listVersions(String domainCode, String modelCode) async {
    List<String> versions = [];

    try {
      final versionPath = path.join(_versionBasePath, domainCode, modelCode);
      final dir = Directory(versionPath);

      if (!await dir.exists()) {
        return versions;
      }

      await for (var entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.yaml')) {
          final filename = path.basename(entity.path);
          // Extract timestamp from filename (model_TIMESTAMP.yaml)
          final match = RegExp(r'model_(\d+)\.yaml').firstMatch(filename);
          if (match != null && match.groupCount >= 1) {
            versions.add(match.group(1)!);
          }
        }
      }

      // Sort versions by timestamp (newest first)
      versions.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    } catch (e) {
      print('Error listing versions: $e');
    }

    return versions;
  }

  /// Loads a specific version of a domain model.
  Future<String?> loadVersion(
    String domainCode,
    String modelCode,
    String versionTimestamp,
  ) async {
    try {
      final versionFile = path.join(
        _versionBasePath,
        domainCode,
        modelCode,
        'model_$versionTimestamp.yaml',
      );

      if (await File(versionFile).exists()) {
        return await File(versionFile).readAsString();
      }
      return null;
    } catch (e) {
      print('Error loading version: $e');
      return null;
    }
  }

  /// Converts a domain model to YAML specification format.
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
    buffer.writeln('description: "${model.description}"');
    buffer.writeln('concepts:');

    for (var concept in model.concepts) {
      buffer.writeln('  - name: ${concept.code}');
      buffer.writeln('    description: "${concept.description}"');
      // Add more properties based on the concept
    }

    return buffer.toString();
  }
}
