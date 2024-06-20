part of communication_chat; 
 
// lib/repository.dart 
 
class CommunicationChatRepo extends CoreRepository { 
 
  static const REPOSITORY = "CommunicationChatRepo"; 
 
  CommunicationChatRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Communication"); 
    domains.add(domain); 
    add(CommunicationDomain(domain)); 
 
  } 
 
} 
 
