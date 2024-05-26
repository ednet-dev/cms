 
// web/household_management/project/household_management_project_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:household_management_project/household_management_project.dart"; 
 
void initData(CoreRepository repository) { 
   Household_managementDomain? household_managementDomain = repository.getDomainModels("Household_management") as Household_managementDomain?; 
   ProjectModel? projectModel = household_managementDomain?.getModelEntries("Project") as ProjectModel?; 
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
 
