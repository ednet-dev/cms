 
// web/member/household/member_household_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:member_household/member_household.dart"; 
 
void initData(CoreRepository repository) { 
   MemberDomain? memberDomain = repository.getDomainModels("Member") as MemberDomain?; 
   HouseholdModel? householdModel = memberDomain?.getModelEntries("Household") as HouseholdModel?; 
   householdModel?.simulate();
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
 
