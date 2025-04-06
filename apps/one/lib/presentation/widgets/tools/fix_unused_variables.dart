import 'dart:io';

/// A script to identify and remove unused variables in the presentation layer.
///
/// This script will:
/// 1. Find files with unused variable warnings
/// 2. Remove or comment out unused variables
///
/// Usage:
/// ```
/// dart fix_unused_variables.dart [--dry-run] [--dir=<directory>]
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

  print('Scanning for unused variables in $baseDir...');

  // First run analyzer to identify the unused variables
  final analyzerResult = await Process.run('dart', [
    'analyze',
    baseDir,
  ], runInShell: true);

  // Parse result to find unused variables warnings
  final unusedVarFiles = <String, List<UnusedVariable>>{};
  final output = analyzerResult.stdout.toString();
  final lines = output.split('\n');

  for (final line in lines) {
    if (line.contains('unused_local_variable') &&
        line.contains("variable '") &&
        line.contains("isn't used")) {
      final parts = line.split(' • ')[0].split(':');
      if (parts.length >= 3) {
        final filePath = parts[0].trim();
        final lineNumber = int.tryParse(parts[1].trim());
        final columnNumber = int.tryParse(parts[2].trim());

        if (lineNumber != null && columnNumber != null) {
          // Extract variable name from the message
          final message = line.split(' • ')[1].trim();
          final variableName = extractVariableName(message);

          if (variableName != null) {
            unusedVarFiles.putIfAbsent(filePath, () => []);
            unusedVarFiles[filePath]!.add(
              UnusedVariable(variableName, lineNumber, columnNumber),
            );
          }
        }
      }
    }
  }

  if (unusedVarFiles.isEmpty) {
    print('No unused variables found!');
    return;
  }

  // Process files with unused variables
  int totalFixedVariables = 0;

  for (final entry in unusedVarFiles.entries) {
    final filePath = entry.key;
    final variables = entry.value;

    print('\n$filePath:');
    print('  Found ${variables.length} unused variables:');
    for (final variable in variables) {
      print('  - Line ${variable.lineNumber}: ${variable.name}');
    }

    if (!dryRun) {
      final fixedCount = await fixUnusedVariables(filePath, variables);
      totalFixedVariables += fixedCount;
    }
  }

  if (dryRun) {
    print(
      '\nDry run completed. Found $totalFixedVariables potential issues to fix.',
    );
  } else {
    print('\nCompleted. Fixed $totalFixedVariables unused variables.');

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
  }
}

/// Extracts variable name from analyzer warning message
String? extractVariableName(String message) {
  // Format: "The value of the local variable 'variableName' isn't used"
  final regex = RegExp(r"The value of the local variable '([^']+)' isn't used");
  final match = regex.firstMatch(message);
  return match?.group(1);
}

/// Fixes unused variables in a file
Future<int> fixUnusedVariables(
  String filePath,
  List<UnusedVariable> variables,
) async {
  final file = File(filePath);
  if (!await file.exists()) {
    print('  Error: File $filePath does not exist');
    return 0;
  }

  String content = await file.readAsString();
  final lines = content.split('\n');

  // Process in reverse order to avoid affecting line numbers
  variables.sort((a, b) => b.lineNumber.compareTo(a.lineNumber));

  int fixedCount = 0;

  for (final variable in variables) {
    if (variable.lineNumber <= 0 || variable.lineNumber > lines.length) {
      continue;
    }

    final lineIndex = variable.lineNumber - 1;
    final line = lines[lineIndex];

    // Check if this is a variable declaration
    if (line.contains('final ${variable.name}') ||
        line.contains('var ${variable.name}') ||
        line.contains('const ${variable.name}')) {
      // Comment out the variable declaration
      lines[lineIndex] = '// Unused: $line';
      print(
        '  Fixed line ${variable.lineNumber}: Commented out ${variable.name}',
      );
      fixedCount++;
    }
  }

  if (fixedCount > 0) {
    await file.writeAsString(lines.join('\n'));
  }

  return fixedCount;
}

/// Model for an unused variable
class UnusedVariable {
  final String name;
  final int lineNumber;
  final int columnNumber;

  UnusedVariable(this.name, this.lineNumber, this.columnNumber);
}
