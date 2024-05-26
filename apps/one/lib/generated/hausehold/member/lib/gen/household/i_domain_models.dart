part of household_member; 
 
// lib/gen/household/i_domain_models.dart 
 
class HouseholdModels extends DomainModels { 
 
  HouseholdModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Member",loadYaml(householdMemberModelJson)); 
    MemberModel memberModel = MemberModel(model); 
    add(memberModel); 
 
  } 
 
} 
 
