part of household_finances; 
 
// lib/repository.dart 
 
class HouseholdFinancesRepo extends CoreRepository { 
 
  static const REPOSITORY = "HouseholdFinancesRepo"; 
 
  HouseholdFinancesRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Household"); 
    domains.add(domain); 
    add(HouseholdDomain(domain)); 
 
  } 
 
} 
 
