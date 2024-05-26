 
// test/household_management/project/household_management_project_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_management_project/household_management_project.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("household_management_project"); 
} 
 
void initData(CoreRepository repository) { 
   var household_managementDomain = repository.getDomainModels("Household_management"); 
   ProjectModel? projectModel = household_managementDomain?.getModelEntries("Project") as ProjectModel?; 
   projectModel?.init(); 
   //projectModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
