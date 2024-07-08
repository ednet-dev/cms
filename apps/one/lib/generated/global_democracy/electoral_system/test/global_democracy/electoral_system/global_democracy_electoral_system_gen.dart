 
// test/global_democracy/electoral_system/global_democracy_electoral_system_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:global_democracy_electoral_system/global_democracy_electoral_system.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("global_democracy_electoral_system"); 
} 
 
void initData(CoreRepository repository) { 
   var global_democracyDomain = repository.getDomainModels("Global_democracy"); 
   Electoral_systemModel? electoral_systemModel = global_democracyDomain?.getModelEntries("Electoral_system") as Electoral_systemModel?; 
   electoral_systemModel?.init(); 
   //electoral_systemModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
