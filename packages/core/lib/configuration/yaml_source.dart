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
    } else {
      // await GitProcess.run(
      //   "clone",
      //   [remoteUrl],
      //   workingDirectory: ".",
      //   runInShell: true,
      // );
      // yamlPath = localPath;
    }
    return yamlPath;
  }
}
