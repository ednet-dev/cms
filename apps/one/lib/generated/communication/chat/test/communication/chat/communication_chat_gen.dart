 
// test/communication/chat/communication_chat_gen.dart 
import "package:ednet_core/ednet_core.dart"; 
import "package:communication_chat/communication_chat.dart"; 
 
void genCode(CoreRepository repository) { 
  repository.gen("communication_chat"); 
} 
 
void initData(CoreRepository repository) { 
   var communicationDomain = repository.getDomainModels("Communication"); 
   ChatModel? chatModel = communicationDomain?.getModelEntries("Chat") as ChatModel?; 
   chatModel?.init(); 
   //chatModel.display(); 
} 
 
void main() { 
  var repository = CoreRepository(); 
  genCode(repository); 
  //initData(repository); 
} 
 
