part of project_gtd; 
 
// lib/gen/project/gtd/reviews.dart 
 
abstract class ReviewGen extends Entity<Review> { 
 
  ReviewGen(Concept concept) { 
    this.concept = concept; 
    Concept taskConcept = concept.model.concepts.singleWhereCode("Task") as Concept; 
    assert(taskConcept != null); 
    setChild("tasks", Tasks(taskConcept)); 
  } 
 
  String get assessments => getAttribute("assessments"); 
  void set assessments(String a) { setAttribute("assessments", a); } 
  
  Tasks get tasks => getChild("tasks") as Tasks; 
  
  Review newEntity() => Review(concept); 
  Reviews newEntities() => Reviews(concept); 
  
} 
 
abstract class ReviewsGen extends Entities<Review> { 
 
  ReviewsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reviews newEntities() => Reviews(concept); 
  Review newEntity() => Review(concept); 
  
} 
 
