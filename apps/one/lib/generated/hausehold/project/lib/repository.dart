part of project_household; 
 
// lib/repository.dart 
 
class ProjectHouseholdRepo extends CoreRepository { 
 
  static const REPOSITORY = "ProjectHouseholdRepo"; 
 
  ProjectHouseholdRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Project"); 
    domains.add(domain); 
    add(ProjectDomain(domain)); 
 
  } 
 
} 
 
