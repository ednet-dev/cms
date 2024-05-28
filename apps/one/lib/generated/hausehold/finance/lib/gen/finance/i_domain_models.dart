part of finance_household; 
 
// lib/gen/finance/i_domain_models.dart 
 
class FinanceModels extends DomainModels { 
 
  FinanceModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Household",loadYaml(financeHouseholdModelJson)); 
    HouseholdModel householdModel = HouseholdModel(model); 
    add(householdModel); 
 
  } 
 
} 
 
