 
// web/project/brainstorming/project_brainstorming_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:project_brainstorming/project_brainstorming.dart"; 
 
void initData(CoreRepository repository) { 
   ProjectDomain? projectDomain = repository.getDomainModels("Project") as ProjectDomain?; 
   BrainstormingModel? brainstormingModel = projectDomain?.getModelEntries("Brainstorming") as BrainstormingModel?; 
   brainstormingModel?.init(); 
   brainstormingModel?.display(); 
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
 
