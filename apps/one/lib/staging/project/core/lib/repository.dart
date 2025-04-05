part of project_core; 
 
// lib/repository.dart 
 
class ProjectCoreRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectCoreRepo"; 
 
  ProjectCoreRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
