part of project_scheduling; 
 
// lib/gen/project/i_domain_models.dart 
 
class ProjectModels extends DomainModels { 
 
  ProjectModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Scheduling",loadYaml(projectSchedulingModelJson)); 
    SchedulingModel schedulingModel = SchedulingModel(model); 
    add(schedulingModel); 
 
  } 
 
} 
 
