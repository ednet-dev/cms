 
// test/member/household/member_household_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:member_household/member_household.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("member_household"); 
} 
 
void initData(CoreRepository repository) { 
   var memberDomain = repository.getDomainModels("Member"); 
   HouseholdModel? householdModel = memberDomain?.getModelEntries("Household") as HouseholdModel?; 
   householdModel?.init(); 
   //householdModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
