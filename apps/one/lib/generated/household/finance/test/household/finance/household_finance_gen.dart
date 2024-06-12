 
// test/household/finance/household_finance_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_finance/household_finance.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_finance"); 
} 
 
void initData(CoreRepository repository) { 
   var householdDomain = repository.getDomainModels("Household"); 
   FinanceModel? financeModel = householdDomain?.getModelEntries("Finance") as FinanceModel?; 
   financeModel?.init(); 
   //financeModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
