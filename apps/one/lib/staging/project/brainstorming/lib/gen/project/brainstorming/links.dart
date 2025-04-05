part of project_brainstorming; 
 
// lib/gen/project/brainstorming/links.dart 
 
abstract class LinkGen extends Entity<Link> { 
 
  LinkGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get url => getAttribute("url"); 
  void set url(String a) { setAttribute("url", a); } 
  
  Link newEntity() => Link(concept); 
  Links newEntities() => Links(concept); 
  
} 
 
abstract class LinksGen extends Entities<Link> { 
 
  LinksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Links newEntities() => Links(concept); 
  Link newEntity() => Link(concept); 
  
} 
 
