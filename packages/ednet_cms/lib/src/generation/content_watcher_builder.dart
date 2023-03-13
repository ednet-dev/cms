part of ednet_cms;

class ContentWatcherBuilder implements Builder {
  late String rootDir;
  late String contentDir;

  ContentWatcherBuilder();

  @override
  Map<String, List<String>> get buildExtensions => {
    '.ednet.yaml': ['_ednet.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    print('AAAAAAAAAAa');
    print('AAAAAAAAAAa');
    // Only run the CmsBuilder if the changed file is in the content directory
    final inputId = buildStep.inputId;
    final inputPath = inputId.path;
    final contentGlob = Glob('$rootDir/$contentDir/**');
    final isInContentDir = contentGlob.matches(inputPath);
    if (isInContentDir) {
      final builder = CmsBuilder();

      final outputId = AssetId(
          inputId.package,
          'lib/src/domain/${_toCamelCase(inputId.changeExtension('.g.dart').pathSegments.last)}');

      // final buildStepBuilder = BuildStepBuilder([inputId], [outputId],
      //         (buildStep) => builder.build(buildStep));
      // final buildStep = await buildStepBuilder.createBuildStep(buildStep);
      // await builder.build(buildStep);
    }
  }

  String _toCamelCase(String input) {
    final parts = input.split('_');
    return parts.first + parts.skip(1).map((part) => part.capitalize()).join('');
  }
}

extension CapExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
