 
// test/project/core/project_core_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_core/project_core.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_core"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   CoreModel? coreModel = projectDomain?.getModelEntries("Core") as CoreModel?; 
   coreModel?.init(); 
   //coreModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
