part of ednet_cms;

class ContentWatcherBuilder implements builder.Builder {
  String rootDir = 'lib';
  String contentDir = 'content';

  ContentWatcherBuilder();

  @override
  Map<String, List<String>> get buildExtensions => {
        '.ednet.yaml': ['_ednet.g.dart'],
      };

  @override
  Future<void> build(builder.BuildStep buildStep) async {
    // Only run the CmsBuilder if the changed file is in the content directory
    final inputId = buildStep.inputId;
    final inputPath = inputId.path;

    // final rootDir = await _getRootDir(buildStep);

    final contentGlob = Glob('$rootDir/$contentDir/**');
    final isInContentDir = contentGlob.matches(inputPath);
    if (isInContentDir) {
      final outputId = builder.AssetId(inputId.package,
          'lib/src/domain/${_toCamelCase(inputId.changeExtension('.g.dart').pathSegments.last)}');
      final rootDir = '${buildStep.inputId.package}/lib';
      final contentDir = '$rootDir/content';

      // Create the content directory if it does not exist
      final contentDirExists = await Directory(contentDir).exists();
      if (!contentDirExists) {
        await Directory(contentDir).create(recursive: true);
      }

      // Read the contents of the YAML file
      final yamlFile = File(inputPath);
      final yamlContent = await yamlFile.readAsString();
      print('AAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAaAAAAAAAAAAa');

      // Parse the YAML content
      // final yamlMap = loadYaml(yamlContent);

      // Generate the domain model code
      // final generator = EdnetCodeGenerator();
      // final generatedCode = generator.generate(yamlMap);

      // Write the generated code to a file
      final domainDir = '$rootDir/src/domain';
      final domainFile = File('$domainDir/domain_model.dart');
      // await domainFile.writeAsString(generatedCode);
    }
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
