 
// web/communication/chat/communication_chat_web.dart 
 

import "package:ednet_core/ednet_core.dart"; 
 
// import "package:ednet_core_default_app/ednet_core_default_app.dart"; 
import "package:communication_chat/communication_chat.dart"; 
 
void initData(CoreRepository repository) { 
   CommunicationDomain? communicationDomain = repository.getDomainModels("Communication") as CommunicationDomain?; 
   ChatModel? chatModel = communicationDomain?.getModelEntries("Chat") as ChatModel?; 
   chatModel?.init(); 
   chatModel?.display(); 
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
 
