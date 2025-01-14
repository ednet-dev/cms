part of ednet_core_types;

// lib/gen/ednet_core/types/model_entries.dart

class TypesEntries extends ModelEntries {
  TypesEntries(Model model) : super(model);

  @override
  Map<String, Entities> newEntries() {
    final entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode('CoreType');
    entries['CoreType'] = CoreTypes(concept);
    return entries;
  }

  @override
  Entities? newEntities(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('${conceptCode} concept does not exist.');
    }
    if (concept.code == 'CoreType') {
      return CoreTypes(concept);
    }
    return null;
  }

  @override
  Entity? newEntity(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('${conceptCode} concept does not exist.');
    }
    if (concept.code == 'CoreType') {
      return CoreType(concept);
    }
    return null;
  }

  CoreTypes get types => getEntry('CoreType') as CoreTypes;
}
