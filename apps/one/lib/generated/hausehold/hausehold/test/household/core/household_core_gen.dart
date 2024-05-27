 
// test/household/core/household_core_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_core/household_core.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_core"); 
} 
 
void initData(CoreRepository repository) { 
   var householdDomain = repository.getDomainModels("Household"); 
   CoreModel? coreModel = householdDomain?.getModelEntries("Core") as CoreModel?; 
   coreModel?.init(); 
   //coreModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
