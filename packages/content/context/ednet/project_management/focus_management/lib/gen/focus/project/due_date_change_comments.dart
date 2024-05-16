part of focus_project; 
 
// lib/gen/focus/project/due_date_change_comments.dart 
 
abstract class DueDateChangeCommentGen extends Entity<DueDateChangeComment> { 
 
  DueDateChangeCommentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DueDateChangeComment newEntity() => DueDateChangeComment(concept); 
  DueDateChangeComments newEntities() => DueDateChangeComments(concept); 
  
} 
 
abstract class DueDateChangeCommentsGen extends Entities<DueDateChangeComment> { 
 
  DueDateChangeCommentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DueDateChangeComments newEntities() => DueDateChangeComments(concept); 
  DueDateChangeComment newEntity() => DueDateChangeComment(concept); 
  
} 
 
