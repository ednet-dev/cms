 
part of ednet_one; 
 
// lib/ednet/one/model.dart 
 
class OneModel extends OneEntries { 
 
  OneModel(Model model) : super(model); 
 
  void fromJsonToHouseholdEntry() { 
    fromJsonToEntry(ednetOneHouseholdEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(ednetOneModel); 
  } 
 
  void init() { 
    initHouseholds(); 
  } 
 
  void initHouseholds() { 
    var household1 = Household(households.concept); 
    households.add(household1); 
 
    var household2 = Household(households.concept); 
    households.add(household2); 
 
    var household3 = Household(households.concept); 
    households.add(household3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
