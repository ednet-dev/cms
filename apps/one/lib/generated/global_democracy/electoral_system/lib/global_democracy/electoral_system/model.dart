part of global_democracy_electoral_system;

// lib/global_democracy/electoral_system/model.dart

class Electoral_systemModel extends Electoral_systemEntries {

  Electoral_systemModel(Model model) : super(model);

    void fromJsonToCitizenEntry() {
    fromJsonToEntry(global_democracyElectoral_systemCitizenEntry);
  }
  

  void fromJsonToModel() {
    fromJson(global_democracyElectoral_systemModel);
  }

  void init() {
    initCitizens();
  }

    void initCitizens() {
    var citizen1 = Citizen(citizens.concept); 
    citizen1.citizenId = 'autobus'; 
    citizen1.name = 'algorithm'; 
    citizens.add(citizen1); 
 
    var citizen2 = Citizen(citizens.concept); 
    citizen2.citizenId = 'policeman'; 
    citizen2.name = 'productivity'; 
    citizens.add(citizen2); 
 

  }
  

  // added after code gen - begin

  // added after code gen - end

}
