 
// web/democracy/electoral/democracy_electoral_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:democracy_electoral/democracy_electoral.dart"; 
 
void initData(CoreRepository repository) { 
   DemocracyDomain? democracyDomain = repository.getDomainModels("Democracy") as DemocracyDomain?; 
   ElectoralModel? electoralModel = democracyDomain?.getModelEntries("Electoral") as ElectoralModel?; 
   electoralModel?.init(); 
   electoralModel?.display(); 
} 
 
void showData(CoreRepository repository) { 
   // var mainView = View(document, "main"); 
   // mainView.repo = repository; 
   // new RepoMainSection(mainView); 
   print("not implemented"); 
} 
 
void main() { 
  final repository = CoreRepository(); 
  initData(repository); 
  showData(repository); 
} 
 
