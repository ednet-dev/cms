part of finance_household; 
 
// lib/repository.dart 
 
class FinanceHouseholdRepo extends CoreRepository { 
 
  static const REPOSITORY = "FinanceHouseholdRepo"; 
 
  FinanceHouseholdRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Finance"); 
    domains.add(domain); 
    add(FinanceDomain(domain)); 
 
  } 
 
} 
 
