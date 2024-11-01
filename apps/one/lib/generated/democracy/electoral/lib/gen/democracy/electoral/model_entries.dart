part of '../../../democracy_electoral.dart';
// Generated code for model entries in lib/gen/democracy/electoral/model_entries.dart

class ElectoralEntries extends ModelEntries {

  ElectoralEntries(super.model);

  /// Creates a map of new entries for each concept in the model.
  @override
  Map<String, Entities> newEntries() {
    final entries = <String, Entities>{};    
    
        final citizensConcept = model.concepts.singleWhereCode('Citizen');
    entries['Citizen'] = Citizens(citizensConcept!);
    

    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  @override
  Entities? newEntities(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

        if (concept.code == 'Citizen') {
      return Citizens(concept);
    }
    

    return null;
  }

  /// Returns a new entity for the given concept code.
  @override
  Entity? newEntity(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

        if (concept.code == 'Citizen') {
      return Citizen(concept);
    }
    

    return null;
  }

    Citizens get citizens => getEntry('Citizen') as Citizens;
  
}
