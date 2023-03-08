part of ednet_core;

final String ednetLibraryAppTemplate = '''
  // lib/{{domainCodeLowerUnderscore}}_{{modelCodeLowerUnderscore}}_app.dart
  {{license}}

  library {{domainCodeLowerUnderscore}}_{{modelCodeLowerUnderscore}}_app;

  /* 
  import "dart:flutter";
  import "dart:math";
  

  import "package:ednet_core/ednet_core.dart";
  import "package:ednet_core_default_app/ednet_core_default_app.dart";
  import "package:{{domainCodeLowerUnderscore}}_{{modelCodeLowerUnderscore}}/{{domainCodeLowerUnderscore}}_{{modelCodeLowerUnderscore}}.dart";
  */

''';

String genEDNetLibraryApp(Model model) {
  Domain domain = model.domain;
  final String domainCodeLowerUnderscore = domain.code!.toLowerCase();
  final String modelCodeLowerUnderscore = model.code!.toLowerCase();

  return ednetLibraryAppTemplate.replaceAllMapped(RegExp('{{([A-Za-z]+)}}'), (match) {
    switch (match.group(1)) {
      case 'license':
        return license;
      case 'domainCodeLowerUnderscore':
        return domainCodeLowerUnderscore;
      case 'modelCodeLowerUnderscore':
        return modelCodeLowerUnderscore;
      default:
        throw ArgumentError('Invalid variable name: ${match.group(1)}');
    }
  });
}
