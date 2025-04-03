// part of ednet_core;
//
// /// Configuration source that reads from YAML files.
// class YamlSource {
//   /// Default local directory name where the YAML file is expected to be located.
//   final String localPath = "domain_model_definition";
//
//   /// An external GitHub repository URL pointing to a sample or remote version of the YAML-based domain configuration files.
//   final String remoteUrl =
//       "https://github.com/context-dev/example-configuration-domain.git";
//
//   /// Reads configuration from a YAML file.
//   ///
//   /// Parameters:
//   /// - [path]: The path to the YAML file
//   ///
//   /// Returns:
//   /// A Map containing the parsed YAML configuration
//   ///
//   /// Throws:
//   /// - [FileSystemException] if the file cannot be read
//   /// - [YamlException] if the YAML content is invalid
//   Map<String, dynamic> readFromFile(String path) {
//     final file = File(path);
//     if (!file.existsSync()) {
//       throw FileSystemException('YAML file not found at path: $path');
//     }
//
//     try {
//       final content = file.readAsStringSync();
//       final yaml = loadYaml(content);
//       return _convertYamlToMap(yaml);
//     } catch (e) {
//       throw YamlException('Failed to parse YAML file: $e');
//     }
//   }
//
//   /// Converts a YAML document to a Dart Map.
//   ///
//   /// Parameters:
//   /// - [yaml]: The YAML document to convert
//   ///
//   /// Returns:
//   /// A Map containing the converted YAML data
//   Map<String, dynamic> _convertYamlToMap(dynamic yaml) {
//     if (yaml is YamlMap) {
//       final result = <String, dynamic>{};
//       for (final key in yaml.keys) {
//         result[key.toString()] = _convertYamlToMap(yaml[key]);
//       }
//       return result;
//     } else if (yaml is YamlList) {
//       return {'list': yaml.map((item) => _convertYamlToMap(item)).toList()};
//     } else {
//       return {'value': yaml};
//     }
//   }
//
//   /// Attempts to locate the YAML definition file in the local path.
//   ///
//   /// Returns:
//   /// The file path where the YAML configuration is located
//   ///
//   /// Throws:
//   /// - [FileSystemException] when the expected local directory does not exist
//   Future<String> getYamlPath() async {
//     String yamlPath = localPath;
//     var exists = await Directory(localPath).exists();
//     if (exists) {
//       yamlPath = localPath;
//       return yamlPath;
//     }
//
//     throw FileSystemException('YAML file not found in local path');
//   }
// }
