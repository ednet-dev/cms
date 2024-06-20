 
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
    citizen1.citizenId = 'cash'; 
    citizen1.firstName = 'lake'; 
    citizen1.lastName = 'bank'; 
    citizens.add(citizen1); 
 
    var citizen2 = Citizen(citizens.concept); 
    citizen2.citizenId = 'selfie'; 
    citizen2.firstName = 'time'; 
    citizen2.lastName = 'guest'; 
    citizens.add(citizen2); 
 
    var citizen3 = Citizen(citizens.concept); 
    citizen3.citizenId = 'plate'; 
    citizen3.firstName = 'algorithm'; 
    citizen3.lastName = 'wave'; 
    citizens.add(citizen3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
