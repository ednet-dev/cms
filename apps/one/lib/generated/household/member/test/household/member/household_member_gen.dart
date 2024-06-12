 
// test/household/member/household_member_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_member/household_member.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_member"); 
} 
 
void initData(CoreRepository repository) { 
   var householdDomain = repository.getDomainModels("Household"); 
   MemberModel? memberModel = householdDomain?.getModelEntries("Member") as MemberModel?; 
   memberModel?.init(); 
   //memberModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
