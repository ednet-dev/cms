 
// web/household/finance/household_finance_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:household_finance/household_finance.dart"; 
 
void initData(CoreRepository repository) { 
   HouseholdDomain? householdDomain = repository.getDomainModels("Household") as HouseholdDomain?; 
   FinanceModel? financeModel = householdDomain?.getModelEntries("Finance") as FinanceModel?; 
   financeModel?.init(); 
   financeModel?.display(); 
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
 
