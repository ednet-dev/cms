import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml_edit/yaml_edit.dart';

void main(List<String> args) => grind(args);

@Task('Increment version')
void incrementVersion() {
  final incrementType =
      context.invocation.arguments.getOption('version') ?? 'patch';
  const validTypes = ['major', 'minor', 'patch', 'build'];
  print('Incrementing version with type: $incrementType');
  if (!validTypes.contains(incrementType)) {
    fail(
      'Invalid version increment type: $incrementType. Must be one of $validTypes.',
    );
  }

  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    fail('pubspec.yaml not found.');
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final yamlEditor = YamlEditor(pubspecContent);
  final currentVersionString = yamlEditor.parseAt(['version']).value ?? 'patch';
  final currentVersion = Version.parse(currentVersionString as String);

  Version newVersion;
  switch (incrementType) {
    case 'major':
      newVersion = currentVersion.nextMajor;
      break;
    case 'minor':
      newVersion = currentVersion.nextMinor;
      break;
    case 'patch':
      newVersion = currentVersion.nextPatch;
      break;
    case 'build':
      final buildNumber = currentVersion.build.isEmpty
          ? 1
          : int.parse(currentVersion.build.first.toString()) + 1;
      newVersion = Version(
        currentVersion.major,
        currentVersion.minor,
        currentVersion.patch,
        build: buildNumber.toString(),
      );
      break;
    default:
      fail('Unsupported increment type: $incrementType');
  }

  yamlEditor.update(['version'], newVersion.toString());
  pubspecFile.writeAsStringSync(yamlEditor.toString());
  print('Version updated to: $newVersion');

  final versionFile = File('lib/src/version.dart');
  if (!versionFile.existsSync()) {
    fail('lib/src/version.dart not found.');
  }
  versionFile.writeAsStringSync("const String kVersion = '$newVersion';\n");
}

@Task('Fetch dependencies')
void getDependencies() {
  run('dart', arguments: ['pub', 'get']);
}

@Task('Clean build artifacts')
void clean() {
  run('dart', arguments: ['run', 'build_runner', 'clean']);
}

@Task('Build with build_runner')
@Depends(getDependencies)
void buildRunner() {
  run(
    'dart',
    arguments: [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
  );
}

@Task('Compile apdf executable')
@Depends(buildRunner)
void compile() {
  run('dart', arguments: ['compile', 'exe', 'bin/apdf.dart', '-o', 'bin/apdf']);
  if (Platform.isLinux || Platform.isMacOS) {
    run('chmod', arguments: ['+x', 'bin/apdf']);
  }
}

@Task('Copy executable to pub cache')
@Depends(compile)
void copyToPubCache() {
  final homeDir = Platform.environment['HOME'] ??
      fail('HOME environment variable not set.');
  final pubCacheBin = Directory('$homeDir/.pub-cache/bin');
  if (!pubCacheBin.existsSync()) {
    pubCacheBin.createSync(recursive: true);
  }
  copy(File('bin/apdf'), pubCacheBin);
}

@DefaultTask('Increment version, clean, build, compile, and deploy')
@Depends(incrementVersion, clean, copyToPubCache)
void build() {}
