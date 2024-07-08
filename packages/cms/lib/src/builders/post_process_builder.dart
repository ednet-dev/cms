import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

class PostProcessBuilder implements Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    // This builder does not generate any files on its own.
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$lib$': ['_post_process']
      };
}

Future<void> runPubGetInGeneratedDirs(String rootDir) async {
  // log hello world
  log.info('Running pub get in generated directories');
  final generatedDir = Directory(rootDir);
  final subDirs = generatedDir
      .listSync(recursive: true, followLinks: false)
      .where((entity) => entity is Directory);

  for (var dir in subDirs) {
    final path = dir.path;
    if (await File(p.join(path, 'pubspec.yaml')).exists()) {
      final result =
          await Process.run('dart', ['pub', 'get'], workingDirectory: path);
      if (result.exitCode != 0) {
        log.severe('Failed to run dart pub get in $path: ${result.stderr}');
        throw Exception('dart pub get failed');
      }
    }
  }
}

Builder postProcessBuilder(BuilderOptions options) => PostProcessBuilder();
