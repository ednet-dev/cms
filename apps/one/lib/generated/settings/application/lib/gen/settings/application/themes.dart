part of settings_application; 
 
// lib/gen/settings/application/themes.dart 
 
abstract class ThemeGen extends Entity<Theme> { 
 
  ThemeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Theme newEntity() => Theme(concept); 
  Themes newEntities() => Themes(concept); 
  
} 
 
abstract class ThemesGen extends Entities<Theme> { 
 
  ThemesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Themes newEntities() => Themes(concept); 
  Theme newEntity() => Theme(concept); 
  
} 
 
