part of member_household; 
 
// lib/repository.dart 
 
class MemberHouseholdRepo extends CoreRepository { 
 
  static const REPOSITORY = "MemberHouseholdRepo"; 
 
  MemberHouseholdRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Member"); 
    domains.add(domain); 
    add(MemberDomain(domain)); 
 
  } 
 
} 
 
