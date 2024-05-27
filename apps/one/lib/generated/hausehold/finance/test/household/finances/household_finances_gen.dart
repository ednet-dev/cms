 
// test/household/finances/household_finances_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_finances/household_finances.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_finances"); 
} 
 
void initData(CoreRepository repository) { 
   var householdDomain = repository.getDomainModels("Household"); 
   FinancesModel? financesModel = householdDomain?.getModelEntries("Finances") as FinancesModel?; 
   financesModel?.init(); 
   //financesModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
