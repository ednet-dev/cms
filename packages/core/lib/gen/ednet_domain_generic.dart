part of ednet_core;

String genModels(Domain domain, String library) {
  final buffer = StringBuffer()
    ..writeln('part of \'../../$library.dart\';')
    ..writeln()
    ..writeln('// lib/gen/${domain.codeLowerUnderscore}/i_domain_models.dart')
    ..writeln('class ${domain.code}Models extends DomainModels {')
    ..writeln('  ${domain.code}Models(Domain domain) : super(domain) {')
    ..writeln(
        '    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart')
    ..writeln();

  for (final model in domain.models) {
    buffer
      ..writeln('    final model = fromJsonToModel(')
      ..writeln('      \'\',')
      ..writeln('      domain,')
      ..writeln('      \'${model.code}\',')
      ..writeln(
          '      loadYaml(${domain.codeFirstLetterLower}${model.code}ModelYaml) as Map<dynamic, dynamic>,')
      ..writeln('    );')
      ..writeln(
          '    final ${model.codeFirstLetterLower}Model = ${model.code}Model(model);')
      ..writeln('    add(${model.codeFirstLetterLower}Model);')
      ..writeln();
  }

  buffer
    ..writeln('  }')
    ..writeln()
    ..writeln('}');

  return buffer.toString();
}
