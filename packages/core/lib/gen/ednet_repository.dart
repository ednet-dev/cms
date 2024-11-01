part of ednet_core;

String genRepository(CoreRepository repo, String library) {
  final repoName = library
          .split('_')
          .map((e) => e[0].toUpperCase() + e.substring(1))
          .join() +
      'Repo';

  final buffer = StringBuffer()
    ..writeln('part of \'./$library.dart\';')
    ..writeln()
    ..writeln('// lib/repository.dart')
    ..writeln('class $repoName extends CoreRepository {')
    ..writeln('  $repoName([super.code = repository]) {');

  for (final domain in repo.domains) {
    buffer
      ..writeln('    final domain = Domain(\'${domain.code}\');')
      ..writeln('    domains.add(domain);')
      ..writeln('    add(${domain.code}Domain(domain));');
  }

  buffer
    ..writeln('  }')
    ..writeln()
    ..writeln('  static const repository = \'$repoName\';')
    ..writeln('}');

  return buffer.toString();
}
