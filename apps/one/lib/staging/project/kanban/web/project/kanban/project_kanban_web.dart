 
// web/project/kanban/project_kanban_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:project_kanban/project_kanban.dart"; 
 
void initData(CoreRepository repository) { 
   ProjectDomain? projectDomain = repository.getDomainModels("Project") as ProjectDomain?; 
   KanbanModel? kanbanModel = projectDomain?.getModelEntries("Kanban") as KanbanModel?; 
   kanbanModel?.init(); 
   kanbanModel?.display(); 
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
 
