part of project_user; 
 
// lib/repository.dart 
 
class ProjectUserRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectUserRepo"; 
 
  ProjectUserRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
