 
// test/project/scheduling/project_scheduling_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_scheduling/project_scheduling.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_scheduling"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   SchedulingModel? schedulingModel = projectDomain?.getModelEntries("Scheduling") as SchedulingModel?; 
   schedulingModel?.init(); 
   //schedulingModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
