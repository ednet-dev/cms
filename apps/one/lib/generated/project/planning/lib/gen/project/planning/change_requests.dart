part of project_planning; 
 
// lib/gen/project/planning/change_requests.dart 
 
abstract class ChangeRequestGen extends Entity<ChangeRequest> { 
 
  ChangeRequestGen(Concept concept) { 
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
  
  ChangeRequest newEntity() => ChangeRequest(concept); 
  ChangeRequests newEntities() => ChangeRequests(concept); 
  
} 
 
abstract class ChangeRequestsGen extends Entities<ChangeRequest> { 
 
  ChangeRequestsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ChangeRequests newEntities() => ChangeRequests(concept); 
  ChangeRequest newEntity() => ChangeRequest(concept); 
  
} 
 
