 
// test/project/user/project_user_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_user/project_user.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_user"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   UserModel? userModel = projectDomain?.getModelEntries("User") as UserModel?; 
   userModel?.init(); 
   //userModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
