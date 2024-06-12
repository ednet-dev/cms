part of project_planning; 
 
// lib/gen/project/i_domain_models.dart 
 
class ProjectModels extends DomainModels { 
 
  ProjectModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Planning",loadYaml(projectPlanningModelJson)); 
    PlanningModel planningModel = PlanningModel(model); 
    add(planningModel); 
 
  } 
 
} 
 
