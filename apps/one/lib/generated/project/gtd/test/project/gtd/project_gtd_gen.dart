 
// test/project/gtd/project_gtd_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("project_gtd"); 
} 
 
void initData(CoreRepository repository) { 
   var projectDomain = repository.getDomainModels("Project"); 
   GtdModel? gtdModel = projectDomain?.getModelEntries("Gtd") as GtdModel?; 
   gtdModel?.init(); 
   //gtdModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
