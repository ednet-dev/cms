part of democracy_direct; 
 
// lib/gen/democracy/i_domain_models.dart 
 
class DemocracyModels extends DomainModels { 
 
  DemocracyModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Direct",loadYaml(democracyDirectModelJson)); 
    DirectModel directModel = DirectModel(model); 
    add(directModel); 
 
  } 
 
} 
 
