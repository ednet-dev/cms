 
// web/project/user/project_user_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:project_user/project_user.dart"; 
 
void initData(CoreRepository repository) { 
   ProjectDomain? projectDomain = repository.getDomainModels("Project") as ProjectDomain?; 
   UserModel? userModel = projectDomain?.getModelEntries("User") as UserModel?; 
   userModel?.init(); 
   userModel?.display(); 
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
 
