part of project_core; 
 
// lib/gen/project/i_domain_models.dart 
 
class ProjectModels extends DomainModels { 
 
  ProjectModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Core",loadYaml(projectCoreModelJson)); 
    CoreModel coreModel = CoreModel(model); 
    add(coreModel); 
 
  } 
 
} 
 
