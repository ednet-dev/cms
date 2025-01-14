part of settings_application; 
 
// lib/repository.dart 
 
class SettingsApplicationRepo extends CoreRepository { 
 
  static const REPOSITORY = "SettingsApplicationRepo"; 
 
  SettingsApplicationRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Settings"); 
    domains.add(domain); 
    add(SettingsDomain(domain)); 
 
  } 
 
} 
 
