part of project_user; 
 
// lib/gen/project/user/profiles.dart 
 
abstract class ProfileGen extends Entity<Profile> { 
 
  ProfileGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get bio => getAttribute("bio"); 
  void set bio(String a) { setAttribute("bio", a); } 
  
  String get location => getAttribute("location"); 
  void set location(String a) { setAttribute("location", a); } 
  
  String get website => getAttribute("website"); 
  void set website(String a) { setAttribute("website", a); } 
  
  String get birthday => getAttribute("birthday"); 
  void set birthday(String a) { setAttribute("birthday", a); } 
  
  Profile newEntity() => Profile(concept); 
  Profiles newEntities() => Profiles(concept); 
  
} 
 
abstract class ProfilesGen extends Entities<Profile> { 
 
  ProfilesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Profiles newEntities() => Profiles(concept); 
  Profile newEntity() => Profile(concept); 
  
} 
 
