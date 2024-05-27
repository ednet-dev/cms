 
// test/user/library/user_library_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:user_library/user_library.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("user_library"); 
} 
 
void initData(CoreRepository repository) { 
   var userDomain = repository.getDomainModels("User"); 
   LibraryModel? libraryModel = userDomain?.getModelEntries("Library") as LibraryModel?; 
   libraryModel?.init(); 
   //libraryModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
