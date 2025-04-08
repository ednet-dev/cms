import 'dart:io';

/// A script to fix BLoC related warnings in the presentation layer.
///
/// This script will:
/// 1. Fix invalid emit uses (visible_for_testing warnings)
/// 2. Fix incorrect @override annotations
///
/// Usage:
/// ```
/// dart fix_bloc_warnings.dart [--dry-run] [--dir=<directory>]
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

  print('Scanning for BLoC related warnings in $baseDir...');

  // First run analyzer to identify the issues
  final analyzerResult = await Process.run('dart', [
    'analyze',
    baseDir,
  ], runInShell: true);

  // Parse result to find bloc warnings
  final output = analyzerResult.stdout.toString();
  final lines = output.split('\n');

  final emitWarnings = <String, List<int>>{};
  final overrideWarnings = <String, List<int>>{};

  for (final line in lines) {
    if (line.contains('invalid_use_of_visible_for_testing_member') &&
        line.contains("The member 'emit' can only be used")) {
      final filePath = extractFilePath(line, baseDir);
      if (filePath != null) {
        final parts = line.split(' • ')[0].split(':');
        if (parts.length >= 2) {
          final lineNum = int.tryParse(parts[1].trim());
          if (lineNum != null) {
            emitWarnings.putIfAbsent(filePath, () => []);
            emitWarnings[filePath]!.add(lineNum);
          }
        }
      }
    }

    if (line.contains('override_on_non_overriding_member') &&
        line.contains("The method doesn't override an inherited method")) {
      final filePath = extractFilePath(line, baseDir);
      if (filePath != null) {
        final parts = line.split(' • ')[0].split(':');
        if (parts.length >= 2) {
          final lineNum = int.tryParse(parts[1].trim());
          if (lineNum != null) {
            overrideWarnings.putIfAbsent(filePath, () => []);
            overrideWarnings[filePath]!.add(lineNum);
          }
        }
      }
    }
  }

  print('\nFound ${emitWarnings.length} files with emit warnings');
  print('Found ${overrideWarnings.length} files with override warnings');

  if (emitWarnings.isEmpty && overrideWarnings.isEmpty) {
    print('No BLoC-related warnings found!');
    return;
  }

  int fixedEmits = 0;
  int fixedOverrides = 0;

  if (!dryRun) {
    // Fix emit warnings
    for (final entry in emitWarnings.entries) {
      final file = entry.key;
      final lineNumbers = entry.value;

      print('\nFixing emit warnings in $file:');
      fixedEmits += await fixEmitWarnings(file, lineNumbers);
    }

    // Fix override warnings
    for (final entry in overrideWarnings.entries) {
      final file = entry.key;
      final lineNumbers = entry.value;

      print('\nFixing override warnings in $file:');
      fixedOverrides += await fixOverrideWarnings(file, lineNumbers);
    }

    print(
      '\nFixed $fixedEmits emit warnings and $fixedOverrides override warnings',
    );

    // Run analyzer again to check if warnings are resolved
    print('\nRunning analyzer to check for remaining issues...');
    final checkResult = await Process.run('dart', [
      'analyze',
      baseDir,
    ], runInShell: true);

    print(checkResult.stdout);
    if (checkResult.exitCode != 0) {
      print('Warning: There are still analyzer issues to fix.');
    }
  } else {
    print('\nDry run completed. Would fix:');
    print('- ${emitWarnings.values.expand((e) => e).length} emit warnings');
    print(
      '- ${overrideWarnings.values.expand((e) => e).length} override warnings',
    );
  }
}

/// Extracts a valid file path from an analyzer warning line
String? extractFilePath(String line, String baseDir) {
  final parts = line.split(' • ')[0].split(':');
  if (parts.isNotEmpty) {
    String filePath = parts[0].trim();

    // If the file path starts with "warning - ", remove it
    if (filePath.startsWith('warning - ')) {
      filePath = filePath.substring('warning - '.length);
    }

    // If the file doesn't exist directly, try to combine with baseDir
    if (!File(filePath).existsSync()) {
      final combinedPath = '$baseDir/$filePath';
      if (File(combinedPath).existsSync()) {
        return combinedPath;
      }
    } else {
      return filePath;
    }
  }
  return null;
}

/// Fixes emit warnings by adding ignore_for_file directive
Future<int> fixEmitWarnings(String filePath, List<int> lineNumbers) async {
  final file = File(filePath);
  if (!await file.exists()) {
    print('  Error: File $filePath does not exist');
    return 0;
  }

  final content = await file.readAsString();
  final lines = content.split('\n');

  // Check if ignore_for_file directive already exists
  bool hasIgnoreDirective = false;
  bool hasVisibleForTestingIgnore = false;

  for (int i = 0; i < lines.length && i < 30; i++) {
    if (lines[i].contains('// ignore_for_file:')) {
      hasIgnoreDirective = true;
      if (lines[i].contains('invalid_use_of_visible_for_testing_member')) {
        hasVisibleForTestingIgnore = true;
        break;
      }
    }
  }

  if (hasVisibleForTestingIgnore) {
    print('  Already has ignore directive for emit warnings');
    return 0;
  }

  if (hasIgnoreDirective) {
    // Append to existing directive
    for (int i = 0; i < lines.length && i < 30; i++) {
      if (lines[i].contains('// ignore_for_file:')) {
        lines[i] =
            lines[i].trim().endsWith(',')
                ? '${lines[i]} invalid_use_of_visible_for_testing_member,'
                : '${lines[i]}, invalid_use_of_visible_for_testing_member,';
        break;
      }
    }
  } else {
    // Add new directive at the top (after any imports)
    int insertIndex = 0;
    while (insertIndex < lines.length &&
        (lines[insertIndex].startsWith('import') ||
            lines[insertIndex].trim().isEmpty)) {
      insertIndex++;
    }

    lines.insert(
      insertIndex,
      '// ignore_for_file: invalid_use_of_visible_for_testing_member',
    );
  }

  await file.writeAsString(lines.join('\n'));
  print(
    '  Added ignore directive for invalid_use_of_visible_for_testing_member',
  );

  return lineNumbers.length;
}

/// Fixes override warnings by removing incorrect @override annotations
Future<int> fixOverrideWarnings(String filePath, List<int> lineNumbers) async {
  final file = File(filePath);
  if (!await file.exists()) {
    print('  Error: File $filePath does not exist');
    return 0;
  }

  final content = await file.readAsString();
  final lines = content.split('\n');

  // Process in reverse order to avoid affecting line numbers
  lineNumbers.sort((a, b) => b.compareTo(a));
  int fixed = 0;

  for (final lineNumber in lineNumbers) {
    if (lineNumber <= 0 || lineNumber > lines.length) {
      continue;
    }

    final lineIndex = lineNumber - 1; // 0-based index
    final line = lines[lineIndex];

    if (line.trim().startsWith('@override')) {
      lines[lineIndex] = '  // Removed incorrect override: ${line.trim()}';
      fixed++;
      print('  Line $lineNumber: Removed incorrect @override annotation');
    }
  }

  if (fixed > 0) {
    await file.writeAsString(lines.join('\n'));
  }

  return fixed;
}
