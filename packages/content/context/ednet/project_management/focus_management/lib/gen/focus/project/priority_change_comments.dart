part of focus_project; 
 
// lib/gen/focus/project/priority_change_comments.dart 
 
abstract class PriorityChangeCommentGen extends Entity<PriorityChangeComment> { 
 
  PriorityChangeCommentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  PriorityChangeComment newEntity() => PriorityChangeComment(concept); 
  PriorityChangeComments newEntities() => PriorityChangeComments(concept); 
  
} 
 
abstract class PriorityChangeCommentsGen extends Entities<PriorityChangeComment> { 
 
  PriorityChangeCommentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  PriorityChangeComments newEntities() => PriorityChangeComments(concept); 
  PriorityChangeComment newEntity() => PriorityChangeComment(concept); 
  
} 
 
