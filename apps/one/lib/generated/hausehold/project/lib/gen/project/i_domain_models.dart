part of project_household; 
 
// lib/gen/project/i_domain_models.dart 
 
class ProjectModels extends DomainModels { 
 
  ProjectModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Household",loadYaml(projectHouseholdModelJson)); 
    HouseholdModel householdModel = HouseholdModel(model); 
    add(householdModel); 
 
  } 
 
} 
 
