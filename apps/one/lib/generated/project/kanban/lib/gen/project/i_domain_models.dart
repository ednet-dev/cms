part of project_kanban; 
 
// lib/gen/project/i_domain_models.dart 
 
class ProjectModels extends DomainModels { 
 
  ProjectModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Kanban",loadYaml(projectKanbanModelJson)); 
    KanbanModel kanbanModel = KanbanModel(model); 
    add(kanbanModel); 
 
  } 
 
} 
 
