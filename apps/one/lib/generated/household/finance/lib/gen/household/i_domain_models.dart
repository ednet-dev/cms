part of household_finance; 
 
// lib/gen/household/i_domain_models.dart 
 
class HouseholdModels extends DomainModels { 
 
  HouseholdModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Finance",loadYaml(householdFinanceModelJson)); 
    FinanceModel financeModel = FinanceModel(model); 
    add(financeModel); 
 
  } 
 
} 
 
