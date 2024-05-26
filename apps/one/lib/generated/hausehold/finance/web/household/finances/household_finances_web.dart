 
// web/household/finances/household_finances_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:household_finances/household_finances.dart"; 
 
void initData(CoreRepository repository) { 
   HouseholdDomain? householdDomain = repository.getDomainModels("Household") as HouseholdDomain?; 
   FinancesModel? financesModel = householdDomain?.getModelEntries("Finances") as FinancesModel?; 
   financesModel?.init(); 
   financesModel?.display(); 
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
 
