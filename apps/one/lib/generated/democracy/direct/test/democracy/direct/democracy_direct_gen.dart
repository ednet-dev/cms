 
// test/democracy/direct/democracy_direct_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:democracy_direct/democracy_direct.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("democracy_direct"); 
} 
 
void initData(CoreRepository repository) { 
   var democracyDomain = repository.getDomainModels("Democracy"); 
   DirectModel? directModel = democracyDomain?.getModelEntries("Direct") as DirectModel?; 
   directModel?.init(); 
   //directModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
