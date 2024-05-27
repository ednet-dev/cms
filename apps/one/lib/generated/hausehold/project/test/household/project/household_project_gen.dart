 
// test/household/project/household_project_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_project/household_project.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_project"); 
} 
 
void initData(CoreRepository repository) { 
   var householdDomain = repository.getDomainModels("Household"); 
   ProjectModel? projectModel = householdDomain?.getModelEntries("Project") as ProjectModel?; 
   projectModel?.init(); 
   //projectModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
