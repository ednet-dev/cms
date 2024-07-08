part of project_kanban; 
 
// lib/gen/project/kanban/locations.dart 
 
abstract class LocationGen extends Entity<Location> { 
 
  LocationGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Location newEntity() => Location(concept); 
  Locations newEntities() => Locations(concept); 
  
} 
 
abstract class LocationsGen extends Entities<Location> { 
 
  LocationsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Locations newEntities() => Locations(concept); 
  Location newEntity() => Location(concept); 
  
} 
 
