part of project_brainstorming; 
 
// lib/repository.dart 
 
class ProjectBrainstormingRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectBrainstormingRepo"; 
 
  ProjectBrainstormingRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
