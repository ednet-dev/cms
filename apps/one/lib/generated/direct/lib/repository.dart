part of democracy_direct; 
 
// lib/repository.dart 
 
class DemocracyDirectRepo extends CoreRepository { 
 
  static const REPOSITORY = "DemocracyDirectRepo"; 
 
  DemocracyDirectRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Democracy"); 
    domains.add(domain); 
    add(DemocracyDomain(domain)); 
 
  } 
 
} 
 
