part of project_kanban; 
 
// lib/repository.dart 
 
class ProjectKanbanRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectKanbanRepo"; 
 
  ProjectKanbanRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
