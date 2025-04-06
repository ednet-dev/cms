import 'dart:io';

/// A script to update deprecated Material 3 APIs.
///
/// This script will:
/// 1. Find common deprecated Material APIs
/// 2. Replace them with their Material 3 equivalents
///
/// Usage:
/// ```
/// dart update_material_apis.dart [--dry-run] [--dir=<directory>]
/// ```
///
/// Options:
/// - `--dry-run`: Only report issues, don't make any changes
/// - `--dir`: Specify a subdirectory to scan (default: current directory)

class ApiReplacement {
  final RegExp pattern;
  final String replacement;
  final String description;

  ApiReplacement(this.pattern, this.replacement, this.description);
}

void main(List<String> args) async {
  final dryRun = args.contains('--dry-run');
  String? targetDir;

  for (final arg in args) {
    if (arg.startsWith('--dir=')) {
      targetDir = arg.substring('--dir='.length);
    }
  }

  final baseDir = targetDir ?? '.';

  print('Scanning for deprecated Material APIs in $baseDir...');

  // Define API replacements
  final replacements = [
    // Colors and themes
    ApiReplacement(
      RegExp(r'Theme\.of\(context\)\.primaryColor'),
      'Theme.of(context).colorScheme.primary',
      'Replace primaryColor with colorScheme.primary',
    ),
    ApiReplacement(
      RegExp(r'Theme\.of\(context\)\.accentColor'),
      'Theme.of(context).colorScheme.secondary',
      'Replace accentColor with colorScheme.secondary',
    ),
    ApiReplacement(
      RegExp(r'Theme\.of\(context\)\.buttonColor'),
      'Theme.of(context).colorScheme.primary',
      'Replace buttonColor with colorScheme.primary',
    ),
    ApiReplacement(
      RegExp(r'Theme\.of\(context\)\.backgroundColor'),
      'Theme.of(context).colorScheme.background',
      'Replace backgroundColor with colorScheme.background',
    ),

    // Text themes
    ApiReplacement(
      RegExp(r'Theme\.of\(context\)\.textTheme\.headline\d'),
      'Theme.of(context).textTheme.headlineMedium',
      'Replace old headline with headlineMedium',
    ),
    ApiReplacement(
      RegExp(r'Theme\.of\(context\)\.textTheme\.subtitle\d'),
      'Theme.of(context).textTheme.titleMedium',
      'Replace subtitle with titleMedium',
    ),
    ApiReplacement(
      RegExp(r'Theme\.of\(context\)\.textTheme\.body\d'),
      'Theme.of(context).textTheme.bodyMedium',
      'Replace body with bodyMedium',
    ),

    // Button styles
    ApiReplacement(
      RegExp(r'RaisedButton\('),
      'ElevatedButton(',
      'Replace RaisedButton with ElevatedButton',
    ),
    ApiReplacement(
      RegExp(r'FlatButton\('),
      'TextButton(',
      'Replace FlatButton with TextButton',
    ),
    ApiReplacement(
      RegExp(r'OutlineButton\('),
      'OutlinedButton(',
      'Replace OutlineButton with OutlinedButton',
    ),

    // AppBar actions
    ApiReplacement(
      RegExp(r'IconButton\(icon: Icon\((.+?)\), onPressed: (.+?)\)'),
      'IconButton(icon: Icon(\$1), onPressed: \$2, tooltip: "Action")',
      'Add tooltip to IconButton',
    ),
  ];

  // Process files
  final dir = Directory(baseDir);
  if (!await dir.exists()) {
    print('Error: Directory $baseDir does not exist');
    return;
  }

  int totalReplacements = 0;

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final replacementCount = await processFile(
        entity.path,
        replacements,
        dryRun,
      );
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

Future<int> processFile(
  String filePath,
  List<ApiReplacement> replacements,
  bool dryRun,
) async {
  final file = File(filePath);
  final content = await file.readAsString();
  String newContent = content;
  int replacementCount = 0;

  for (final replacement in replacements) {
    final matches = replacement.pattern.allMatches(content).toList();
    if (matches.isNotEmpty) {
      print('\n$filePath:');
      print(
        '  Found ${matches.length} instances of ${replacement.description}',
      );

      if (!dryRun) {
        newContent = newContent.replaceAllMapped(replacement.pattern, (match) {
          // If we have capture groups, handle them appropriately
          if (match.groupCount > 0) {
            String replacedText = replacement.replacement;
            for (int i = 1; i <= match.groupCount; i++) {
              replacedText = replacedText.replaceAll(
                '\$$i',
                match.group(i) ?? '',
              );
            }
            return replacedText;
          }
          return replacement.replacement;
        });
      }

      replacementCount += matches.length;
    }
  }

  if (!dryRun && newContent != content) {
    await file.writeAsString(newContent);
    print('  Updated file');
  }

  return replacementCount;
}
