part of project_kanban; 
 
// lib/gen/project/kanban/seriess.dart 
 
abstract class SeriesGen extends Entity<Series> { 
 
  SeriesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Series newEntity() => Series(concept); 
  Seriess newEntities() => Seriess(concept); 
  
} 
 
abstract class SeriessGen extends Entities<Series> { 
 
  SeriessGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Seriess newEntities() => Seriess(concept); 
  Series newEntity() => Series(concept); 
  
} 
 
