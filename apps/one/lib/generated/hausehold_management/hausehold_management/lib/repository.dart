part of ednet_one; 
 
// lib/repository.dart 
 
class Repository extends CoreRepository { 
 
  static const REPOSITORY = "Repository"; 
 
  Repository([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Ednet"); 
    domains.add(domain); 
    add(EdnetDomain(domain)); 
 
  } 
 
} 
 
