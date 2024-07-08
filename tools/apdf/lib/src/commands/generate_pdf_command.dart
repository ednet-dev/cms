import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
        help: 'The name of the output PDF file.',
        valueHelp: 'filename',
        defaultsTo: 'source_code.pdf',
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
      );
  }

  @override
  String get description =>
      'Generates a file with the concatenated source code from files matching '
      'the include pattern and not matching the exclude pattern '
      'in the given directory. The output format can be PDF or plain text.';

  @override
  String get name => 'generate';

  final Logger _logger;

  @override
  Future<int> run() async {
    final sourcePath = argResults?['source'] as String? ?? './';
    final outputFileName =
        argResults?['output'] as String? ?? 'source_code.pdf';
    final includePatterns = argResults?['include'] as String? ?? '**/*.dart';
    final excludePatterns = argResults?['exclude'] as String? ?? '';

    final includeGlobs = includePatterns.isNotEmpty
        ? includePatterns
            .split(',')
            .map((pattern) => Glob(pattern, recursive: true))
            .toList()
        : [
            Glob('**/*.dart', recursive: true)
          ]; // Default to Dart files if empty

    final excludeGlobs = excludePatterns.isNotEmpty
        ? excludePatterns
            .split(',')
            .map((pattern) => Glob(pattern, recursive: true))
            .toList()
        : <Glob>[]; // Default to an empty list if exclude pattern is empty

    final sourceDirectory = Directory(sourcePath);
    final codeBuffer = StringBuffer();

    await traverseDirectory(
      sourceDirectory,
      codeBuffer,
      includeGlobs,
      excludeGlobs,
    );

    final filteredCode = filterCode(codeBuffer.toString());
    final outputFormat = argResults?['outputFormat'] as String? ?? 'pdf';

    // Check and update the output file name based on the output format
    String updatedOutputFileName =
        outputFileName.replaceAll(RegExp(r'\.pdf$|\.txt$'), '');
    updatedOutputFileName += outputFormat == 'pdf' ? '.pdf' : '.txt';

    if (outputFormat == 'pdf') {
      await generatePdf(filteredCode, updatedOutputFileName);
      _logger.success('PDF generated: $updatedOutputFileName');
    } else if (outputFormat == 'text') {
      await generateTextFile(filteredCode, updatedOutputFileName);
      _logger.success('Text file generated: $updatedOutputFileName');
    }

    return ExitCode.success.code;
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
            ..write(code.trim())
            ..write('\n\n\n'); // Add some space between files in the PDF.
        } else {
          _logger.info('Skipping file: $relativeFilePath'); // Debug print
        }
      }
    }
  }

  String filterCode(String code) {
    final lines = code.split('\n');
    final filteredLines = lines.where((line) =>
        !line.trim().startsWith('import') && !line.trim().startsWith('//'));
    return filteredLines.join('\n');
  }

  Future<void> generateTextFile(String allCode, String outputFileName) async {
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
