part of project_brainstorming; 
 
// lib/gen/project/brainstorming/nodes.dart 
 
abstract class NodeGen extends Entity<Node> { 
 
  NodeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Node newEntity() => Node(concept); 
  Nodes newEntities() => Nodes(concept); 
  
} 
 
abstract class NodesGen extends Entities<Node> { 
 
  NodesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Nodes newEntities() => Nodes(concept); 
  Node newEntity() => Node(concept); 
  
} 
 
