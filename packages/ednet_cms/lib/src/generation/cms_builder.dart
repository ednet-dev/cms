part of ednet_cms;

class CmsBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.yaml': ['_cms.g.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!buildStep.inputId.path.endsWith('.ednet.yaml')) {
      EDNetCodeGenerator.generate(
        sourceDir: buildStep.inputId.path,
        targetDir: 'ha ha',
        domainName: ' buildStep.domainName',
        models: ' buildStep.models',
      );
      return;
    }
    // Check if content directory exists
    final contentDir = Directory('content');
    if (!await contentDir.exists()) {
      // Create content directory
      await contentDir.create();
      // Create example.ednet.yaml file
      final file = await File('content/example.ednet.yaml').create();
      await file.writeAsString('example content');
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

  Future<List<File>> _listFiles(Directory dir) async {
    final completer = Completer<List<File>>();
    final files = <File>[];

    void search(Directory dir) {
      dir.list(recursive: false).listen((entity) {
        if (entity is File) {
          files.add(entity);
        } else if (entity is Directory) {
          search(entity);
        }
      }, onDone: () => completer.complete(files));
    }

    search(dir);

    return completer.future;
  }
}
