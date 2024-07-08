part of project_planning; 
 
// lib/gen/project/planning/risks.dart 
 
abstract class RiskGen extends Entity<Risk> { 
 
  RiskGen(Concept concept) { 
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
  
  Risk newEntity() => Risk(concept); 
  Risks newEntities() => Risks(concept); 
  
} 
 
abstract class RisksGen extends Entities<Risk> { 
 
  RisksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Risks newEntities() => Risks(concept); 
  Risk newEntity() => Risk(concept); 
  
} 
 
