 
// test/ednet/one/ednet_one_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:ednet_one/ednet_one.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("ednet_one"); 
} 
 
void initData(CoreRepository repository) { 
   var ednetDomain = repository.getDomainModels("Ednet"); 
   OneModel? oneModel = ednetDomain?.getModelEntries("One") as OneModel?; 
   oneModel?.init(); 
   //oneModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
