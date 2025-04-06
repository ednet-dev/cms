part of project_brainstorming; 
 
// lib/gen/project/brainstorming/topics.dart 
 
abstract class TopicGen extends Entity<Topic> { 
 
  TopicGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Topic newEntity() => Topic(concept); 
  Topics newEntities() => Topics(concept); 
  
} 
 
abstract class TopicsGen extends Entities<Topic> { 
 
  TopicsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Topics newEntities() => Topics(concept); 
  Topic newEntity() => Topic(concept); 
  
} 
 
