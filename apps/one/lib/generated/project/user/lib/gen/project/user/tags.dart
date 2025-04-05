part of project_user; 
 
// lib/gen/project/user/tags.dart 
 
abstract class TagGen extends Entity<Tag> { 
 
  TagGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Tag newEntity() => Tag(concept); 
  Tags newEntities() => Tags(concept); 
  
} 
 
abstract class TagsGen extends Entities<Tag> { 
 
  TagsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Tags newEntities() => Tags(concept); 
  Tag newEntity() => Tag(concept); 
  
} 
 
