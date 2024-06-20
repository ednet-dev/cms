 
// web/democracy/direct/democracy_direct_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:democracy_direct/democracy_direct.dart"; 
 
void initData(CoreRepository repository) { 
   DemocracyDomain? democracyDomain = repository.getDomainModels("Democracy") as DemocracyDomain?; 
   DirectModel? directModel = democracyDomain?.getModelEntries("Direct") as DirectModel?; 
   directModel?.init(); 
   directModel?.display(); 
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
 
