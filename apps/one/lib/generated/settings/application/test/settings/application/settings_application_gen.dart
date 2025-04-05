 
// test/settings/application/settings_application_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:settings_application/settings_application.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("settings_application"); 
} 
 
void initData(CoreRepository repository) { 
   var settingsDomain = repository.getDomainModels("Settings"); 
   ApplicationModel? applicationModel = settingsDomain?.getModelEntries("Application") as ApplicationModel?; 
   applicationModel?.init(); 
   //applicationModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
