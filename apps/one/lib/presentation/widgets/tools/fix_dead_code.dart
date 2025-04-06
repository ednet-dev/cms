import 'dart:io';

/// A script to identify and fix dead code in service classes.
///
/// This script will:
/// 1. Find dead code warnings in service classes
/// 2. Fix them by commenting out the unreachable code
///
/// Usage:
/// ```
/// dart fix_dead_code.dart [--dry-run] [--dir=<directory>]
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
  final serviceDir = '$baseDir/state/providers';

  print('Scanning for dead code in service classes in $serviceDir...');

  // First run analyzer to identify the issues
  final analyzerResult = await Process.run('dart', [
    'analyze',
    serviceDir,
  ], runInShell: true);

  // Parse result to find dead code warnings
  final output = analyzerResult.stdout.toString();
  final lines = output.split('\n');

  final deadCodeWarnings = <String, List<DeadCodeWarning>>{};

  for (final line in lines) {
    if (line.contains('dead_code') &&
        line.contains('Dead code. Try removing the code')) {
      // Format: file:line:column • Dead code. Try removing the code...
      final parts = line.split(' • ');
      if (parts.length >= 2) {
        final locationParts = parts[0].split(':');
        if (locationParts.length >= 3) {
          final file = locationParts[0].trim();
          final lineNum = int.tryParse(locationParts[1].trim());

          if (lineNum != null) {
            final warning = DeadCodeWarning(lineNum);
            deadCodeWarnings.putIfAbsent(file, () => []);
            deadCodeWarnings[file]!.add(warning);
          }
        }
      }
    }
  }

  if (deadCodeWarnings.isEmpty) {
    print('No dead code warnings found!');
    return;
  }

  print('\nFound ${deadCodeWarnings.length} files with dead code warnings:');
  for (final entry in deadCodeWarnings.entries) {
    print('- ${entry.key}: ${entry.value.length} instances');
  }

  int fixedCount = 0;

  if (!dryRun) {
    for (final entry in deadCodeWarnings.entries) {
      final file = entry.key;
      final warnings = entry.value;

      print('\nFixing dead code warnings in $file:');
      final count = await fixDeadCodeWarnings(file, warnings);
      fixedCount += count;
    }

    print('\nFixed $fixedCount dead code warnings');

    // Run analyzer again to check if warnings are resolved
    print('\nRunning analyzer to check for remaining issues...');
    final checkResult = await Process.run('dart', [
      'analyze',
      serviceDir,
    ], runInShell: true);

    print(checkResult.stdout);
    if (checkResult.exitCode != 0) {
      print('Warning: There are still analyzer issues to fix.');
    }
  } else {
    print('\nDry run completed. Would fix:');
    print(
      '- ${deadCodeWarnings.values.expand((e) => e).length} dead code warnings',
    );
  }
}

/// Fixes dead code warnings by commenting out the unreachable code blocks
Future<int> fixDeadCodeWarnings(
  String filePath,
  List<DeadCodeWarning> warnings,
) async {
  final file = File(filePath);
  if (!await file.exists()) {
    print('  Error: File $filePath does not exist');
    return 0;
  }

  final content = await file.readAsString();
  final lines = content.split('\n');

  // Sort warnings by line number to process from beginning to end
  warnings.sort((a, b) => a.lineNumber.compareTo(b.lineNumber));

  int fixedCount = 0;

  for (final warning in warnings) {
    final lineNum = warning.lineNumber;
    if (lineNum <= 0 || lineNum >= lines.length) {
      continue;
    }

    // For dead code, we need to identify the entire block to comment out
    int startLine = lineNum - 1;
    int endLine = startLine;
    int bracesCount = 0;

    // Find start of the block (might be an if statement with condition always false)
    while (startLine > 0) {
      final line = lines[startLine].trim();
      if (line.contains('if (') &&
          line.contains('false') &&
          line.endsWith('{')) {
        // Found an if (false) statement, this is likely our dead code
        break;
      }
      startLine--;
    }

    // Find end of the block (matching closing brace)
    for (int i = startLine; i < lines.length; i++) {
      final line = lines[i].trim();
      bracesCount += line.split('{').length - 1;
      bracesCount -= line.split('}').length - 1;

      if (bracesCount <= 0 && i > startLine) {
        endLine = i;
        break;
      }
    }

    // Comment out the dead code block
    for (int i = startLine; i <= endLine; i++) {
      if (!lines[i].trim().startsWith('//')) {
        lines[i] = '// DEAD CODE: ${lines[i]}';
      }
    }

    print('  Commented out dead code block at lines $startLine-$endLine');
    fixedCount++;
  }

  if (fixedCount > 0) {
    await file.writeAsString(lines.join('\n'));
  }

  return fixedCount;
}

/// Model for a dead code warning
class DeadCodeWarning {
  final int lineNumber;

  DeadCodeWarning(this.lineNumber);
}
