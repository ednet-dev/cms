part of project_planning; 
 
// lib/repository.dart 
 
class ProjectPlanningRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectPlanningRepo"; 
 
  ProjectPlanningRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
