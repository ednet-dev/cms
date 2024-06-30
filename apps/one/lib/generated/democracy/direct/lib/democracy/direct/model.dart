 
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
    citizen1.citizenId = 'pattern'; 
    citizen1.firstName = 'right'; 
    citizen1.lastName = 'algorithm'; 
    citizens.add(citizen1); 
 
    var citizen2 = Citizen(citizens.concept); 
    citizen2.citizenId = 'test'; 
    citizen2.firstName = 'vessel'; 
    citizen2.lastName = 'interest'; 
    citizens.add(citizen2); 
 
    var citizen3 = Citizen(citizens.concept); 
    citizen3.citizenId = 'kids'; 
    citizen3.firstName = 'tall'; 
    citizen3.lastName = 'void'; 
    citizens.add(citizen3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
