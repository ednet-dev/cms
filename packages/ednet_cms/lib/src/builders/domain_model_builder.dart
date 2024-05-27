import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

class DomainModelBuilder implements Builder {
  static int buildNumber = 0;

  @override
  Future<void> build(BuildStep buildStep) async {
    buildNumber++;

    // Log the input file for debugging
    log.warning('Processing ${buildStep.inputId.path}');

    final content = '''
// Generated code - Do not modify by hand
void main() {
  print('Hello, world! Build number: $buildNumber');
}
''';

    final outputDir = Directory('lib/generated');
    final outputFile =
        File(p.join(outputDir.path, 'domain_model_builder.dart'));

    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    await outputFile.writeAsString(content);

    log.info(
        'Generated domain_model_builder.dart with build number: $buildNumber');
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.yaml': ['.dart']
      };
}

Builder domainModelBuilder(BuilderOptions options) => DomainModelBuilder();
