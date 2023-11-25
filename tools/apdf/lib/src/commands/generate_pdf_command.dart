import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
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
        defaultsTo: '*.dart',
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
    final includePattern = argResults?['include'] as String? ?? '*.dart';
    final excludePattern = argResults?['exclude'] as String? ?? '';
    final sourceDirectory = Directory(sourcePath);
    final codeBuffer = StringBuffer();

    final includeGlob = Glob(includePattern, recursive: true);
    final excludeGlob = Glob(excludePattern, recursive: true);

    await traverseDirectory(
      sourceDirectory,
      codeBuffer,
      includeGlob,
      excludeGlob,
    );
    final allCode = codeBuffer.toString();

    await generatePdf(allCode, outputFileName);

    _logger.success('PDF generated: $outputFileName');
    return ExitCode.success.code;
  }

  Future<void> traverseDirectory(
    Directory directory,
    StringBuffer codeBuffer,
    Glob includeGlob,
    Glob excludeGlob,
  ) async {
    final rootPath = directory.absolute.path;

    await for (final entity
        in directory.list(recursive: true, followLinks: false)) {
      final filePath = entity.absolute.path;

      final relativeFilePath = path.relative(filePath, from: rootPath);
      final isPathMatch = includeGlob.matches(relativeFilePath);
      print(isPathMatch);
      if (entity is File &&
          includeGlob.matches(entity.path) &&
          !excludeGlob.matches(entity.path)) {
        final code = await entity.readAsString();
        codeBuffer
          ..write(code.trim())
          ..write('\n\n\n'); // Add some space between files in the PDF. } } }
      }
    }
  }

  Future<void> generatePdf(String allCode, String outputFileName) async {
    final pdf = pw.Document()
      ..addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(
                allCode,
                style: pw.TextStyle(font: pw.Font.courier(), fontSize: 10),
              ),
            );
          },
        ),
      );

    final file = File(outputFileName);
    await file.writeAsBytes(await pdf.save());
  }
}
