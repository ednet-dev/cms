part of household_core; 
 
// lib/repository.dart 
 
class HouseholdCoreRepo extends CoreRepository { 
 
  static const REPOSITORY = "HouseholdCoreRepo"; 
 
  HouseholdCoreRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Household"); 
    domains.add(domain); 
    add(HouseholdDomain(domain)); 
 
  } 
 
} 
 
