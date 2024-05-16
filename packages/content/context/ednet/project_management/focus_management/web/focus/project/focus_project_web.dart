 
// web/focus/project/focus_project_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void initData(CoreRepository repository) { 
   FocusDomain? focusDomain = repository.getDomainModels("Focus") as FocusDomain?; 
   ProjectModel? projectModel = focusDomain?.getModelEntries("Project") as ProjectModel?; 
   projectModel?.init(); 
   projectModel?.display(); 
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
 
