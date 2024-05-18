part of focus_project; 
 
// lib/repository.dart 
 
class Repository extends CoreRepository { 
 
  static const REPOSITORY = 'Repository';
 
  Repository([String code=REPOSITORY]) : super(code) { 
    var domain = Domain('Focus');
    domains.add(domain); 
    add(FocusDomain(domain)); 
 
  } 
 
} 
 
