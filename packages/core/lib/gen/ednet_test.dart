import 'package:ednet_core/ednet_core.dart';

String genEDNetGen(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln('// test/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}_gen.dart')
    ..writeln()
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln()
    ..writeln('import \'../../../lib/${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';')
    ..writeln()
    ..writeln('void genCode(CoreRepository repository) {')
    ..writeln('  repository.gen(\'${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}\');')
    ..writeln('}')
    ..writeln()
    ..writeln('void initData(CoreRepository repository) {')
    ..writeln('  final ${domain.codeFirstLetterLower}Domain =')
    ..writeln('    repository.getDomainModels(\'${domain.code}\');')
    ..writeln('  final ${model.codeFirstLetterLower}Model =')
    ..writeln('    ${domain.codeFirstLetterLower}Domain?.getModelEntries(\'${model.code}\') as ${model.code}Model?;')
    ..writeln('  ${model.codeFirstLetterLower}Model?.init();')
    ..writeln('  //${model.codeFirstLetterLower}Model.display();')
    ..writeln('}')
    ..writeln()
    ..writeln('void main() {')
    ..writeln('  final repository = CoreRepository();')
    ..writeln('  genCode(repository);')
    ..writeln('  //initData(repository);')
    ..writeln('}')
    ..writeln();

  return buffer.toString();
}

String genEDNetTest(CoreRepository repo, Model model, Concept entryConcept) {
  Domain domain = model.domain;
  final repoName = '${domain.codeFirstLetterUpper}${model.codeFirstLetterUpper}Repo';
  var sc = ' \n';
  sc = '$sc// test/${domain.codeLowerUnderscore}/'
      '${model.codeLowerUnderscore}/${domain.codeLowerUnderscore}_'
      '${model.codeLowerUnderscore}_${entryConcept.codeLowerUnderscore}_'
      'test.dart \n';
  sc = '$sc \n';

  sc = '${sc}import \'package:test/test.dart\'; \n';
  sc = '${sc}import \'package:ednet_core/ednet_core.dart\'; \n';
  sc = '${sc}import \'../../../lib/${domain.codeLowerUnderscore}_'
      '${model.codeLowerUnderscore}.dart\'; \n';
  sc = '$sc \n';

  var entities = entryConcept.codePluralFirstLetterLower;
  var entity = entryConcept.codeFirstLetterLower;
  var entity2 = entryConcept.code;
  var entities2 = entryConcept.codePluralFirstLetterUpper;
//var entityConcept = '${entities}.concept';

  sc = '${sc}void test${domain.code}${model.code}'
      '${entryConcept.codePluralFirstLetterUpper}( \n';
  sc = '$sc    ${domain.code}Domain ${domain.codeFirstLetterLower}Domain, '
      '${model.code}Model ${model.codeFirstLetterLower}Model, '
      '$entities2 $entities) { \n';
  sc = '$sc  DomainSession session; \n';
  sc = '$sc  group(\'Testing ${domain.code}.${model.code}.$entity2\', () { \n';
  sc = '$sc    session = ${domain.codeFirstLetterLower}Domain.newSession();  \n';
//sc = '${sc}    expect(${model.codeFirstLetterLower}Model.isEmpty, isTrue); \n';
  sc = '$sc    setUp(() { \n';
  sc = '$sc      ${model.codeFirstLetterLower}Model.init(); \n';
  sc = '$sc    }); \n';
  sc = '$sc    tearDown(() { \n';
  sc = '$sc      ${model.codeFirstLetterLower}Model.clear(); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Not empty model\', () { \n';
  sc = '$sc      expect(${model.codeFirstLetterLower}Model.isEmpty, '
      'isFalse); \n';
  sc = '$sc      expect($entities.isEmpty, isFalse); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Empty model\', () { \n';
  sc = '$sc      ${model.codeFirstLetterLower}Model.clear(); \n';
  sc = '$sc      expect(${model.codeFirstLetterLower}Model.isEmpty, '
      'isTrue); \n';
  sc = '$sc      expect($entities.isEmpty, isTrue); \n';
  sc = '$sc      expect($entities.exceptions.isEmpty, isTrue); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'From model to JSON\', () { \n';
  sc = '$sc      final json = ${model.codeFirstLetterLower}Model.toJson(); \n';
  sc = '$sc      expect(json, isNotNull); \n';
  sc = '$sc \n';
  sc = '$sc      print(json); \n';
  sc = '$sc      //${model.codeFirstLetterLower}Model.displayJson(); \n';
  sc = '$sc      //${model.codeFirstLetterLower}Model.display(); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'From JSON to model\', () { \n';
  sc = '$sc      final json = ${model.codeFirstLetterLower}Model.toJson(); \n';
  sc = '$sc      ${model.codeFirstLetterLower}Model.clear(); \n';
  sc = '$sc      expect(${model.codeFirstLetterLower}Model.isEmpty, '
      'isTrue); \n';
  sc = '$sc      ${model.codeFirstLetterLower}Model.fromJson(json); \n';
  sc = '$sc      expect(${model.codeFirstLetterLower}Model.isEmpty, '
      'isFalse); \n';
  sc = '$sc \n';
  sc = '$sc      ${model.codeFirstLetterLower}Model.display(); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'From model entry to JSON\', () { \n';
  sc = '$sc      final json = ${model.codeFirstLetterLower}Model.'
      'fromEntryToJson(\'$entity2\'); \n';
  sc = '$sc      expect(json, isNotNull); \n';
  sc = '$sc \n';
  sc = '$sc      print(json); \n';
  sc = '$sc      //${model.codeFirstLetterLower}Model.'
      'displayEntryJson(\'$entity2\'); \n';
  sc = '$sc      //${model.codeFirstLetterLower}Model.displayJson(); \n';
  sc = '$sc      //${model.codeFirstLetterLower}Model.display(); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'From JSON to model entry\', () { \n';
  sc = '$sc      final json = ${model.codeFirstLetterLower}Model.'
      'fromEntryToJson(\'$entity2\'); \n';
  sc = '$sc      $entities.clear(); \n';
  sc = '$sc      expect($entities.isEmpty, isTrue); \n';
  sc = '$sc      ${model.codeFirstLetterLower}Model.fromJsonToEntry(json); \n';
  sc = '$sc      expect($entities.isEmpty, isFalse); \n';
  sc = '$sc \n';
  sc = '$sc      $entities.display(title: \'From JSON to model entry\'); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Add $entity required error\', () { \n';
  var requiredNonIdAttribute = findRequiredNonIdAttribute(entryConcept);
  if (requiredNonIdAttribute != null) {
    sc = '$sc      final ${entity}Concept = $entities.concept; \n';
    sc = '$sc      var ${entity}Count = $entities.length; \n';
    sc = '$sc      final $entity = $entity2(${entity}Concept); \n';
    sc = '$sc      final isAdded = $entities.add($entity); \n';
    sc = '$sc      expect(isAdded, isFalse); \n';
    sc = '$sc      expect($entities.length, equals(${entity}Count)); \n';
    sc = '$sc      expect($entities.exceptions.length, greaterThan(0)); \n';
    sc = '$sc      expect($entities.exceptions.toList()[0].category, '
        'equals(\'required\')); \n';
    sc = '$sc \n';
    sc = '$sc      $entities.exceptions.display(title: \'Add $entity required '
        'error\'); \n';
  } else {
    sc = '$sc      // no required attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Add $entity unique error\', () { \n';
  var idAttribute = findIdAttribute(entryConcept);
  if (idAttribute != null) {
    if (idAttribute.increment == null) {
      sc = '$sc      final ${entity}Concept = $entities.concept; \n';
      sc = '$sc      var ${entity}Count = $entities.length; \n';
      sc = '$sc      final $entity = $entity2(${entity}Concept); \n';
      sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
      sc = '$sc      $entity.${idAttribute.code} = '
          'random$entity2.${idAttribute.code}; \n';
      sc = '$sc      final added = $entities.add($entity); \n';
      sc = '$sc      expect(added, isFalse); \n';
      sc = '$sc      expect($entities.length, equals(${entity}Count)); \n';
      sc = '$sc      expect($entities.exceptions.length, greaterThan(0)); \n';
      sc = '$sc \n';
      sc = '$sc      $entities.exceptions.display(title: \'Add $entity unique '
          'error\'); \n';
    } else {
      sc = '$sc      // id attribute defined as increment, cannot update it \n';
    }
  } else {
    sc = '$sc      // no id attribute \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Not found $entity by oid\', () { \n';
  sc = '$sc      final ednetOid = Oid.ts(1345648254063); \n';
  sc = '$sc      final $entity = $entities.singleWhereOid(ednetOid); \n';
  sc = '$sc      expect($entity, isNull); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Find $entity by oid\', () { \n';
  sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc      final $entity = '
      '$entities.singleWhereOid(random$entity2.oid); \n';
  sc = '$sc      expect($entity, isNotNull); \n';
  sc = '$sc      expect($entity, equals(random$entity2)); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Find $entity by attribute id\', () { \n';
  if (idAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    sc = '$sc      final $entity = \n';
    sc = '$sc          $entities.singleWhereAttributeId('
        '\'${idAttribute.code}\', random$entity2.${idAttribute.code}); \n';
    sc = '$sc      expect($entity, isNotNull); \n';
    sc = '$sc      expect($entity!.${idAttribute.code}, '
        'equals(random$entity2.${idAttribute.code})); \n';
  } else {
    sc = '$sc      // no id attribute \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Find $entity by required attribute\', () { \n';
  if (requiredNonIdAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    sc = '$sc      final $entity = \n';
    sc = '$sc          $entities.firstWhereAttribute('
        '\'${requiredNonIdAttribute.code}\', '
        'random$entity2.${requiredNonIdAttribute.code}); \n';
    sc = '$sc      expect($entity, isNotNull); \n';
    sc = '$sc      expect($entity.${requiredNonIdAttribute.code}, '
        'equals(random$entity2.${requiredNonIdAttribute.code})); \n';
  } else {
    sc = '$sc      // no required attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Find $entity by attribute\', () { \n';
  var nonRequiredAttribute = findNonRequiredAttribute(entryConcept);
  if (nonRequiredAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    sc = '$sc      final $entity = \n';
    sc = '$sc          $entities.firstWhereAttribute('
        '\'${nonRequiredAttribute.code}\', random$entity2.'
        '${nonRequiredAttribute.code}); \n';
    sc = '$sc      expect($entity, isNotNull); \n';
    sc = '$sc      expect($entity.${nonRequiredAttribute.code}, '
        'equals(random$entity2.${nonRequiredAttribute.code})); \n';
  } else {
    sc = '$sc      // no attribute that is not required \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Select $entities by attribute\', () { \n';
  if (nonRequiredAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    sc = '$sc      final selected$entities2 = \n';
    sc = '$sc          $entities.selectWhereAttribute('
        '\'${nonRequiredAttribute.code}\', random$entity2.'
        '${nonRequiredAttribute.code}); \n';
    sc = '$sc      expect(selected$entities2.isEmpty, isFalse); \n';
    sc = '$sc      for (final se in selected$entities2) {';
    sc = '$sc        expect(se.${nonRequiredAttribute.code}, equals(random$entity2.${nonRequiredAttribute.code}));';
    sc = '$sc      }';
    sc = '$sc \n';
    sc = '$sc      //selected$entities2.display(title: \'Select $entities by '
        '${nonRequiredAttribute.code}\'); \n';
  } else {
    sc = '$sc      // no attribute that is not required \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Select $entities by required attribute\', () { \n';
  if (requiredNonIdAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    sc = '$sc      final selected$entities2 = \n';
    sc = '$sc          $entities.selectWhereAttribute('
        '\'${requiredNonIdAttribute.code}\', '
        'random$entity2.${requiredNonIdAttribute.code}); \n';
    sc = '$sc      expect(selected$entities2.isEmpty, isFalse); \n';
    sc = '$sc      selected$entities2.forEach((se) => \n';
    sc = '$sc          expect(se.${requiredNonIdAttribute.code}, '
        'equals(random$entity2.${requiredNonIdAttribute.code}))); \n';
    sc = '$sc \n';
    sc = '$sc      //selected$entities2.display(title: \'Select $entities by '
        '${requiredNonIdAttribute.code}\'); \n';
  } else {
    sc = '$sc      // no required attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Select $entities by attribute, then add\', () { \n';
  var nonIdAttribute = findNonIdAttribute(entryConcept);
  if (nonIdAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    sc = '$sc      final selected$entities2 = \n';
    sc = '$sc          $entities.selectWhereAttribute('
        '\'${nonIdAttribute.code}\', random$entity2.${nonIdAttribute.code}); \n';
    sc = '$sc      expect(selected$entities2.isEmpty, isFalse); \n';
    sc = '$sc      expect(selected$entities2.source?.isEmpty, isFalse); \n';
    sc = '$sc      var ${entities}Count = $entities.length; \n';
    sc = '$sc \n';
    sc = '$sc      final $entity = $entity2($entities.concept) \n';
    var attributesSet = setTestAttributesRandomly(entryConcept, entity);
    sc = '$sc$attributesSet';
    sc = '$sc      final added = selected$entities2.add($entity); \n';
    sc = '$sc      expect(added, isTrue); \n';
    sc = '$sc      expect($entities.length, equals(++${entities}Count)); \n';
    sc = '$sc \n';
    sc = '$sc      //selected$entities2.display(title: \n';
    sc = '$sc      //  \'Select $entities by attribute, then add\'); \n';
    sc = '$sc      //$entities.display(title: \'All $entities\'); \n';
  } else {
    sc = '$sc      // no attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Select $entities by attribute, then remove\', () { \n';
  if (nonIdAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    sc = '$sc      final selected$entities2 = \n';
    sc = '$sc          $entities.selectWhereAttribute('
        '\'${nonIdAttribute.code}\', random$entity2.${nonIdAttribute.code}); \n';
    sc = '$sc      expect(selected$entities2.isEmpty, isFalse); \n';
    sc = '$sc      expect(selected$entities2.source?.isEmpty, isFalse); \n';
    sc = '$sc      var ${entities}Count = $entities.length; \n';
    sc = '$sc \n';
    sc = '$sc      final removed = selected$entities2.remove(random$entity2); \n';
    sc = '$sc      expect(removed, isTrue); \n';
    sc = '$sc      expect($entities.length, equals(--${entities}Count)); \n';
    sc = '$sc \n';
    sc = '$sc      random$entity2.display(prefix: \'removed\'); \n';
    sc = '$sc      //selected$entities2.display(title: \n';
    sc = '$sc      //  \'Select $entities by attribute, then remove\'); \n';
    sc = '$sc      //$entities.display(title: \'All $entities\'); \n';
  } else {
    sc = '$sc      // no attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Sort $entities\', () { \n';
  if (idAttribute != null) {
    sc = '$sc      $entities.sort(); \n';
    sc = '$sc \n';
    sc = '$sc      //$entities.display(title: \'Sort $entities\'); \n';
  } else {
    sc = '$sc      // no id attribute \n';
    sc = '$sc      // add compareTo method in the specific $entity2 class \n';
    sc = '$sc      /* \n';
    sc = '$sc      $entities.sort(); \n';
    sc = '$sc \n';
    sc = '$sc      //$entities.display(title: \'Sort $entities\'); \n';
    sc = '$sc      */ \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Order $entities\', () { \n';
  if (idAttribute != null) {
    sc = '$sc      final ordered$entities2 = $entities.order(); \n';
    sc = '$sc      expect(ordered$entities2.isEmpty, isFalse); \n';
    sc = '$sc      expect(ordered$entities2.length, '
        'equals($entities.length)); \n';
    sc = '$sc      expect(ordered$entities2.source?.isEmpty, isFalse); \n';
    sc = '$sc      expect(ordered$entities2.source?.length, '
        'equals($entities.length)); \n';
    sc = '$sc      expect(ordered$entities2, isNot(same($entities))); \n';
    sc = '$sc \n';
    sc = '$sc      //ordered$entities2.display(title: \'Order $entities\'); \n';
  } else {
    sc = '$sc      // no id attribute \n';
    sc = '$sc      // add compareTo method in the specific $entity2 class \n';
    sc = '$sc      /* \n';
    sc = '$sc      final ordered$entities2 = $entities.order(); \n';
    sc = '$sc      expect(ordered$entities2.isEmpty, isFalse); \n';
    sc = '$sc      expect(ordered$entities2.length, '
        'equals($entities.length)); \n';
    sc = '$sc      expect(ordered$entities2.source?.isEmpty, isFalse); \n';
    sc = '$sc      expect(ordered$entities2.source?.length, '
        'equals($entities.length)); \n';
    sc = '$sc      expect(ordered$entities2, isNot(same($entities))); \n';
    sc = '$sc \n';
    sc = '$sc      //ordered$entities2.display(title: \'Order $entities\'); \n';
    sc = '$sc      */ \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Copy $entities\', () { \n';
  sc = '$sc      final copied$entities2 = $entities.copy(); \n';
  sc = '$sc      expect(copied$entities2.isEmpty, isFalse); \n';
  sc = '$sc      expect(copied$entities2.length, '
      'equals($entities.length)); \n';
  sc = '$sc      expect(copied$entities2, isNot(same($entities))); \n';
  sc = '$sc      for (final e in copied$entities2) {';
  sc = '$sc        expect(e, equals($entities.singleWhereOid(e.oid)));';
  sc = '$sc      }';
  sc = '$sc \n';

  if (entryConcept.hasId) {
    sc = '$sc      for (final e in copied$entities2) {';
    sc = '$sc        expect(e, isNot(same($entities.singleWhereId(e.id!))));';
    sc = '$sc      }';
  }
  sc = '$sc \n';
  sc = '$sc      //copied$entities2.display(title: "Copy $entities"); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'True for every $entity\', () { \n';
  if (requiredNonIdAttribute != null) {
    sc = '$sc      expect($entities.every((e) => '
        'e.${requiredNonIdAttribute.code} != null), isTrue); \n';
  } else {
    sc = '$sc      // no required attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Random $entity\', () { \n';
  sc = '$sc      final ${entity}1 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc      expect(${entity}1, isNotNull); \n';
  sc = '$sc      final ${entity}2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc      expect(${entity}2, isNotNull); \n';
  sc = '$sc \n';
  sc = '$sc      //${entity}1.display(prefix: \'random1\'); \n';
  sc = '$sc      //${entity}2.display(prefix: \'random2\'); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Update $entity id with try\', () { \n';
  if (idAttribute != null) {
    if (idAttribute.increment == null) {
      sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
      sc = '$sc      final beforeUpdate = random$entity2.${idAttribute.code}; \n';
      sc = '$sc      try { \n';
      var attributeSet = setTestAttributeRandomly(idAttribute, 'random$entity2');
      sc = '$sc        random$entity2$attributeSet;';
      sc = '$sc      } on UpdateException catch (e) { \n';
      sc = '$sc        expect(random$entity2.${idAttribute.code}, '
          'equals(beforeUpdate)); \n';
      sc = '$sc      } \n';
    } else {
      sc = '$sc      // id attribute defined as increment, cannot update it \n';
    }
  } else {
    sc = '$sc      // no id attribute \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Update $entity id without try\', () { \n';
  if (idAttribute != null) {
    if (idAttribute.increment == null) {
      sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
      sc = '$sc      final beforeUpdateValue = '
          'random$entity2.${idAttribute.code}; \n';
      var value = genAttributeTextRandomly(idAttribute);
      sc = '$sc      expect(() => random$entity2.${idAttribute.code} = '
          '$value, throws); \n';
      sc = '$sc      expect(random$entity2.${idAttribute.code}, '
          'equals(beforeUpdateValue)); \n';
    } else {
      sc = '$sc      // id attribute defined as increment, cannot update it \n';
    }
  } else {
    sc = '$sc      // no id attribute \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Update $entity id with success\', () { \n';
  if (idAttribute != null) {
    if (idAttribute.increment == null) {
      sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
      sc = '$sc      final afterUpdateEntity = random$entity2.copy(); \n';
      sc = '$sc      final attribute = random$entity2.concept.attributes.'
          'singleWhereCode(\'${idAttribute.code}\'); \n';
      sc = '$sc      expect(attribute?.update, isFalse); \n';
      sc = '$sc      attribute?.update = true; \n';
      var value = genAttributeTextRandomly(idAttribute);
      sc = '$sc      afterUpdateEntity.${idAttribute.code} = $value; \n';
      sc = '$sc      expect(afterUpdateEntity.${idAttribute.code}, '
          'equals($value)); \n';
      sc = '$sc      attribute?.update = false; \n';
      sc = '$sc      final updated = $entities.update(random$entity2, '
          'afterUpdateEntity); \n';
      sc = '$sc      expect(updated, isTrue); \n';
      sc = '$sc \n';
      sc = '$sc      final entity = $entities.singleWhereAttributeId('
          '\'${idAttribute.code}\', $value); \n';
      sc = '$sc      expect(entity, isNotNull); \n';
      sc = '$sc      expect(entity!.${idAttribute.code}, equals($value)); \n';
      sc = '$sc \n';
      sc = '$sc      //$entities.display(\'After update $entity id\'); \n';
    } else {
      sc = '$sc      // id attribute defined as increment, cannot update it \n';
    }
  } else {
    sc = '$sc      // no id attribute \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Update $entity non id attribute with failure\', () { \n';
  if (nonIdAttribute != null) {
    sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
//sc = '${sc}      var beforeUpdateValue = '
//     'random${Entity}.${nonIdAttribute.code}; \n';
    var value = genAttributeTextRandomly(nonIdAttribute);
    sc = '$sc      final afterUpdateEntity = random$entity2.copy()..${nonIdAttribute.code} = $value; \n';
    sc = '$sc      expect(afterUpdateEntity.${nonIdAttribute.code}, '
        'equals($value)); \n';
    sc = '$sc      // $entities.update can only be used if oid, code or '
        'id is set. \n';
    sc = '$sc      expect(() => $entities.update(random$entity2, '
        'afterUpdateEntity), throwsA(isA<Exception>())); \n';
  } else {
    sc = '$sc      // no attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Copy Equality\', () { \n';
  sc = '$sc      final random$entity2 = ${model.codeFirstLetterLower}Model.$entities.random()..display(prefix:\'before copy: \'); \n';
  sc = '$sc      final random${entity2}Copy = random$entity2.copy()..display(prefix:\'after copy: \'); \n';
  sc = '$sc      expect(random$entity2, equals(random${entity2}Copy)); \n';
  sc = '$sc      expect(random$entity2.oid, equals(random${entity2}Copy.oid)); \n';
  sc = '$sc      expect(random$entity2.code, '
      'equals(random${entity2}Copy.code)); \n';
  for (Attribute attribute in entryConcept.attributes.whereType<Attribute>()) {
    sc = '$sc      expect(random$entity2.${attribute.code}, '
        'equals(random${entity2}Copy.${attribute.code})); \n';
  }
  sc = '$sc \n';

  if (idAttribute != null) {
    sc = '$sc      expect(random$entity2.id, isNotNull); \n';
    sc = '$sc      expect(random${entity2}Copy.id, isNotNull); \n';
    sc = '$sc      expect(random$entity2.id, equals(random${entity2}Copy.id)); \n';
    sc = '$sc \n';
    sc = '$sc      var idsEqual = false; \n';
    sc = '$sc      if (random$entity2.id == random${entity2}Copy.id) { \n';
    sc = '$sc        idsEqual = true; \n';
    sc = '$sc      } \n';
    sc = '$sc      expect(idsEqual, isTrue); \n';
    sc = '$sc \n';
    sc = '$sc      idsEqual = false; \n';
    sc = '$sc      if (random$entity2.id!.equals(random${entity2}Copy.id!)) { \n';
    sc = '$sc        idsEqual = true; \n';
    sc = '$sc      } \n';
    sc = '$sc      expect(idsEqual, isTrue); \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'$entity action undo and redo\', () { \n';
//sc = '${sc}      final ${entity}Concept = ${entities}.concept; \n';
  sc = '$sc      var ${entity}Count = $entities.length; \n';
  sc = '$sc      ${createTestEntryEntityRandomly(entryConcept, withChildren: false, model: model)}';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc      $entities.remove($entity); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      final action = AddCommand(session, $entities, $entity)..doIt(); \n';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      action.undo(); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      action.redo(); \n';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'$entity session undo and redo\', () { \n';
//sc = '${sc}      final ${entity}Concept = ${entities}.concept; \n';
  sc = '$sc      var ${entity}Count = $entities.length; \n';
  sc = '$sc      ${createTestEntryEntityRandomly(entryConcept, withChildren: false, model: model)}';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc      $entities.remove($entity); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      AddCommand(session, $entities, $entity).doIt();; \n';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.undo(); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.redo(); \n';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'$entity2 update undo and redo\', () { \n';
  if (nonIdAttribute != null) {
    sc = '$sc      final $entity = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
    var value = genAttributeTextRandomly(nonIdAttribute);
    sc = '$sc      final action = SetAttributeCommand(session, '
        '$entity, \'${nonIdAttribute.code}\', $value)..doIt(); \n';
    sc = '$sc \n';
    sc = '$sc      session.past.undo(); \n';
    sc = '$sc      expect($entity.${nonIdAttribute.code}, '
        'equals(action.before)); \n';
    sc = '$sc \n';
    sc = '$sc      session.past.redo(); \n';
    sc = '$sc      expect($entity.${nonIdAttribute.code}, '
        'equals(action.after)); \n';
  } else {
    sc = '$sc      // no attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'$entity2 action with multiple undos and redos\', () { \n';
  sc = '$sc      var ${entity}Count = $entities.length; \n';
  sc = '$sc      final ${entity}1 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc \n';
  sc = '$sc      RemoveCommand(session, $entities, '
      '${entity}1).doIt(); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      final ${entity}2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc \n';
  sc = '$sc      RemoveCommand(session, $entities, '
      '${entity}2).doIt(); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      //session.past.display(); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.undo(); \n';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.undo(); \n';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      //session.past.display(); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.redo(); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.redo(); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      //session.past.display(); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Transaction undo and redo\', () { \n';
  sc = '$sc      var ${entity}Count = $entities.length; \n';
  sc = '$sc      final ${entity}1 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc      var ${entity}2 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc      while (${entity}1 == ${entity}2) { \n';
  sc = '$sc        ${entity}2 = ${model.codeFirstLetterLower}Model.$entities.random();  \n';
  sc = '$sc      } \n';
  sc = '$sc      final action1 = RemoveCommand(session, $entities, '
      '${entity}1); \n';
  sc = '$sc      final action2 = RemoveCommand(session, $entities, '
      '${entity}2); \n';
  sc = '$sc \n';
  sc = '$sc      Transaction(\'two removes on $entities\', session) \n';
  sc = '$sc        ..add(action1) \n';
  sc = '$sc        ..add(action2) \n';
  sc = '$sc        ..doIt(); \n';
  sc = '$sc      ${entity}Count = ${entity}Count - 2; \n';
  sc = '$sc      expect($entities.length, equals(${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      $entities.display(title:\'Transaction Done\'); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.undo(); \n';
  sc = '$sc      ${entity}Count = ${entity}Count + 2; \n';
  sc = '$sc      expect($entities.length, equals(${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      $entities.display(title:\'Transaction Undone\'); \n';
  sc = '$sc \n';
  sc = '$sc      session.past.redo(); \n';
  sc = '$sc      ${entity}Count = ${entity}Count - 2; \n';
  sc = '$sc      expect($entities.length, equals(${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      $entities.display(title:\'Transaction Redone\'); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Transaction with one action error\', () { \n';
  sc = '$sc      final ${entity}Count = $entities.length; \n';
  sc = '$sc      final ${entity}1 = ${model.codeFirstLetterLower}Model.$entities.random(); \n';
  sc = '$sc      final ${entity}2 = ${entity}1; \n';
  sc = '$sc      final action1 = RemoveCommand(session, $entities, '
      '${entity}1); \n';
  sc = '$sc      final action2 = RemoveCommand(session, $entities, '
      '${entity}2); \n';
  sc = '$sc \n';
  sc = '$sc      final transaction = Transaction( \n';
  sc = '$sc        \'two removes on $entities, with an error on the second\',\n';
  sc = '$sc        session, \n';
  sc = '$sc        )\n';
  sc = '$sc        ..add(action1) \n';
  sc = '$sc        ..add(action2); \n';
  sc = '$sc      final done = transaction.doIt(); \n';
  sc = '$sc      expect(done, isFalse); \n';
  sc = '$sc      expect($entities.length, equals(${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      //$entities.display(title:\'Transaction with an error\'); \n';
  sc = '$sc    }); \n';
  sc = '$sc \n';

  sc = '$sc    test(\'Reactions to $entity actions\', () { \n';
//sc = '${sc}      final ${entity}Concept = ${entities}.concept; \n';
  sc = '$sc      var ${entity}Count = $entities.length; \n';
  sc = '$sc \n';
  sc = '$sc      final reaction = ${entity2}Reaction(); \n';
  sc = '$sc      expect(reaction, isNotNull); \n';
  sc = '$sc \n';
  sc = '$sc      ${domain.codeFirstLetterLower}Domain.startCommandReaction(reaction); \n';
  sc = '$sc      ${createTestEntryEntityRandomly(entryConcept, withChildren: false, model: model)}';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc      $entities.remove($entity); \n';
  sc = '$sc      expect($entities.length, equals(--${entity}Count)); \n';
  sc = '$sc \n';
  sc = '$sc      final session = ${domain.codeFirstLetterLower}Domain.newSession(); \n';
  sc = '$sc      AddCommand(session, $entities, '
      '$entity).doIt(); \n';
  sc = '$sc      expect($entities.length, equals(++${entity}Count)); \n';
  sc = '$sc      expect(reaction.reactedOnAdd, isTrue); \n';
  sc = '$sc \n';
  if (nonIdAttribute != null) {
    var value = genAttributeTextRandomly(nonIdAttribute);
    sc = '$sc      SetAttributeCommand( \n';
    sc = '$sc        session,\n';
    sc = '$sc        $entity,\n';
    sc = '$sc        \'${nonIdAttribute.code}\',\n';
    sc = '$sc        $value,\n';
    sc = '$sc      ).doIt();\n';
    sc = '$sc      expect(reaction.reactedOnUpdate, isTrue); \n';
    sc = '$sc      ${domain.codeFirstLetterLower}Domain.cancelCommandReaction(reaction); \n';
  } else {
    sc = '$sc      // no attribute that is not id \n';
  }
  sc = '$sc    }); \n';
  sc = '$sc \n';

// after the last test

  sc = '$sc  }); \n';
  sc = '$sc} \n';
  sc = '$sc \n';

  sc = '${sc}class ${entity2}Reaction implements ICommandReaction { \n';
  sc = '$sc  bool reactedOnAdd    = false; \n';
  sc = '$sc  bool reactedOnUpdate = false; \n';
  sc = '$sc \n';
  sc = '$sc  @override';
  sc = '$sc  void react(ICommand action) { \n';
  sc = '$sc    if (action is IEntitiesCommand) { \n';
  sc = '$sc      reactedOnAdd = true; \n';
  sc = '$sc    } else if (action is IEntityCommand) { \n';
  sc = '$sc      reactedOnUpdate = true; \n';
  sc = '$sc    } \n';
  sc = '$sc  } \n';
  sc = '$sc} \n';
  sc = '$sc \n';

  sc = '${sc}void main() { \n';
  sc = '$sc  final repository = $repoName(); \n';
  sc = '$sc  final ${domain.codeFirstLetterLower}Domain = '
      'repository.getDomainModels(\'${domain.code}\') as ${domain.code}Domain?;\n';
  sc = '$sc  assert(${domain.codeFirstLetterLower}Domain != null, \'${domain.code}Domain is not defined\'); \n';
  sc = '$sc  final ${model.codeFirstLetterLower}Model = '
      '${domain.codeFirstLetterLower}Domain!.getModelEntries(\'${model.code}\') as ${model.code}Model?;\n';
  sc = '$sc  assert(${model.codeFirstLetterLower}Model != null, \'${model.code}Model is not defined\'); \n';
  sc = '$sc  final $entities = '
      '${model.codeFirstLetterLower}Model!.$entities; \n';
  sc = '$sc  test${domain.code}${model.code}'
      '${entryConcept.codePluralFirstLetterUpper}('
      '${domain.codeFirstLetterLower}Domain, '
      '${model.codeFirstLetterLower}Model, $entities); \n';
  sc = '$sc} \n';
  sc = '$sc \n';

  return sc;
}
