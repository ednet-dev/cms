part of settings_application; 
 
// lib/gen/settings/application/statuss.dart 
 
abstract class StatusGen extends Entity<Status> { 
 
  StatusGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Status newEntity() => Status(concept); 
  Statuss newEntities() => Statuss(concept); 
  
} 
 
abstract class StatussGen extends Entities<Status> { 
 
  StatussGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Statuss newEntities() => Statuss(concept); 
  Status newEntity() => Status(concept); 
  
} 
 
