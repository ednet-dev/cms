part of ednet_one; 
 
// lib/gen/ednet/i_domain_models.dart 
 
class EdnetModels extends DomainModels { 
 
  EdnetModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "One",loadYaml(ednetOneModelJson)); 
    OneModel oneModel = OneModel(model); 
    add(oneModel); 
 
  } 
 
} 
 
