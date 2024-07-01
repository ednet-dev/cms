part of settings_application; 
 
// lib/gen/settings/application/users.dart 
 
abstract class UserGen extends Entity<User> { 
 
  UserGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get email => getAttribute("email"); 
  void set email(String a) { setAttribute("email", a); } 
  
  String get password => getAttribute("password"); 
  void set password(String a) { setAttribute("password", a); } 
  
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
 
