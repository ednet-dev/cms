part of household_finance; 
 
// lib/repository.dart 
 
class HouseholdFinanceRepo extends CoreRepository { 
 
  static const REPOSITORY = "HouseholdFinanceRepo"; 
 
  HouseholdFinanceRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Household"); 
    domains.add(domain); 
    add(HouseholdDomain(domain)); 
 
  } 
 
} 
 
