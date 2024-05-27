part of household_member; 
 
// lib/repository.dart 
 
class HouseholdMemberRepo extends CoreRepository { 
 
  static const REPOSITORY = "HouseholdMemberRepo"; 
 
  HouseholdMemberRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Household"); 
    domains.add(domain); 
    add(HouseholdDomain(domain)); 
 
  } 
 
} 
 
