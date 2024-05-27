 
part of household_finances; 
 
// lib/household/finances/model.dart 
 
class FinancesModel extends FinancesEntries { 
 
  FinancesModel(Model model) : super(model); 
 
  void fromJsonToFinanceEntry() { 
    fromJsonToEntry(householdFinancesFinanceEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(householdFinancesModel); 
  } 
 
  void init() { 
    initFinances(); 
  } 
 
  void initFinances() { 
    var finance1 = Finance(finances.concept); 
    finance1.name = 'city'; 
    finances.add(finance1); 
 
    var finance2 = Finance(finances.concept); 
    finance2.name = 'east'; 
    finances.add(finance2); 
 
    var finance3 = Finance(finances.concept); 
    finance3.name = 'performance'; 
    finances.add(finance3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
