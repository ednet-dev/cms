part of member_household; 
 
// lib/gen/member/i_domain_models.dart 
 
class MemberModels extends DomainModels { 
 
  MemberModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Household",loadYaml(memberHouseholdModelJson)); 
    HouseholdModel householdModel = HouseholdModel(model); 
    add(householdModel); 
 
  } 
 
} 
 
