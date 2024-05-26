part of household_project; 
 
// lib/repository.dart 
 
class HouseholdProjectRepo extends CoreRepository { 
 
  static const REPOSITORY = "HouseholdProjectRepo"; 
 
  HouseholdProjectRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Household"); 
    domains.add(domain); 
    add(HouseholdDomain(domain)); 
 
  } 
 
} 
 
