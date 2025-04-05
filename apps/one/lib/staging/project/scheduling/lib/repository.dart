part of project_scheduling; 
 
// lib/repository.dart 
 
class ProjectSchedulingRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectSchedulingRepo"; 
 
  ProjectSchedulingRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
