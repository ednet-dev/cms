 
// web/global_democracy/electoral_system/global_democracy_electoral_system_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:global_democracy_electoral_system/global_democracy_electoral_system.dart"; 
 
void initData(CoreRepository repository) { 
   Global_democracyDomain? global_democracyDomain = repository.getDomainModels("Global_democracy") as Global_democracyDomain?; 
   Electoral_systemModel? electoral_systemModel = global_democracyDomain?.getModelEntries("Electoral_system") as Electoral_systemModel?; 
   electoral_systemModel?.init(); 
   electoral_systemModel?.display(); 
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
 
