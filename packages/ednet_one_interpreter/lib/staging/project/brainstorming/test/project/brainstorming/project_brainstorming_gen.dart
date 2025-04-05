 
// test/project/brainstorming/project_brainstorming_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_brainstorming/project_brainstorming.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_brainstorming"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   BrainstormingModel? brainstormingModel = projectDomain?.getModelEntries("Brainstorming") as BrainstormingModel?; 
   brainstormingModel?.init(); 
   //brainstormingModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
