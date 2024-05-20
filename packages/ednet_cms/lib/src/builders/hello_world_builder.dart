import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

class HelloWorldBuilder implements Builder {
  static int buildNumber = 0;

  @override
  Future<void> build(BuildStep buildStep) async {
    buildNumber++;

    // Log the input file for debugging
    log.info('Processing ${buildStep.inputId.path}');

    final content = '''
// Generated code - Do not modify by hand
void main() {
  print('Hello, world! Build number: $buildNumber');
}
''';

    final outputDir = Directory('lib/generated');
    final outputFile = File(p.join(outputDir.path, 'hello_world.dart'));

    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    await outputFile.writeAsString(content);

    log.info('Generated hello_world.dart with build number: $buildNumber');
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.yaml': ['.dart']
      };
}

Builder helloWorldBuilder(BuilderOptions options) => HelloWorldBuilder();
