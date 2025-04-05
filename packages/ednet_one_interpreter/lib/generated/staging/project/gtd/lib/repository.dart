part of project_gtd; 
 
// lib/repository.dart 
 
class ProjectGtdRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectGtdRepo"; 
 
  ProjectGtdRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
