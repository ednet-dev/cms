 
// web/ednetcore/tasks/ednetcore_tasks_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:ednetcore_tasks/ednetcore_tasks.dart"; 
 
void initData(CoreRepository repository) { 
   EdnetcoreDomain? ednetcoreDomain = repository.getDomainModels("Ednetcore") as EdnetcoreDomain?; 
   TasksModel? tasksModel = ednetcoreDomain?.getModelEntries("Tasks") as TasksModel?; 
   tasksModel?.init(); 
   tasksModel?.display(); 
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
 
