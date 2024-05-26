 
// web/household_management/finances/household_management_finances_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:household_management_finances/household_management_finances.dart"; 
 
void initData(CoreRepository repository) { 
   Household_managementDomain? household_managementDomain = repository.getDomainModels("Household_management") as Household_managementDomain?; 
   FinancesModel? financesModel = household_managementDomain?.getModelEntries("Finances") as FinancesModel?; 
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
 
