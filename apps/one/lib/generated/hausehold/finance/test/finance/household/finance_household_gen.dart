 
// test/finance/household/finance_household_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:finance_household/finance_household.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("finance_household"); 
} 
 
void initData(CoreRepository repository) { 
   var financeDomain = repository.getDomainModels("Finance"); 
   HouseholdModel? householdModel = financeDomain?.getModelEntries("Household") as HouseholdModel?; 
   householdModel?.simulate();
   //householdModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
