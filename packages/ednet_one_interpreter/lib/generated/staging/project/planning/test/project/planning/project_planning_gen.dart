 
// test/project/planning/project_planning_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_planning/project_planning.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_planning"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   PlanningModel? planningModel = projectDomain?.getModelEntries("Planning") as PlanningModel?; 
   planningModel?.init(); 
   //planningModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
