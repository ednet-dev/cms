part of ednetcore_tasks; 
 
// lib/gen/ednetcore/i_domain_models.dart 
 
class EdnetcoreModels extends DomainModels { 
 
  EdnetcoreModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel(ednetcoreTasksModelJson, domain, "Tasks"); 
    TasksModel tasksModel = TasksModel(model); 
    add(tasksModel); 
 
  } 
 
} 
 
