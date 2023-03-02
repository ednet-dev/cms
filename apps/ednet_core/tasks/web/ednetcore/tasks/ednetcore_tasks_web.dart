 
// web/ednetcore/tasks/ednetcore_tasks_web.dart 
 
import "dart:html"; 
 
import "package:ednet_default_app/ednet_default_app.dart"; 
import "package:ednetcore_tasks/ednetcore_tasks.dart"; 
 
void initData(CoreRepository repository) { 
   var ednetcoreDomain = repository.getDomainModels("Ednetcore"); 
   var tasksModel = ednetcoreDomain.getModelEntries("Tasks"); 
   tasksModel.init(); 
   //tasksModel.display(); 
} 
 
void showData(CoreRepository repository) { 
   var mainView = View(document, "main"); 
   mainView.repo = repository; 
   new RepoMainSection(mainView); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  initData(repository); 
  showData(repository); 
} 
 
