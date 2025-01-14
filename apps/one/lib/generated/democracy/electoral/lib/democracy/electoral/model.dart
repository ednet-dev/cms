part of '../../democracy_electoral.dart';
// lib/democracy/electoral/model.dart

class ElectoralModel extends ElectoralEntries {
  ElectoralModel(super.model);

  void fromJsonToCitizenEntry() {
    fromJsonToEntry(democracyElectoralCitizenEntry);
  }
  
  void fromJsonToModel() {
    fromJson(democracyElectoralModel);
  }

  void init() {
    initCitizens();
  }
  void initCitizens() {
      final citizen1 = Citizen(citizens.concept) 

    ..citizenId = 'grading'
    ..firstName = 'tall'
    ..lastName = 'debt';    citizens.add(citizen1); 
 
  final citizen2 = Citizen(citizens.concept) 

    ..citizenId = 'series'
    ..firstName = 'instruction'
    ..lastName = 'body';    citizens.add(citizen2); 
 

  }
  
  // added after code gen - begin

  // added after code gen - end

}
