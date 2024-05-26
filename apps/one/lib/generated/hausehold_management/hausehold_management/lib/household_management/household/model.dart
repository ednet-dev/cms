 
part of household_management_household; 
 
// lib/household_management/household/model.dart 
 
class HouseholdModel extends HouseholdEntries { 
 
  HouseholdModel(Model model) : super(model); 
 
  void fromJsonToHouseholdEntry() { 
    fromJsonToEntry(household_managementHouseholdHouseholdEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(household_managementHouseholdModel); 
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
 
