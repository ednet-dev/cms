 
// test/project/kanban/project_kanban_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_kanban/project_kanban.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_kanban"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   KanbanModel? kanbanModel = projectDomain?.getModelEntries("Kanban") as KanbanModel?; 
   kanbanModel?.init(); 
   //kanbanModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
