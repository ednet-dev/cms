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
        defaultsTo: '.',
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
        // Defaults to an empty pattern to exclude no files
        // unless specified by the user
        defaultsTo: '',
      );
  }

  @override
  String get description =>
      'Generates a PDF with the concatenated source code from files matching '
      'the include pattern and not matching the exclude pattern '
      'in the given directory.';

  @override
  String get name => 'generate';

  final Logger _logger;

  @override
  Future<int> run() async {
    final sourcePath = argResults?['source'] as String? ?? '.';
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
    final allCode = codeBuffer.toString();

    await generatePdf(allCode, outputFileName);

    _logger.success('PDF generated: $outputFileName');
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
      // Compute the relative file path using rootPath to ensure consistency
      final relativeFilePath = path.relative(filePath, from: rootPath);

      if (entity is File) {
        final isIncluded =
            includeGlobs.any((glob) => glob.matches(relativeFilePath));
        final isExcluded =
            excludeGlobs.any((glob) => glob.matches(relativeFilePath));

        if (isIncluded && !isExcluded) {
          _logger.info('Adding file: $relativeFilePath');
          final code = await entity.readAsString();
          codeBuffer
            ..write(code.trim())
            ..write('\n\n\n'); // Add some space between files in the PDF.
        }
      }
    }
  }

  Future<void> generatePdf(String allCode, String outputFileName) async {
    final pdf = pw.Document();

    // Define the maximum length of text that can go on one page
    const maxChunkSize = 1000; // Adjust this size as needed

    // Split the allCode into smaller chunks
    var codeChunks = <String>[];
    for (var i = 0; i < allCode.length; i += maxChunkSize) {
      var end = (i + maxChunkSize < allCode.length)
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
