part of ednet_core;

String genConcept(Concept concept, String library) {
  final model = concept.model;
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln('part of \'../../$library.dart\';')
    ..writeln()
    ..writeln(
        '// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/${concept.codesLowerUnderscore}.dart')
    ..writeln('class ${concept.code} extends ${concept.code}Gen {')
    ..writeln('  ${concept.code}(super.concept);')
    ..writeln();

  final id = concept.id;
  if (id.length > 0) {
    buffer.write('  ${concept.code}.withId(Concept concept');
    if (id.referenceLength > 0) {
      for (final parent in concept.parents.whereType<Parent>()) {
        if (parent.identifier) {
          final destinationConcept = parent.destinationConcept;
          buffer.write(', ${destinationConcept.code} ${parent.code}');
        }
      }
    }
    if (id.attributeLength > 0) {
      for (final attribute in concept.attributes.whereType<Attribute>()) {
        if (attribute.identifier) {
          buffer.write(', ${attribute.type?.base} ${attribute.code}');
        }
      }
    }
    buffer
      ..writeln(') :')
      ..write('    super.withId(concept');
    if (id.referenceLength > 0) {
      for (final parent in concept.parents.whereType<Parent>()) {
        if (parent.identifier) {
          buffer.write(', ${parent.code}');
        }
      }
    }
    if (id.attributeLength > 0) {
      for (final attribute in concept.attributes.whereType<Attribute>()) {
        if (attribute.identifier) {
          buffer.write(', ${attribute.code}');
        }
      }
    }
    buffer
      ..writeln(');')
      ..writeln();
  }

  buffer
    ..writeln('  // added after code gen - begin')
    ..writeln()
    ..writeln('  // added after code gen - end')
    ..writeln()
    ..writeln('}')
    ..writeln()
    ..writeln('class ${concept.codes} extends ${concept.codes}Gen {')
    ..writeln('  ${concept.codes}(super.concept);')
    ..writeln()
    ..writeln('  // added after code gen - begin')
    ..writeln()
    ..writeln('  // added after code gen - end')
    ..writeln('}');

  return buffer.toString();
}
