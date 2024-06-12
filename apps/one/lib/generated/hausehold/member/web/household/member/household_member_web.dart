 
// web/household/member/household_member_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:household_member/household_member.dart"; 
 
void initData(CoreRepository repository) { 
   HouseholdDomain? householdDomain = repository.getDomainModels("Household") as HouseholdDomain?; 
   MemberModel? memberModel = householdDomain?.getModelEntries("Member") as MemberModel?; 
   memberModel?.init(); 
   memberModel?.display(); 
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
 
