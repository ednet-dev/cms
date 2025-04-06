import 'dart:io';

/// A script to update deprecated withOpacity calls to use withValues.
///
/// This script will:
/// 1. Find all withOpacity calls in the codebase
/// 2. Replace them with withValues calls
///
/// Usage:
/// ```
/// dart fix_opacity_api.dart [--dry-run] [--dir=<directory>]
/// ```
///
/// Options:
/// - `--dry-run`: Only report issues, don't make any changes
/// - `--dir`: Specify a subdirectory to scan (default: current directory)

void main(List<String> args) async {
  final dryRun = args.contains('--dry-run');
  String? targetDir;

  for (final arg in args) {
    if (arg.startsWith('--dir=')) {
      targetDir = arg.substring('--dir='.length);
    }
  }

  final baseDir = targetDir ?? '.';

  print('Scanning for withOpacity calls in $baseDir...');

  // Process files
  final dir = Directory(baseDir);
  if (!await dir.exists()) {
    print('Error: Directory $baseDir does not exist');
    return;
  }

  int totalReplacements = 0;

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('.dart') &&
        !entity.path.contains('/tools/')) {
      final replacementCount = await processFile(entity.path, dryRun);
      totalReplacements += replacementCount;
    }
  }

  if (dryRun) {
    print(
      '\nDry run completed. Found $totalReplacements potential replacements.',
    );
  } else {
    print('\nCompleted. Made $totalReplacements replacements.');
  }

  // Run analyzer after making changes
  if (!dryRun && totalReplacements > 0) {
    print('\nRunning analyzer to check for issues...');
    final result = await Process.run('dart', [
      'analyze',
      baseDir,
    ], runInShell: true);

    print(result.stdout);
    if (result.exitCode != 0) {
      print('Warning: There are still analyzer issues to fix.');
    }
  }
}

Future<int> processFile(String filePath, bool dryRun) async {
  final file = File(filePath);
  final content = await file.readAsString();

  // Pattern to match withOpacity calls
  // This handles both forms:
  // - color.withOpacity(0.5)
  // - Theme.of(context).primaryColor.withOpacity(0.5)
  final pattern = RegExp(r'(\.withOpacity\()([\d\.]+)(\))');

  final matches = pattern.allMatches(content).toList();
  if (matches.isEmpty) {
    return 0;
  }

  print('\n$filePath:');
  print('  Found ${matches.length} instances of withOpacity');

  if (dryRun) {
    return matches.length;
  }

  // Replace withOpacity with withValues
  String newContent = content;
  for (final match in matches) {
    final fullMatch = match.group(0)!;
    final opacity = match.group(2)!;

    // Create the withValues replacement
    // Instead of color.withOpacity(0.5), we use color.withValues(alpha: 255 * 0.5)
    // Note: No rounding, as alpha expects a double, not an int
    final replacement = '.withValues(alpha: 255.0 * $opacity)';

    newContent = newContent.replaceFirst(fullMatch, replacement);
  }

  if (newContent != content) {
    await file.writeAsString(newContent);
    print('  Updated file with ${matches.length} replacements');
  }

  return matches.length;
}
