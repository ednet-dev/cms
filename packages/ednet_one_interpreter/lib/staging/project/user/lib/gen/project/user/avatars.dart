part of project_user; 
 
// lib/gen/project/user/avatars.dart 
 
abstract class AvatarGen extends Entity<Avatar> { 
 
  AvatarGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get image => getAttribute("image"); 
  void set image(String a) { setAttribute("image", a); } 
  
  Avatar newEntity() => Avatar(concept); 
  Avatars newEntities() => Avatars(concept); 
  
} 
 
abstract class AvatarsGen extends Entities<Avatar> { 
 
  AvatarsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Avatars newEntities() => Avatars(concept); 
  Avatar newEntity() => Avatar(concept); 
  
} 
 
