part of settings_application; 
 
// lib/gen/settings/i_domain_models.dart 
 
class SettingsModels extends DomainModels { 
 
  SettingsModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Application",loadYaml(settingsApplicationModelJson)); 
    ApplicationModel applicationModel = ApplicationModel(model); 
    add(applicationModel); 
 
  } 
 
} 
 
