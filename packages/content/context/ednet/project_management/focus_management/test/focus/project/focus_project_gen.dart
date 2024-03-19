 
// test/focus/project/focus_project_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("focus_project"); 
} 
 
void initData(CoreRepository repository) { 
   var focusDomain = repository.getDomainModels("Focus"); 
   ProjectModel? projectModel = focusDomain?.getModelEntries("Project") as ProjectModel?; 
   projectModel?.init(); 
   //projectModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
