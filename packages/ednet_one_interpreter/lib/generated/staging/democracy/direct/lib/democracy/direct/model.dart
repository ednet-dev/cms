 
part of democracy_direct; 
 
// lib/democracy/direct/model.dart 
 
class DirectModel extends DirectEntries { 
 
  DirectModel(Model model) : super(model); 
 
  void fromJsonToCitizenEntry() { 
    fromJsonToEntry(democracyDirectCitizenEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(democracyDirectModel); 
  } 
 
  void init() { 
    initCitizens(); 
  } 
 
  void initCitizens() { 
    var citizen1 = Citizen(citizens.concept); 
    citizen1.citizenId = 'auto'; 
    citizen1.firstName = 'test'; 
    citizen1.lastName = 'future'; 
    citizens.add(citizen1); 
 
    var citizen2 = Citizen(citizens.concept); 
    citizen2.citizenId = 'blue'; 
    citizen2.firstName = 'distance'; 
    citizen2.lastName = 'agreement'; 
    citizens.add(citizen2); 
 
    var citizen3 = Citizen(citizens.concept); 
    citizen3.citizenId = 'time'; 
    citizen3.firstName = 'end'; 
    citizen3.lastName = 'web'; 
    citizens.add(citizen3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
