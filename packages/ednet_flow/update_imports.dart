#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

/// A simple script to update imports in files based on their location
/// This is a temporary solution until the complete refactoring plan is implemented
void main() async {
  final libDir = Directory('lib');
  if (!await libDir.exists()) {
    print(
      'Error: lib directory not found. Make sure you run this from the package root.',
    );
    exit(1);
  }

  await processDirectory(libDir);
  print('Import update completed successfully.');
}

Future<void> processDirectory(Directory dir) async {
  await for (final entity in dir.list()) {
    if (entity is Directory) {
      await processDirectory(entity);
    } else if (entity is File &&
        entity.path.endsWith('.dart') &&
        !entity.path.endsWith('ednet_flow.dart')) {
      await updateImports(entity);
    }
  }
}

Future<void> updateImports(File file) async {
  print('Processing ${file.path}');
  final content = await file.readAsString();
  final lines = content.split('\n');

  // Skip files that already have imports
  if (lines.any((line) => line.startsWith('import '))) {
    print('  File already has imports, skipping');
    return;
  }

  final importLines = <String>[];

  // Add standard imports based on the file path
  if (file.path.contains('/visualization/') ||
      file.path.contains('/components/') ||
      file.path.contains('/painters/')) {
    importLines.add("import 'package:flutter/material.dart';");
  }

  // Add ednet_core imports for model files
  if (file.path.contains('/model/') ||
      file.path.contains('/domain/') ||
      file.path.contains('/adapters/')) {
    importLines.add("import 'package:ednet_core/ednet_core.dart';");
  }

  // Always import the main library
  importLines.add("import 'package:ednet_flow/ednet_flow.dart';");

  // Add module-specific imports
  if (file.path.contains('/domain_visualization/')) {
    if (!file.path.contains('/components/')) {
      importLines.add(
        "import 'package:ednet_flow/src/domain_visualization/components/node.dart';",
      );
      importLines.add(
        "import 'package:ednet_flow/src/domain_visualization/components/edge.dart';",
      );
    }
  } else if (file.path.contains('/event_storming/')) {
    importLines.add(
      "import 'package:ednet_flow/src/event_storming/model/element.dart';",
    );
  } else if (file.path.contains('/process_flow/')) {
    importLines.add(
      "import 'package:ednet_flow/src/process_flow/model/process.dart';",
    );
  } else if (file.path.contains('/game_visualization/')) {
    importLines.add(
      "import 'package:ednet_flow/src/game_visualization/model/domain_model.dart';",
    );
  }

  if (importLines.isEmpty) {
    print('  No imports needed');
    return;
  }

  // Add a file header
  final header = '''
// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

${importLines.join('\n')}

''';

  await file.writeAsString(header + content);
  print('  Updated imports');
}
