 
part of household_finance; 
 
// lib/household/finance/model.dart 
 
class FinanceModel extends FinanceEntries { 
 
  FinanceModel(Model model) : super(model); 
 
  void fromJsonToFinanceEntry() { 
    fromJsonToEntry(householdFinanceFinanceEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(householdFinanceModel); 
  } 
 
  void init() { 
    initFinances(); 
  } 
 
  void initFinances() { 
    var finance1 = Finance(finances.concept); 
    finance1.name = 'pub'; 
    finances.add(finance1); 
 
    var finance2 = Finance(finances.concept); 
    finance2.name = 'effort'; 
    finances.add(finance2); 
 
    var finance3 = Finance(finances.concept); 
    finance3.name = 'umbrella'; 
    finances.add(finance3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
