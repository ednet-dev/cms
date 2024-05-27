 
// web/user/library/user_library_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:user_library/user_library.dart"; 
 
void initData(CoreRepository repository) { 
   UserDomain? userDomain = repository.getDomainModels("User") as UserDomain?; 
   LibraryModel? libraryModel = userDomain?.getModelEntries("Library") as LibraryModel?; 
   libraryModel?.init(); 
   libraryModel?.display(); 
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
 
