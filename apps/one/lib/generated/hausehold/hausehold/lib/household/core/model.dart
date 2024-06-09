part of household_core;

// lib/household/core/model.dart

class CoreModel extends CoreEntries {
  CoreModel(Model model) : super(model);

  void fromJsonToHouseholdEntry() {
    fromJsonToEntry(householdCoreHouseholdEntry);
  }

  void fromJsonToModel() {
    fromJson(householdCoreModel);
  }

  void simulate() {
    initHouseholds();
  }

  void initHouseholds() {
    var household1 = Household(households.concept);
    household1.name = 'country';
    households.add(household1);

    var household2 = Household(households.concept);
    household2.name = 'baby';
    households.add(household2);

    var household3 = Household(households.concept);
    household3.name = 'flower';
    households.add(household3);
  }

// added after code gen - begin

// added after code gen - end
}
