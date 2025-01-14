import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:yaml/yaml.dart';

class GeneratePdfCommand extends Command<int> {
  GeneratePdfCommand({required Logger logger}) : _logger = logger {
    argParser
      ..addOption(
        'source',
        abbr: 's',
        help: 'The source directory to traverse.',
        valueHelp: 'path',
        defaultsTo: './',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'The name of the output file.',
        valueHelp: 'filename',
      )
      ..addOption(
        'include',
        abbr: 'i',
        help: 'Glob pattern for files to include.',
        valueHelp: 'include',
        defaultsTo: '**/*.dart',
      )
      ..addOption(
        'exclude',
        abbr: 'e',
        help: 'Glob pattern for files to exclude.',
        valueHelp: 'exclude',
        defaultsTo: '',
      )
      ..addOption(
        'outputFormat',
        abbr: 'f',
        help: 'The format of the output file (pdf or text).',
        valueHelp: 'format',
        allowed: ['pdf', 'text'],
        defaultsTo: 'pdf',
      )
      ..addFlag(
        'recursiveLibBin',
        abbr: 'r',
        help:
            'When no arguments are provided, traverse lib and bin directories recursively and generate a single Dart file.',
        negatable: false,
      );
  }

  @override
  String get description =>
      'Generates a file with the concatenated source code from files matching '
      'the include pattern and not matching the exclude pattern '
      'in the given directory. The output format can be PDF or plain text. '
      'When executed without arguments in a Dart/Flutter project, it traverses the '
      'lib and bin directories and assembles a single Dart file with all source code, '
      'prepending the pubspec.yaml as a header.';

  @override
  String get name => 'generate';

  final Logger _logger;

  @override
  Future<int> run() async {
    // Determine if pubspec.yaml exists in the current or parent directories
    final currentDir = Directory.current;
    final projectRoot = await _findProjectRoot(currentDir);
    final isDartProject = projectRoot != null;

    // Check if no arguments are provided
    final hasNoArgs = argResults?.arguments.isEmpty ?? true;

    var sourcePath = argResults?['source'] as String? ?? './';
    var outputFileName = argResults?['output'] as String? ?? 'source_code.pdf';
    var includePatterns = argResults?['include'] as String? ?? '**/*.dart';
    final excludePatterns = argResults?['exclude'] as String? ?? '';
    var outputFormat = argResults?['outputFormat'] as String? ?? 'pdf';

    // If no arguments and in Dart/Flutter project, adjust defaults
    if (hasNoArgs && isDartProject) {
      // Set sourcePath to project root
      sourcePath = projectRoot.path;

      // Set include patterns to lib and bin directories
      includePatterns = 'lib/**/*.dart,bin/**/*.dart';

      // Set output format to text
      outputFormat = 'text';

      // Extract project name from pubspec.yaml for output file naming
      final pubspecFile = File(path.join(projectRoot.path, 'pubspec.yaml'));
      final pubspecContent = await pubspecFile.readAsString();
      final pubspec = loadYaml(pubspecContent) as YamlMap;
      final projectName = pubspec['name'] as String? ?? 'project';

      // Set output file name
      outputFileName = '${projectName}_source.dart';
    }

    final includeGlobs = includePatterns.isNotEmpty
        ? includePatterns
            .split(',')
            .map((pattern) => Glob(pattern.trim(), recursive: true))
            .toList()
        : [
            Glob('**/*.dart', recursive: true),
          ]; // Default to Dart files if empty

    final excludeGlobs = excludePatterns.isNotEmpty
        ? excludePatterns
            .split(',')
            .map((pattern) => Glob(pattern.trim(), recursive: true))
            .toList()
        : <Glob>[]; // Default to an empty list if exclude pattern is empty

    final sourceDirectory = Directory(sourcePath);
    final codeBuffer = StringBuffer();

    // If default behavior, prepend pubspec.yaml content as header
    if (hasNoArgs && isDartProject) {
      final pubspecFile = File(path.join(sourceDirectory.path, 'pubspec.yaml'));
      if (await pubspecFile.exists()) {
        final pubspecContent = await pubspecFile.readAsString();
        codeBuffer
          ..writeln('// pubspec.yaml')
          ..writeln(pubspecContent)
          ..writeln('\n\n// Concatenated Source Code\n');
      } else {
        _logger.warn('pubspec.yaml not found at project root.');
      }
    }

    await traverseDirectory(
      sourceDirectory,
      codeBuffer,
      includeGlobs,
      excludeGlobs,
    );

    final filteredCode = filterCode(codeBuffer.toString());

    // Check and update the output file name based on the output format
    var updatedOutputFileName =
        outputFileName.replaceAll(RegExp(r'\.pdf$|\.txt$|\.dart$'), '');
    if (outputFormat == 'pdf') {
      updatedOutputFileName += '.pdf';
    } else if (outputFormat == 'text') {
      updatedOutputFileName += '.txt';
    } else if (outputFormat == 'dart') {
      updatedOutputFileName += '.dart';
    }

    if (outputFormat == 'pdf') {
      await generatePdf(filteredCode, updatedOutputFileName);
      _logger.success('PDF generated: $updatedOutputFileName');
    } else if (outputFormat == 'text') {
      await generateTextFile(filteredCode, updatedOutputFileName);
      _logger.success('Text file generated: $updatedOutputFileName');
    } else if (outputFormat == 'dart') {
      await generateDartFile(filteredCode, updatedOutputFileName);
      _logger.success('Dart file generated: $updatedOutputFileName');
    }

    return ExitCode.success.code;
  }

  Future<Directory?> _findProjectRoot(Directory dir) async {
    var current = dir;
    while (true) {
      if (await File(path.join(current.path, 'pubspec.yaml')).exists()) {
        return current;
      }
      if (current.parent.path == current.path) {
        // Reached root without finding pubspec.yaml
        return null;
      }
      current = current.parent;
    }
  }

  Future<void> traverseDirectory(
    Directory directory,
    StringBuffer codeBuffer,
    List<Glob> includeGlobs,
    List<Glob> excludeGlobs,
  ) async {
    final rootPath = directory.absolute.path;

    await for (final entity
        in directory.list(recursive: true, followLinks: false)) {
      final filePath = entity.absolute.path;
      final relativeFilePath = path.relative(filePath, from: rootPath);

      if (entity is File) {
        final isIncluded =
            includeGlobs.any((glob) => glob.matches(relativeFilePath));
        final isExcluded =
            excludeGlobs.any((glob) => glob.matches(relativeFilePath));

        if (isIncluded && !isExcluded) {
          _logger.info('Adding file: $relativeFilePath'); // Debug print
          final code = await entity.readAsString();
          codeBuffer
            ..write('// File: $relativeFilePath\n')
            ..write(code.trim())
            ..write('\n\n'); // Add some space between files
        } else {
          _logger.info('Skipping file: $relativeFilePath'); // Debug print
        }
      }
    }
  }

  String filterCode(String code) {
    final lines = code.split('\n');
    final filteredLines = lines.where(
      (line) =>
          !line.trim().startsWith('import') && !line.trim().startsWith('//'),
    );
    return filteredLines.join('\n');
  }

  Future<void> generateTextFile(String allCode, String outputFileName) async {
    final file = File(outputFileName);
    await file.writeAsString(allCode);
  }

  Future<void> generateDartFile(String allCode, String outputFileName) async {
    final file = File(outputFileName);
    await file.writeAsString(allCode);
  }

  Future<void> generatePdf(String allCode, String outputFileName) async {
    final pdf = pw.Document();

    // Define the maximum length of text that can go on one page
    const maxChunkSize = 1000; // Adjust this size as needed

    // Split the allCode into smaller chunks
    final codeChunks = <String>[];
    for (var i = 0; i < allCode.length; i += maxChunkSize) {
      final end = (i + maxChunkSize < allCode.length)
          ? i + maxChunkSize
          : allCode.length;
      codeChunks.add(allCode.substring(i, end));
    }

    // Add each chunk as a separate paragraph to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => codeChunks.map((chunk) {
          return pw.Paragraph(
            text: chunk,
            style: pw.TextStyle(font: pw.Font.courier(), fontSize: 10),
          );
        }).toList(),
      ),
    );

    final file = File(outputFileName);
    await file.writeAsBytes(await pdf.save());
  }
}
