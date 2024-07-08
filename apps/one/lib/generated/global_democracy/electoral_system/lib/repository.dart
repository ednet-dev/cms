part of global_democracy_electoral_system; 
 
// lib/repository.dart 
 
class GlobalDemocracyElectoralSystemRepo extends CoreRepository { 
 
  static const REPOSITORY = "GlobalDemocracyElectoralSystemRepo"; 
 
  GlobalDemocracyElectoralSystemRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Global_democracy"); 
    domains.add(domain); 
    add(Global_democracyDomain(domain)); 
 
  } 
 
} 
 
