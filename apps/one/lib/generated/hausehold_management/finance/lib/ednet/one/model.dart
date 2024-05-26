 
part of ednet_one; 
 
// lib/ednet/one/model.dart 
 
class OneModel extends OneEntries { 
 
  OneModel(Model model) : super(model); 
 
  void fromJsonToFinanceEntry() { 
    fromJsonToEntry(ednetOneFinanceEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(ednetOneModel); 
  } 
 
  void init() { 
    initFinances(); 
  } 
 
  void initFinances() { 
    var finance1 = Finance(finances.concept); 
    finances.add(finance1); 
 
    var finance2 = Finance(finances.concept); 
    finances.add(finance2); 
 
    var finance3 = Finance(finances.concept); 
    finances.add(finance3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
