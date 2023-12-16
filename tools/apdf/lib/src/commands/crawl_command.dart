import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse, parseFragment;
import 'package:http/http.dart' as http;
import 'package:mason_logger/mason_logger.dart';

class CrawlCommand extends Command<int> {
  CrawlCommand({required Logger logger}) : _logger = logger {
    argParser.addOption(
      'url',
      abbr: 'u',
      help: 'The URL to crawl.',
      valueHelp: 'url',
    );
  }

  @override
  String get description => 'Crawls a given URL and extracts text content.';

  @override
  String get name => 'crawl';

  final Logger _logger;

  @override
  Future<int> run() async {
    final url = argResults?['url'] as String?;
    if (url == null || url.isEmpty) {
      _logger.err('URL is required.');
      return ExitCode.usage.code;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        _logger.err('Failed to fetch URL: ${response.statusCode}');
        return ExitCode.software.code;
      }

      final document = parse(response.body);
      final two = extractHtmlContent(document);

      final textContent = document.body?.text ?? '';

      final jsonContent = jsonEncode({
        'url': url,
        'content': textContent,
      });

      final dateTime = DateTime.now().toIso8601String();
      final fileName = '$dateTime.json';
      final file = File(fileName);
      await file.writeAsString(jsonContent);

      _logger.success('Content saved to $fileName');
      return ExitCode.success.code;
    } catch (e) {
      _logger.err('An error occurred: $e');
      return ExitCode.software.code;
    }
  }

  String? extractHtmlContent(Document document) {
    final extractedContent = StringBuffer();

    void parseElement(Element element) {
      // Skip script tags
      if (element.localName == 'script') {
        return;
      }

      // Recursively parse children
      for (var child in element.children) {
        parseElement(child);
      }

      // Check if the element itself has text content after parsing children
      final text = element.text.trim();
      if (text.isNotEmpty) {
        extractedContent
          ..writeln(text)
          ..writeln(); // Add a new line for readability
      }
    }

    // List of semantic tags to extract in order
    const tagsToExtract = [
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'p',
      'article',
      'section',
      'header',
      'footer',
      'nav',
      'aside',
      'main'
    ];

    for (final tag in tagsToExtract) {
      document.querySelectorAll(tag).forEach(parseElement);
    }

    // Remove any residual HTML tags and normalize whitespaces
    final finalText = parseFragment(extractedContent.toString()).text;
    return finalText?.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _extractHtmlSemanticContentOld(Element element) {
    final extractedContent = StringBuffer();

    void parseElement(Element element) {
      // Check if the element itself has text content
      if (element.text.trim().isNotEmpty ?? false) {
        extractedContent
          ..writeln(element.text.trim())
          ..writeln(); // Add a new line for readability
      }

      // Recursively parse children
      for (final child in element.children) {
        parseElement(child);
      }
    }

    parseElement(element);

    return extractedContent.toString();
  }

  String _extractHtmlContentOld(Document document) {
    final extractedContent = StringBuffer();

    // List of semantic tags to extract in order
    final tagsToExtract = <String>[
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'p',
      'article',
      'section',
      'header',
      'footer',
      'nav',
      'aside',
      'main',
    ];

    for (final tag in tagsToExtract) {
      document.querySelectorAll(tag).forEach((element) {
        // Check if element has text content
        if (element.text.trim().isNotEmpty ?? false) {
          extractedContent
            ..writeln(element.text.trim())
            ..writeln(); // Add a new line for readability
        }
      });
    }

    return extractedContent.toString();
  }
}
