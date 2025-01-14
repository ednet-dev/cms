part of ednet_core;

String genConceptGen(Concept concept, String library) {
  Model model = concept.model;
  Domain domain = model.domain;

  return '''
part of '../../../$library.dart';

// lib/gen/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/${concept.codesLowerUnderscore}.dart

abstract class ${concept.code}Gen extends Entity<${concept.code}> {
  ${concept.code}Gen(Concept concept) {
    this.concept = concept;
    ${concept.children.isEmpty ? '// concept.children.isEmpty' : _generateChildrenSetup(concept)}
  }
  ${_generateWithIdConstructor(concept)}

  ${_generateParentAccessors(concept)}

  ${_generateAttributeAccessors(concept)}

  ${_generateChildAccessors(concept)}
  @override
  ${concept.code} newEntity() => ${concept.code}(concept);

  @override
  ${concept.codes} newEntities() => ${concept.codes}(concept);

  ${_generateCompareToMethod(concept)}
}

abstract class ${concept.codes}Gen extends Entities<${concept.code}> {
  ${concept.codes}Gen(Concept concept) {
    this.concept = concept;
  }

  @override
  ${concept.codes} newEntities() => ${concept.codes}(concept);

  @override
  ${concept.code} newEntity() => ${concept.code}(concept);
}

${generateCommands(concept)}
${generateEvents(concept)}
${generatePolicies(concept)}
''';
}

String _generateChildrenSetup(Concept concept) {
  var generatedConcepts = <Concept>{};
  return concept.children
      .whereType<Child>()
      .map((child) {
        Concept destinationConcept = child.destinationConcept;
        var setup = '';
        if (!generatedConcepts.contains(destinationConcept)) {
          generatedConcepts.add(destinationConcept);
          setup = '''
    final ${destinationConcept.codeFirstLetterLower}Concept = 
        concept.model.concepts.singleWhereCode('${destinationConcept.code}');
    assert(${destinationConcept.codeFirstLetterLower}Concept != null, \'${destinationConcept.code} concept is not defined\');
''';
        }
        return '''
$setup    setChild('${child.code}', ${destinationConcept.codes}(${destinationConcept.codeFirstLetterLower}Concept!));
''';
      })
      .where((item) => item.trim().length > 0)
      .join();
}

String _generateWithIdConstructor(Concept concept) {
  Id id = concept.id;
  if (id.length == 0) return '';

  var params = [
    'Concept concept',
    ...concept.parents
        .whereType<Parent>()
        .where((p) => p.identifier)
        .map((p) => '${p.destinationConcept.code} ${p.code}'),
    ...concept.attributes
        .whereType<Attribute>()
        .where((a) => a.identifier)
        .map((a) => '${a.type?.base} ${a.code}')
  ].where((item) => item.trim().length > 0).join(', ');

  var body = '''
    this.concept = concept;
${concept.parents.whereType<Parent>().where((p) => p.identifier).map((p) => '    setParent(\'${p.code}\', ${p.code});').where((item) => item.trim().length > 0).join('\n')}
${concept.attributes.whereType<Attribute>().where((a) => a.identifier).map((a) => '    setAttribute(\'${a.code}\', ${a.code});').where((item) => item.trim().length > 0).join('\n')}
${_generateChildrenSetup(concept)}
''';

  return '''
  ${concept.code}Gen.withId($params) {
$body  }
''';
}

String _generateParentAccessors(Concept concept) {
  var generatedAccessors = <String, String>{};
  return concept.parents
      .whereType<Parent>()
      .map((parent) {
        Concept destinationConcept = parent.destinationConcept;
        String accessorName = parent.code;
        String accessorType = destinationConcept.code;

        // If we've already generated an accessor for this name, make it unique
        if (generatedAccessors.containsKey(accessorName)) {
          accessorName = '${accessorName}${accessorType}';
        }

        generatedAccessors[accessorName] = accessorType;

        var referenceAccessor = '''
  Reference get ${accessorName}Reference => getReference(\'${parent.code}\')!;
  
  set ${accessorName}Reference(Reference reference) => 
      setReference(\'${parent.code}\', reference);
''';

        var parentAccessor = '''
  $accessorType get $accessorName =>
      getParent(\'${parent.code}\')! as $accessorType;
  
  set $accessorName($accessorType p) => setParent(\'${parent.code}\', p);
''';

        var result = referenceAccessor + parentAccessor;

        if (result.trim().length == 0) {
          return '';
        }

        return referenceAccessor + parentAccessor;
      })
      .where((item) => item.trim().length > 0)
      .join('\n');
}

String _generateAttributeAccessors(Concept concept) {
  return concept.attributes.whereType<Attribute>().map((attribute) => '''
  ${attribute.type?.base} get ${attribute.code} => getAttribute('${attribute.code}') as ${attribute.type?.base};
  
  set ${attribute.code}(${attribute.type?.base} a) => setAttribute('${attribute.code}', a);
''').where((item) => item.trim().length > 0).join('\n');
}

String _generateChildAccessors(Concept concept) {
  return concept.children
      .whereType<Child>()
      .map((child) {
        Concept destinationConcept = child.destinationConcept;
        return '''
  ${destinationConcept.codes} get ${child.code} => getChild(\'${child.code}\')! as ${destinationConcept.codes};
''';
      })
      .where((item) => item.trim().length > 0)
      .join('\n');
}

String _generateCompareToMethod(Concept concept) {
  Id id = concept.id;
  if (id.attributeLength != 1) return '';

  var attribute =
      concept.attributes.whereType<Attribute>().firstWhere((a) => a.identifier);
  var compareBody = attribute.type?.code == 'Uri'
      ? '${attribute.code}.toString().compareTo(other.${attribute.code}.toString())'
      : '${attribute.code}.compareTo(other.${attribute.code})';
  var result = '''
  int ${attribute.code}CompareTo(${concept.code} other) => $compareBody;
''';
  return result.isEmpty ? '' : result;
}

String generateCommands(Concept concept) {
  // TODO: Implement command generation
  return '// Commands for ${concept.code} will be generated here';
}

String generateEvents(Concept concept) {
  // TODO: Implement event generation
  return '// Events for ${concept.code} will be generated here';
}

String generatePolicies(Concept concept) {
  // TODO: Implement policy generation
  return '// Policies for ${concept.code} will be generated here';
}
