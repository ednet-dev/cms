 
// web/household/core/household_core_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:household_core/household_core.dart"; 
 
void initData(CoreRepository repository) { 
   HouseholdDomain? householdDomain = repository.getDomainModels("Household") as HouseholdDomain?; 
   CoreModel? coreModel = householdDomain?.getModelEntries("Core") as CoreModel?; 
   coreModel?.init(); 
   coreModel?.display(); 
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
 
