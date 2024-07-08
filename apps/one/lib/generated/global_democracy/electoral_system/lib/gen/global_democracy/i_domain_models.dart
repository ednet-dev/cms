part of global_democracy_electoral_system; 
 
// lib/gen/global_democracy/i_domain_models.dart 
 
class Global_democracyModels extends DomainModels { 
 
  Global_democracyModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Electoral_system",loadYaml(global_democracyElectoral_systemModelJson)); 
    Electoral_systemModel electoral_systemModel = Electoral_systemModel(model); 
    add(electoral_systemModel); 
 
  } 
 
} 
 
