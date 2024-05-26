part of household_management_project; 
 
// lib/gen/household_management/i_domain_models.dart 
 
class Household_managementModels extends DomainModels { 
 
  Household_managementModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Project",loadYaml(household_managementProjectModelJson)); 
    ProjectModel projectModel = ProjectModel(model); 
    add(projectModel); 
 
  } 
 
} 
 
