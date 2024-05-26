part of household_project; 
 
// lib/gen/household/i_domain_models.dart 
 
class HouseholdModels extends DomainModels { 
 
  HouseholdModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Project",loadYaml(householdProjectModelJson)); 
    ProjectModel projectModel = ProjectModel(model); 
    add(projectModel); 
 
  } 
 
} 
 
