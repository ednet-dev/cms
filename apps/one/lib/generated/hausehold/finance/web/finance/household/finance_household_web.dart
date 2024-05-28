 
// web/finance/household/finance_household_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:finance_household/finance_household.dart"; 
 
void initData(CoreRepository repository) { 
   FinanceDomain? financeDomain = repository.getDomainModels("Finance") as FinanceDomain?; 
   HouseholdModel? householdModel = financeDomain?.getModelEntries("Household") as HouseholdModel?; 
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
 
