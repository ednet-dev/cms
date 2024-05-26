 
part of household_management_finances; 
 
// lib/household_management/finances/model.dart 
 
class FinancesModel extends FinancesEntries { 
 
  FinancesModel(Model model) : super(model); 
 
  void fromJsonToFinanceEntry() { 
    fromJsonToEntry(household_managementFinancesFinanceEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(household_managementFinancesModel); 
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
 
