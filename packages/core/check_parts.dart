import 'dart:io';

void main() async {
  final coreFilePath = 'lib/ednet_core.dart';
  final logFilePath = 'missing-parts.log';
  final fixSuggestionFilePath = 'part-fixes.md';
  final List<String> missingParts = [];
  final Map<String, bool> existingPartsWithoutPartOf = {};
  
  try {
    // Read the core file content
    final File coreFile = File(coreFilePath);
    if (!await coreFile.exists()) {
      print('Error: Core file $coreFilePath does not exist.');
      return;
    }
    
    final String coreContent = await coreFile.readAsString();
    final List<String> lines = coreContent.split('\n');
    
    // Extract part statements
    final RegExp partRegex = RegExp(r"^\s*part\s+'([^']+)'\s*;\s*$");
    
    for (String line in lines) {
      final match = partRegex.firstMatch(line);
      if (match != null) {
        final String partPath = match.group(1)!;
        final String fullPath = 'lib/$partPath';
        
        final File partFile = File(fullPath);
        if (!await partFile.exists()) {
          print('Missing part file: $fullPath');
          missingParts.add(partPath);
        } else {
          // Check if the file has a proper 'part of' declaration
          final String partContent = await partFile.readAsString();
          final RegExp partOfRegex = RegExp(r"^\s*part\s+of\s+[^;]+;", multiLine: true);
          final bool hasPartOf = partOfRegex.hasMatch(partContent);
          
          if (!hasPartOf) {
            print('File exists but lacks "part of" declaration: $fullPath');
            existingPartsWithoutPartOf[partPath] = true;
          }
        }
      }
    }
    
    // Write the results to the log file
    final File logFile = File(logFilePath);
    final StringBuffer logContent = StringBuffer();
    
    logContent.writeln('# Missing part files in ednet_core.dart');
    logContent.writeln('# Generated on ${DateTime.now()}');
    logContent.writeln('');
    
    if (missingParts.isEmpty) {
      logContent.writeln('All part files exist.');
    } else {
      logContent.writeln('Total missing files: ${missingParts.length}');
      logContent.writeln('');
      
      for (String partPath in missingParts) {
        logContent.writeln(partPath);
      }
    }
    
    await logFile.writeAsString(logContent.toString());
    
    // Write fix suggestions
    final File fixSuggestionFile = File(fixSuggestionFilePath);
    final StringBuffer fixContent = StringBuffer();
    
    fixContent.writeln('# Fix Suggestions for ednet_core.dart');
    fixContent.writeln('');
    
    // Option 1: Create missing files
    fixContent.writeln('## Option 1: Create Missing Files');
    fixContent.writeln('');
    fixContent.writeln('This will create all missing files with proper "part of" declarations:');
    fixContent.writeln('');
    fixContent.writeln('```bash');
    for (String partPath in missingParts) {
      final String dirPath = partPath.substring(0, partPath.lastIndexOf('/'));
      fixContent.writeln('# For $partPath');
      fixContent.writeln('mkdir -p lib/$dirPath');
      fixContent.writeln('echo "part of ednet_core;" > lib/$partPath');
      fixContent.writeln('');
    }
    fixContent.writeln('```');
    fixContent.writeln('');
    
    // Option 2: Update ednet_core.dart
    fixContent.writeln('## Option 2: Update ednet_core.dart');
    fixContent.writeln('');
    fixContent.writeln('Remove references to missing files:');
    fixContent.writeln('');
    fixContent.writeln('```dart');
    for (String partPath in missingParts) {
      fixContent.writeln("// Remove this line:");
      fixContent.writeln("part '$partPath';");
    }
    fixContent.writeln('```');
    fixContent.writeln('');
    
    // Option 3: Fix existing files without part of
    if (existingPartsWithoutPartOf.isNotEmpty) {
      fixContent.writeln('## Option 3: Fix Existing Files Without "part of" Declarations');
      fixContent.writeln('');
      fixContent.writeln('Add "part of ednet_core;" to the beginning of these files:');
      fixContent.writeln('');
      for (String partPath in existingPartsWithoutPartOf.keys) {
        fixContent.writeln('- lib/$partPath');
      }
      fixContent.writeln('');
      fixContent.writeln('```bash');
      for (String partPath in existingPartsWithoutPartOf.keys) {
        fixContent.writeln('sed -i "1s/^/part of ednet_core;\\n\\n/" lib/$partPath');
      }
      fixContent.writeln('```');
    }
    
    await fixSuggestionFile.writeAsString(fixContent.toString());
    
    print('Check completed. Results written to $logFilePath');
    print('Fix suggestions written to $fixSuggestionFilePath');
    print('Total missing files: ${missingParts.length}');
    print('Total files lacking "part of" declaration: ${existingPartsWithoutPartOf.length}');
  } catch (e) {
    print('Error: $e');
  }
} 