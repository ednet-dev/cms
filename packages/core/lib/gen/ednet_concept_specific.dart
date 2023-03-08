part of ednet_core;

String genConcept(Concept concept, String library) {
  Model model = concept.model;
  Domain domain = model.domain;

  var sc = 'part of $library; \n';
  sc = '$sc \n';
  sc = '$sc// lib/${domain.codeLowerUnderscore}/'
      '${model.codeLowerUnderscore}/${concept.codesLowerUnderscore}.dart \n';
  sc = '$sc \n';
  sc = '${sc}class ${concept.code} extends ${concept.code}Gen { \n';
  sc = '$sc \n';
  sc = '$sc  ${concept.code}(Concept concept) : super(concept); \n';
  sc = '$sc \n';

  Id id = concept.id;
  if (id.length > 0) {
    sc = '$sc  ${concept.code}.withId(Concept concept';
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
    sc = '$sc) : \n';
    sc = '$sc    super.withId(concept';
    if (id.referenceLength > 0) {
      for (Parent parent in concept.parents.whereType<Parent>()) {
        if (parent.identifier) {
          sc = '$sc, ${parent.code}';
        }
      }
    }
    if (id.attributeLength > 0) {
      for (Attribute attribute in concept.attributes.whereType<Attribute>()) {
        if (attribute.identifier) {
          sc = '$sc, ${attribute.code}';
        }
      }
    }
    sc = '$sc); \n';
    sc = '$sc \n';
  }

  sc = '$sc  // added after code gen - begin \n';
  sc = '$sc \n';
  sc = '$sc  // added after code gen - end \n';
  sc = '$sc \n';

  sc = '$sc} \n';
  sc = '$sc \n';

  sc = '${sc}class ${concept.codes} extends ${concept.codes}Gen { \n';
  sc = '$sc \n';
  sc = '$sc  ${concept.codes}(Concept concept) : super(concept); \n';
  sc = '$sc \n';

  sc = '$sc  // added after code gen - begin \n';
  sc = '$sc \n';
  sc = '$sc  // added after code gen - end \n';
  sc = '$sc \n';

  sc = '$sc} \n';
  sc = '$sc \n';

  return sc;
}
