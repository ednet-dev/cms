part of ednet_core;

final String license = '''
/*
http://opensource.org/licenses/

http://en.wikipedia.org/wiki/BSD_license
3-clause license ("New BSD License" or "Modified BSD License")

Copyright (c) 2023, EDNetCore project authors
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the EDNetCore nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
''';

String genEDNetLibrary(Model model) {
  Domain domain = model.domain;

  final String domainCodeLowerUnderscore = domain.code!.toLowerCase();
  final String modelCodeLowerUnderscore = model.code!.toLowerCase();

  final String genEDNetLibraryTemplate = '''
    // lib/{{domainCodeLowerUnderscore}}_{{modelCodeLowerUnderscore}}.dart
    {{license}}

    library {{domainCodeLowerUnderscore}}_{{modelCodeLowerUnderscore}};

    import "package:ednet_core/ednet_core.dart";

    part "repository.dart";
    part "gen/{{domainCodeLowerUnderscore}}/i_domain_models.dart";
    part "gen/{{domainCodeLowerUnderscore}}/{{modelCodeLowerUnderscore}}/model_entries.dart";
    part "{{domainCodeLowerUnderscore}}/domain.dart";
    part "{{domainCodeLowerUnderscore}}/{{modelCodeLowerUnderscore}}/model.dart";
    part "{{domainCodeLowerUnderscore}}/{{modelCodeLowerUnderscore}}/json/data.dart";
    part "{{domainCodeLowerUnderscore}}/{{modelCodeLowerUnderscore}}/json/model.dart";
    {{conceptParts}}
    {{genConceptParts}}
    
  ''';

  final List<String> conceptParts = model.concepts
      .map((c) =>
          '\npart "${domainCodeLowerUnderscore}/${modelCodeLowerUnderscore}/${c.codesLowerUnderscore}.dart";\n')
      .toList();

  final List<String> genConceptParts = model.concepts
      .map((c) =>
          '\npart "gen/${domainCodeLowerUnderscore}/${modelCodeLowerUnderscore}/${c.codesLowerUnderscore}.dart";\n')
      .toList();

  return genEDNetLibraryTemplate.replaceAllMapped(RegExp('{{([A-Za-z]+)}}'),
      (match) {
    switch (match.group(1)) {
      case 'license':
        return license;
      case 'domainCodeLowerUnderscore':
        return domainCodeLowerUnderscore;
      case 'modelCodeLowerUnderscore':
        return modelCodeLowerUnderscore;
      case 'conceptParts':
        return conceptParts.join('\n');
      case 'genConceptParts':
        return genConceptParts.join('\n');
      default:
        return match.group(0) ?? '';
    }
  });
}
