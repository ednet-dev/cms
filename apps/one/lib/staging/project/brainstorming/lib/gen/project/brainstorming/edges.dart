part of project_brainstorming; 
 
// lib/gen/project/brainstorming/edges.dart 
 
abstract class EdgeGen extends Entity<Edge> { 
 
  EdgeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get from => getAttribute("from"); 
  void set from(String a) { setAttribute("from", a); } 
  
  String get to => getAttribute("to"); 
  void set to(String a) { setAttribute("to", a); } 
  
  String get weight => getAttribute("weight"); 
  void set weight(String a) { setAttribute("weight", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  Edge newEntity() => Edge(concept); 
  Edges newEntities() => Edges(concept); 
  
} 
 
abstract class EdgesGen extends Entities<Edge> { 
 
  EdgesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Edges newEntities() => Edges(concept); 
  Edge newEntity() => Edge(concept); 
  
} 
 
