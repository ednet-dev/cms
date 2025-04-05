part of project_kanban; 
 
// lib/gen/project/kanban/publishers.dart 
 
abstract class PublisherGen extends Entity<Publisher> { 
 
  PublisherGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get logo => getAttribute("logo"); 
  void set logo(String a) { setAttribute("logo", a); } 
  
  Publisher newEntity() => Publisher(concept); 
  Publishers newEntities() => Publishers(concept); 
  
} 
 
abstract class PublishersGen extends Entities<Publisher> { 
 
  PublishersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Publishers newEntities() => Publishers(concept); 
  Publisher newEntity() => Publisher(concept); 
  
} 
 
