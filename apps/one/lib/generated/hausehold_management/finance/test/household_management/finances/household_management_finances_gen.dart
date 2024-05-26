 
// test/household_management/finances/household_management_finances_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_management_finances/household_management_finances.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_management_finances"); 
} 
 
void initData(CoreRepository repository) { 
   var household_managementDomain = repository.getDomainModels("Household_management"); 
   FinancesModel? financesModel = household_managementDomain?.getModelEntries("Finances") as FinancesModel?; 
   financesModel?.init(); 
   //financesModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
