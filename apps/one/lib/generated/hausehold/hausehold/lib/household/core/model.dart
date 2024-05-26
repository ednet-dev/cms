 
part of household_core; 
 
// lib/household/core/model.dart 
 
class CoreModel extends CoreEntries { 
 
  CoreModel(Model model) : super(model); 
 
  void fromJsonToHouseholdEntry() { 
    fromJsonToEntry(householdCoreHouseholdEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(householdCoreModel); 
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
 
