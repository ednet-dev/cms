part of focus_project; 
 
// lib/gen/focus/project/users.dart 
 
abstract class UserGen extends Entity<User> { 
 
  UserGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  User newEntity() => User(concept); 
  Users newEntities() => Users(concept); 
  
} 
 
abstract class UsersGen extends Entities<User> { 
 
  UsersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Users newEntities() => Users(concept); 
  User newEntity() => User(concept); 
  
} 
 
