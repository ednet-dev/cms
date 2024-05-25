import 'dart:io';

import 'package:args/args.dart';
import 'package:ednet_code_generation/ednet_code_generation.dart';
// import 'package:ednet_code_generation/ednet_code_generation.dart';

// import 'package:ednet_cms/build_ednet_cms.dart';
// import 'package:path/path.dart' as path;
import 'package:watcher/watcher.dart';
// import 'package:

/// Builds a EDNetCore domain model from EDNetDSL YAML files.
///
/// The [yamlDir] argument specifies the directory containing the YAML files
/// that define the domain model. The [outputDir] argument specifies the
/// directory where the generated Dart files should be placed. The [name] argument
/// specifies the name of the domain model, which is used to generate class names
/// and file names.
///
/// If the [watch] flag is set to `true`, the script will watch the YAML directory
/// for changes and automatically rebuild the domain model when changes are detected.
///
/// This function returns a [Future] that completes when the initial build is finished.
void main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption('input', abbr: 'i', defaultsTo: '../domain');
  parser.addOption('output', abbr: 'o', defaultsTo: '../../output');
  parser.addOption('domain', abbr: 'd', defaultsTo: 'ednet');
  parser.addOption('models', abbr: 'm', defaultsTo: 'all');
  parser.addFlag('watch', abbr: 'w', negatable: false);

  final options = parser.parse(args);
  final inputPath = options['input'];
  final outputPath = options['output'];
  final domainName = options['domain'];
  // final models = options['models'];
  String model = options['models'];
  final rest = options.rest;
  final models = [model, ...rest];

  // final builder = EDNetCodeGenerator(
  //   domainPath: inputPath,
  //   outputPath: outputPath,
  //   domainName: domainName,
  //   models: models,
  // );

  var name = options['domain'];

  print('Building $name domain model...');
// --genall inputPath outputPath domainName models.join(' ')
  print('Current working directory: ${Directory.current.path}');
  // final resultLL = await Process.run('ls', ['-alF']);
  final dartExecutable = Platform.resolvedExecutable;
  //
  // final resultLd = await Process.run(
  //   dartExecutable,
  //   [
  //     'pub',
  //     'global',
  //     'run',
  //     'ednet_code_generation',
  //   ],
  //   // workingDirectory: Directory.current.path,
  //   // runInShell: true,
  // );

  final result = await Process.run(
      dartExecutable,
      [
        'pub',
        'global',
        'run',
        'ednet_code_generation',
        '--genall',
        inputPath,
        outputPath,
        domainName,
        ...models,
      ],
      workingDirectory: Directory.current.path);

  print(result);

  final domainModel = dartlingCodegen(
    path: inputPath,
    domain: name,
    out: outputPath,
  );
  print('Generated ${domainModel.context.className}.dart');
  print('Generated ${domainModel.context.entryPoint}.dart');
  print('Generated ${domainModel.context.modelLibrary}.dart');

  if (options['watch']) {
    print('Watching for changes...');
    final watcher = DirectoryWatcher(options['domain']);
    watcher.events.listen((event) {
      print('Changes detected. Rebuilding...');
      // builder.generateAll();
      print('Done.');
    });
  } else {
    // builder.generateAll();
  }
}

// class EDNetCodeGenerator {
//   var domainPath;
//
//   var outputPath;
//
//   var domainName;
//
//   var models;
//
//   EDNetCodeGenerator({
//     this.domainPath,
//     this.outputPath,
//     this.domainName,
//     this.models,
//   });
//
//   get name => 'EDNet' + domainName;
//
//   void generateAll() {
//     print('I am generating $name domain model...');
//   }
// }

/// Builds a dartling domain model from YAML files.
///
/// The [yamlDir] argument specifies the directory containing the YAML files
/// that define the domain model. The [outputDir] argument specifies the
/// directory where the generated Dart files should be placed. The [name] argument
/// specifies the name of the domain model, which is used to generate class names
/// and file names.
///
/// If the [watch] flag is set to `true`, the script will watch the YAML directory
/// for changes and automatically rebuild the domain model when changes are detected.
///
/// This function returns a [Future] that completes when the initial build is finished.
Future<void> buildDomainModel(
  String yamlDir,
  String outputDir,
  String name, {
  bool watch = false,
}) async {
  print('Building $name domain model...');
  final domainModel = await dartlingCodegen(
    path: yamlDir,
    domain: name,
    out: outputDir,
  );
  print('Generated ${domainModel.context.className}.dart');
  print('Generated ${domainModel.context.entryPoint}.dart');
  print('Generated ${domainModel.context.modelLibrary}.dart');

  if (watch) {
    print('Watching for changes in $yamlDir...');
    final watcher = DirectoryWatcher(yamlDir);
    watcher.events.listen((event) async {
      print(
          'Detected change in ${event.path}. Rebuilding $name domain model...');
      await dartlingCodegen(
        path: yamlDir,
        domain: name,
        out: outputDir,
      );
      print('Generated ${domainModel.context.className}.dart');
      print('Generated ${domainModel.context.entryPoint}.dart');
      print('Generated ${domainModel.context.modelLibrary}.dart');
      print('Watching for changes in $yamlDir...');
    });
  }
}

dartlingCodegen(
    {required String path, required String domain, required String out}) {}
