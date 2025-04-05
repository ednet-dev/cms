part of project_brainstorming; 
 
// lib/gen/project/i_domain_models.dart 
 
class ProjectModels extends DomainModels { 
 
  ProjectModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Brainstorming",loadYaml(projectBrainstormingModelJson)); 
    BrainstormingModel brainstormingModel = BrainstormingModel(model); 
    add(brainstormingModel); 
 
  } 
 
} 
 
