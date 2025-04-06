import 'dart:io';

/// A script to identify and fix unused imports in the presentation layer.
///
/// Usage:
/// ```
/// dart fix_unused_imports.dart [--dry-run] [--dir=<directory>]
/// ```
///
/// Options:
/// - `--dry-run`: Only report unused imports, don't make any changes
/// - `--dir`: Specify a subdirectory within presentation to scan (default: all)

void main(List<String> args) async {
  final dryRun = args.contains('--dry-run');
  String? targetDir;

  for (final arg in args) {
    if (arg.startsWith('--dir=')) {
      targetDir = arg.substring('--dir='.length);
    }
  }

  final baseDir = targetDir ?? '.';

  print('Scanning for unused imports in $baseDir...');

  // Run dart fix for the directory
  if (!dryRun) {
    final result = await Process.run('dart', [
      'fix',
      '--apply',
      baseDir,
    ], runInShell: true);

    if (result.exitCode == 0) {
      print('Successfully fixed imports in $baseDir');
      print(result.stdout);
    } else {
      print('Error running dart fix:');
      print(result.stderr);
    }
  } else {
    final result = await Process.run('dart', [
      'fix',
      '--dry-run',
      baseDir,
    ], runInShell: true);

    print('Dry run - no changes made:');
    print(result.stdout);
  }

  // Run analyzer to find remaining issues
  final analyzerResult = await Process.run('dart', [
    'analyze',
    baseDir,
  ], runInShell: true);

  print('\nRemaining analyzer issues:');
  print(analyzerResult.stdout);
}
