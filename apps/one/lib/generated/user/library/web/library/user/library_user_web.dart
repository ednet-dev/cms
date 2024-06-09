 
// web/library/user/library_user_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:library_user/library_user.dart"; 
 
void initData(CoreRepository repository) { 
   LibraryDomain? libraryDomain = repository.getDomainModels("Library") as LibraryDomain?; 
   UserModel? userModel = libraryDomain?.getModelEntries("User") as UserModel?; 
   userModel?.simulate();
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
 
