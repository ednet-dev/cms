part of project_brainstorming; 
 
// lib/gen/project/brainstorming/mind_maps.dart 
 
abstract class MindMapGen extends Entity<MindMap> { 
 
  MindMapGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  MindMap newEntity() => MindMap(concept); 
  MindMaps newEntities() => MindMaps(concept); 
  
} 
 
abstract class MindMapsGen extends Entities<MindMap> { 
 
  MindMapsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  MindMaps newEntities() => MindMaps(concept); 
  MindMap newEntity() => MindMap(concept); 
  
} 
 
