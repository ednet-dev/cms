part of project_brainstorming; 
 
// lib/gen/project/brainstorming/ideas.dart 
 
abstract class IdeaGen extends Entity<Idea> { 
 
  IdeaGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Idea newEntity() => Idea(concept); 
  Ideas newEntities() => Ideas(concept); 
  
} 
 
abstract class IdeasGen extends Entities<Idea> { 
 
  IdeasGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Ideas newEntities() => Ideas(concept); 
  Idea newEntity() => Idea(concept); 
  
} 
 
