 
// test/library/user/library_user_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:library_user/library_user.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("library_user"); 
} 
 
void initData(CoreRepository repository) { 
   var libraryDomain = repository.getDomainModels("Library"); 
   UserModel? userModel = libraryDomain?.getModelEntries("User") as UserModel?; 
   userModel?.init(); 
   //userModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
