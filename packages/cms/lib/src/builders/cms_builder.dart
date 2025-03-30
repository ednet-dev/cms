import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:ednet_code_generation/ednet_code_generation.dart';

class CmsBuilder implements Builder {
  String rootDir = 'lib';
  String contentDir = 'requirements';

  @override
  Map<String, List<String>> get buildExtensions => {
    '.ednet.yaml': ['_cms.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    log.warning('FROM CMS BUILDER ${buildStep.inputId.path}');

    if (buildStep.inputId.path.endsWith('.ednet.yaml')) {
      log.warning('FROM CMS BUILDER Processing ${buildStep.inputId.path}');
      EDNetCodeGenerator.generate(
        sourceDir: buildStep.inputId.path,
        targetDir: 'ha ha',
        domainName: ' buildStep.domainName',
        models: ' buildStep.models',
      );
      return;
    }
    // Check if content directory exists
    final contentDir = Directory(this.contentDir);
    if (!await contentDir.exists()) {
      // Create content directory
      await contentDir.create();
      // Create example.ednet.yaml file
      final file = await File('${this.contentDir}/example.ednet.yaml').create();
      await file.writeAsString('domain: Some example domain model');
    } else {
      // List all files in the content directory
      await for (var file in contentDir.list(recursive: true)) {
        // Do something with the file
        print(file.path);
      }
    }

    // final rootDir = Directory(buildStep.inputId.package);
    // final contentDir = Directory('${rootDir.path}/content');
    // final contentDirAsset = AssetId(buildStep.inputId.package, contentDir.path);
    //
    // // Check if the "content" directory exists in the root directory of the client app.
    // if (!(await buildStep.canRead(contentDirAsset))) {
    //   // If the "content" directory does not exist, create it.
    //   await buildStep.digest(AssetId(buildStep.inputId.package, 'content/'));
    // }
    //
    // // Check if the "example.ednet.yaml" file exists in the "content" directory.
    // final exampleId = AssetId(buildStep.inputId.package, 'content/example.ednet.yaml');
    // if (!(await buildStep.canRead(exampleId))) {
    //   // If the "example.ednet.yaml" file does not exist, copy it from the root directory of ednet_cms.
    //   // final ednetCmsRootDir = Directory(p.absolute(p.dirname(p.fromUri(Platform.script)), '..'));
    //   final ednetCmsExampleId = AssetId('ednet_cms', 'example.ednet.yaml');
    //   final contents = await buildStep.readAsString(ednetCmsExampleId);
    //   await buildStep.writeAsString(exampleId, contents);
    // }
    //
    //
    // if (await contentDir.exists()) {
    //   final files = await _listFiles(contentDir);
    //   for (final file in files) {
    //     print(file.path);
    //   }
    // } else {
    //   await contentDir.create(recursive: true);
    //   final exampleFile = File('${contentDir.path}/example.ednet.yaml');
    //   await exampleFile.writeAsString('example');
    // }
  }
}

Builder cmsBuilder(BuilderOptions options) => CmsBuilder();
