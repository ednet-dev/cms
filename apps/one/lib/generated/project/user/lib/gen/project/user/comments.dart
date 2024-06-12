part of project_user; 
 
// lib/gen/project/user/comments.dart 
 
abstract class CommentGen extends Entity<Comment> { 
 
  CommentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get content => getAttribute("content"); 
  void set content(String a) { setAttribute("content", a); } 
  
  Comment newEntity() => Comment(concept); 
  Comments newEntities() => Comments(concept); 
  
} 
 
abstract class CommentsGen extends Entities<Comment> { 
 
  CommentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Comments newEntities() => Comments(concept); 
  Comment newEntity() => Comment(concept); 
  
} 
 
