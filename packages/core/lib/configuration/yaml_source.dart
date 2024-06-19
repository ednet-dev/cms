import 'dart:io';

class YamlSource {
  final String localPath = "domain_model_definition";
  final String remoteUrl =
      "https://github.com/context-dev/example-configuration-domain.git";

  Future<String> getYamlPath() async {
    String yamlPath = localPath;
    var exists = await Directory(localPath).exists();
    if (exists) {
      yamlPath = localPath;

      return yamlPath;
    }

    throw FileSystemException('Yaml file not found in local path');
  }
}
