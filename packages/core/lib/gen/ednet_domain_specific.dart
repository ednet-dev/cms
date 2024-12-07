part of ednet_core;

String genDomain(Domain domain, String library) {
  final buffer = StringBuffer()
    ..writeln('part of \'../$library.dart\';')
    ..writeln()
    ..writeln('// lib/${domain.codeLowerUnderscore}/domain.dart')
    ..writeln('class ${domain.code}Domain extends ${domain.code}Models {')
    ..writeln('  ${domain.code}Domain(super.domain);')
    ..writeln()
    ..writeln('  // added after code gen - begin')
    ..writeln()
    ..writeln('  // added after code gen - end')
    ..writeln()
    ..writeln('}');

  return buffer.toString();
}
