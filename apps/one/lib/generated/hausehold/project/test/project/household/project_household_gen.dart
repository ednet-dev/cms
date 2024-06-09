 
// test/project/household/project_household_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_household/project_household.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_household"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   HouseholdModel? householdModel = projectDomain?.getModelEntries("Household") as HouseholdModel?; 
   householdModel?.simulate();
   //householdModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
