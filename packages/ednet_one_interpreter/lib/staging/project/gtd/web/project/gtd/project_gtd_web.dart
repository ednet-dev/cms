 
// web/project/gtd/project_gtd_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void initData(CoreRepository repository) { 
   ProjectDomain? projectDomain = repository.getDomainModels("Project") as ProjectDomain?; 
   GtdModel? gtdModel = projectDomain?.getModelEntries("Gtd") as GtdModel?; 
   gtdModel?.init(); 
   gtdModel?.display(); 
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
 
