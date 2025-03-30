import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> args) async {
  final scriptPath = Platform.script.toFilePath();
  final appDir = Directory(scriptPath).parent.parent;
  final appName = appDir.path.split(Platform.pathSeparator).last;
  print('The app calling me is $appName');

  final rootDir = Directory.current.path;
  final contentDir = Directory('content');
  // Create the content directory if it doesn't exist
  if (!contentDir.existsSync()) {
    contentDir.createSync();
    final exampleFile = File('$rootDir/content/example.ednet.yaml');
    final contentFile = File('${contentDir.path}/example.ednet.yaml');
    await exampleFile.copy(contentFile.path);
  }
  final p = path.join(rootDir, 'content/');
  final watcher = Watcher(p, pollingDelay: const Duration(milliseconds: 500));

  final debouncer = Debouncer<String>(
    duration: const Duration(milliseconds: 500),
  );

  // Listen to the debounced events
  debouncer.stream.listen((event) {
    if (event.endsWith('.ednet.yaml')) {
      print('Generated domain model for $event');
      // call your domain model generation function here
    }
  });

  await for (final event in watcher.events) {
    if (event.type == ChangeType.ADD ||
        event.type == ChangeType.MODIFY ||
        event.type == ChangeType.REMOVE) {
      final relativePath = path.relative(event.path, from: rootDir);

      final assetId = AssetId('ednet_cms', relativePath);

      if (assetId.path.contains('.ednet.yaml')) {
        final relativePath = path.relative(assetId.path, from: rootDir);
        debouncer.add(relativePath);
      }
    }
  }
}

class Debouncer<T> {
  final Duration duration;
  Timer? _timer;
  final StreamController<T> _controller;

  Debouncer({required this.duration})
    : _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  void add(T value) {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
    _timer = Timer(duration, () {
      _controller.add(value);
    });
  }

  void dispose() {
    _controller.close();
  }
}
