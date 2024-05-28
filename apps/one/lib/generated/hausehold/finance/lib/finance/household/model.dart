 
part of finance_household; 
 
// lib/finance/household/model.dart 
 
class HouseholdModel extends HouseholdEntries { 
 
  HouseholdModel(Model model) : super(model); 
 
  void fromJsonToFinanceEntry() { 
    fromJsonToEntry(financeHouseholdFinanceEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(financeHouseholdModel); 
  } 
 
  void init() { 
    initFinances(); 
  } 
 
  void initFinances() { 
    var finance1 = Finance(finances.concept); 
    finance1.name = 'college'; 
    finances.add(finance1); 
 
    var finance2 = Finance(finances.concept); 
    finance2.name = 'interest'; 
    finances.add(finance2); 
 
    var finance3 = Finance(finances.concept); 
    finance3.name = 'tall'; 
    finances.add(finance3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
