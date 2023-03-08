part of ednet_core;

String genConceptGen(Concept concept, String library) {
  Model model = concept.model;
  Domain domain = model.domain;

  var sc = 'part of $library; \n';
  sc = '$sc \n';
  sc = '$sc// lib/gen/${domain.codeLowerUnderscore}'
      '/${model.codeLowerUnderscore}/${concept.codesLowerUnderscore}.dart \n';
  sc = '$sc \n';
  sc = '${sc}abstract class ${concept.code}Gen extends '
      'Entity<${concept.code}> { \n';
  sc = '$sc \n';
  if (concept.children.isEmpty) {
    sc = '$sc  ${concept.code}Gen(Concept concept) { \n';
    sc = '$sc    this.concept = concept; \n';
    sc = '$sc  } \n';
  } else {
    sc = '$sc  ${concept.code}Gen(Concept concept) { \n';
    sc = '$sc    this.concept = concept; \n';
    var generatedConcepts = <Concept>[];
    for (Child child in concept.children.whereType<Child>()) {
      Concept destinationConcept = child.destinationConcept;
      if (!generatedConcepts.contains(destinationConcept)) {
        generatedConcepts.add(destinationConcept);
        sc = '$sc    Concept ${destinationConcept.codeFirstLetterLower}'
            'Concept = concept.model.concepts.singleWhereCode('
            '"${destinationConcept.code}") as Concept; \n';
        sc = '$sc    assert(${destinationConcept.codeFirstLetterLower}Concept != null); \n';
      }
      sc = '$sc    setChild("${child.code}", ${destinationConcept.codes}('
          '${destinationConcept.codeFirstLetterLower}Concept)); \n';
    }
    sc = '$sc  } \n';
  }

  sc = '$sc \n';

  Id id = concept.id;
  if (id.length > 0) {
    sc = '$sc  ${concept.code}Gen.withId(Concept concept';
    if (id.referenceLength > 0) {
      for (Parent parent in concept.parents.whereType<Parent>()) {
        if (parent.identifier) {
          Concept destinationConcept = parent.destinationConcept;
          sc = '$sc, ${destinationConcept.code} ${parent.code}';
        }
      }
    }
    if (id.attributeLength > 0) {
      for (Attribute attribute in concept.attributes.whereType<Attribute>()) {
        if (attribute.identifier) {
          sc = '$sc, ${attribute.type?.base} ${attribute.code}';
        }
      }
    }
    sc = '$sc) { \n';
    sc = '$sc    this.concept = concept; \n';

    if (id.referenceLength > 0) {
      for (Parent parent in concept.parents.whereType<Parent>()) {
        if (parent.identifier) {
          sc = '$sc    setParent("${parent.code}", ${parent.code}); \n';
        }
      }
    }
    if (id.attributeLength > 0) {
      for (Attribute attribute in concept.attributes.whereType<Attribute>()) {
        if (attribute.identifier) {
          sc = '$sc    setAttribute("${attribute.code}", '
              '${attribute.code}); \n';
        }
      }
    }
    var generatedConcepts = <Concept>[];
    for (Child child in concept.children.whereType<Child>()) {
      Concept destinationConcept = child.destinationConcept;
      if (!generatedConcepts.contains(destinationConcept)) {
        generatedConcepts.add(destinationConcept);
        sc = '$sc    Concept ${destinationConcept.codeFirstLetterLower}'
            'Concept = concept.model.concepts.singleWhereCode('
            '"${destinationConcept.code}"); \n';
      }
      sc = '$sc    setChild("${child.code}", ${destinationConcept.codes}('
          '${destinationConcept.codeFirstLetterLower}Concept)); \n';
    }
    sc = '$sc  } \n';
    sc = '$sc \n';
  }

  for (Parent parent in concept.parents.whereType<Parent>()) {
    Concept destinationConcept = parent.destinationConcept;
    sc = '$sc  Reference get ${parent.code}Reference => '
        'getReference("${parent.code}") as Reference; \n ';
    sc = '$sc void set ${parent.code}Reference(Reference reference) { '
        'setReference("${parent.code}", reference); } \n ';
    sc = '$sc \n';
    sc = '$sc  ${destinationConcept.code} get ${parent.code} => '
        'getParent("${parent.code}") as ${destinationConcept.code}; \n ';
    sc = '$sc void set ${parent.code}(${destinationConcept.code} p) { '
        'setParent("${parent.code}", p); } \n ';
    sc = '$sc \n';
  }
  for (Attribute attribute in concept.attributes.whereType<Attribute>()) {
    sc = '$sc  ${attribute.type?.base} get ${attribute.code} => '
        'getAttribute("${attribute.code}"); \n ';
    sc = '$sc void set ${attribute.code}(${attribute.type?.base} a) { '
        'setAttribute("${attribute.code}", a); } \n ';
    sc = '$sc \n';
  }
  for (Child child in concept.children.whereType<Child>()) {
    Concept destinationConcept = child.destinationConcept;
    sc = '$sc  ${destinationConcept.codes} get ${child.code} => '
        'getChild("${child.code}") as ${destinationConcept.codes}; \n ';
    // set child?
    sc = '$sc \n';
  }

  sc = '$sc  ${concept.code} newEntity() => ${concept.code}(concept); \n';
  sc = '$sc  ${concept.codes} newEntities() => '
      '${concept.codes}(concept); \n ';
  sc = '$sc \n';

  if (id.attributeLength == 1) {
    for (Attribute attribute in concept.attributes.whereType<Attribute>()) {
      if (attribute.identifier) {
        sc = '$sc  int ${attribute.code}CompareTo(${concept.code} other) { \n';
        if (attribute.type?.code == 'Uri') {
          sc = '$sc    return ${attribute.code}.toString().compareTo('
              'other.${attribute.code}.toString()); \n';
        } else {
          sc = '$sc    return ${attribute.code}.compareTo('
              'other.${attribute.code}); \n';
        }
        sc = '$sc  } \n';
        sc = '$sc \n';
      }
    }
  }

  sc = '$sc} \n';
  sc = '$sc \n';

  sc = '${sc}abstract class ${concept.codes}Gen extends '
      'Entities<${concept.code}> { \n';
  sc = '$sc \n';
  sc = '$sc  ${concept.codes}Gen(Concept concept) { \n';
  sc = '$sc    this.concept = concept; \n';
  sc = '$sc  } \n';
  sc = '$sc \n';
  sc = '$sc  ${concept.codes} newEntities() => '
      '${concept.codes}(concept); \n';
  sc = '$sc  ${concept.code} newEntity() => ${concept.code}(concept); \n ';
  sc = '$sc \n';
  sc = '$sc} \n';
  sc = '$sc \n';

  return sc;
}
