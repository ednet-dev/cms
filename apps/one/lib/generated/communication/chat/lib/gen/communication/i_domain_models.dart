part of communication_chat; 
 
// lib/gen/communication/i_domain_models.dart 
 
class CommunicationModels extends DomainModels { 
 
  CommunicationModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Chat",loadYaml(communicationChatModelJson)); 
    ChatModel chatModel = ChatModel(model); 
    add(chatModel); 
 
  } 
 
} 
 
