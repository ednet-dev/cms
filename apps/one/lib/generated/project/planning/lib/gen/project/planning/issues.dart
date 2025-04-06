part of project_planning; 
 
// lib/gen/project/planning/issues.dart 
 
abstract class IssueGen extends Entity<Issue> { 
 
  IssueGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  Issue newEntity() => Issue(concept); 
  Issues newEntities() => Issues(concept); 
  
} 
 
abstract class IssuesGen extends Entities<Issue> { 
 
  IssuesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Issues newEntities() => Issues(concept); 
  Issue newEntity() => Issue(concept); 
  
} 
 
