 
// web/project/planning/project_planning_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:project_planning/project_planning.dart"; 
 
void initData(CoreRepository repository) { 
   ProjectDomain? projectDomain = repository.getDomainModels("Project") as ProjectDomain?; 
   PlanningModel? planningModel = projectDomain?.getModelEntries("Planning") as PlanningModel?; 
   planningModel?.init(); 
   planningModel?.display(); 
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
 
