 
// test/household_management/household/household_management_household_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_management_household/household_management_household.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_management_household"); 
} 
 
void initData(CoreRepository repository) { 
   var household_managementDomain = repository.getDomainModels("Household_management"); 
   HouseholdModel? householdModel = household_managementDomain?.getModelEntries("Household") as HouseholdModel?; 
   householdModel?.init(); 
   //householdModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
