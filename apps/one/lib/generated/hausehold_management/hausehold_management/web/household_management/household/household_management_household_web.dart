 
// web/household_management/household/household_management_household_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:household_management_household/household_management_household.dart"; 
 
void initData(CoreRepository repository) { 
   Household_managementDomain? household_managementDomain = repository.getDomainModels("Household_management") as Household_managementDomain?; 
   HouseholdModel? householdModel = household_managementDomain?.getModelEntries("Household") as HouseholdModel?; 
   householdModel?.init(); 
   householdModel?.display(); 
} 
 
void showData(CoreRepository repository) { 
   // var mainView = View(document, "main"); 
   // mainView.repo = repository; 
   // new RepoMainSection(mainView); 
   print("not implemented"); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  initData(repository); 
  showData(repository); 
} 
 
