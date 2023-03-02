 
// test/ednetcore/tasks/ednetcore_tasks_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:ednetcore_tasks/ednetcore_tasks.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("ednetcore_tasks"); 
} 
 
void initData(CoreRepository repository) { 
   var ednetcoreDomain = repository.getDomainModels("Ednetcore"); 
   TasksModel? tasksModel = ednetcoreDomain?.getModelEntries("Tasks") as TasksModel?; 
   tasksModel?.init(); 
   //tasksModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
