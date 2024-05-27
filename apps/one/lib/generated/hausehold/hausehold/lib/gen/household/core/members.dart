part of household_core; 
 
// lib/gen/household/core/members.dart 
 
abstract class MemberGen extends Entity<Member> { 
 
  MemberGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Member newEntity() => Member(concept); 
  Members newEntities() => Members(concept); 
  
} 
 
abstract class MembersGen extends Entities<Member> { 
 
  MembersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Members newEntities() => Members(concept); 
  Member newEntity() => Member(concept); 
  
} 
 