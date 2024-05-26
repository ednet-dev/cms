 
// web/ednet/one/ednet_one_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:ednet_one/ednet_one.dart"; 
 
void initData(CoreRepository repository) { 
   EdnetDomain? ednetDomain = repository.getDomainModels("Ednet") as EdnetDomain?; 
   OneModel? oneModel = ednetDomain?.getModelEntries("One") as OneModel?; 
   oneModel?.init(); 
   oneModel?.display(); 
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
 
