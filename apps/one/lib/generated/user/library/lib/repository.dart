part of user_library; 
 
// lib/repository.dart 
 
class Repository extends CoreRepository { 
 
  static const REPOSITORY = "Repository"; 
 
  Repository([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("User"); 
    domains.add(domain); 
    add(UserDomain(domain)); 
 
  } 
 
} 
 
