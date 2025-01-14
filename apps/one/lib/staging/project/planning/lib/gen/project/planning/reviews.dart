part of project_planning; 
 
// lib/gen/project/planning/reviews.dart 
 
abstract class ReviewGen extends Entity<Review> { 
 
  ReviewGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
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
 
