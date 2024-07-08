 
// web/settings/application/settings_application_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:settings_application/settings_application.dart"; 
 
void initData(CoreRepository repository) { 
   SettingsDomain? settingsDomain = repository.getDomainModels("Settings") as SettingsDomain?; 
   ApplicationModel? applicationModel = settingsDomain?.getModelEntries("Application") as ApplicationModel?; 
   applicationModel?.init(); 
   applicationModel?.display(); 
} 
 
void showData(CoreRepository repository) { 
   // var mainView = View(document, "main"); 
   // mainView.repo = repository; 
   // new RepoMainSection(mainView); 
   print("not implemented"); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  initData(repository); 
  showData(repository); 
} 
 
