part of ednet_core_types;

// lib/ednet_core/types/model.dart

class TypesModel extends TypesEntries {
  TypesModel(Model model) : super(model);

  void fromJsonToTypeEntry() {
    fromJsonToEntry(ednetCoreTypesTypeEntry);
  }

  void fromJsonToModel() {
    fromJson(ednetCoreTypesModel);
  }

  void init() {
    initTypes();
  }

  void initTypes() {
    final type1 = CoreType(types.concept);
    type1.title = 'selfdo';
    type1.email = 'brian@walker.com';
    type1.started = DateTime.now();
    type1.price = 60.33402414399765;
    type1.qty = 976.7749678702379;
    type1.completed = true;
    type1.whatever = 'energy';
    type1.web = Uri.parse('http://www.mendeley.com/');
    type1.other = 'darts';
    type1.note = 'call';
    types.add(type1);

    final type2 = CoreType(types.concept);
    type2.title = 'tape';
    type2.email = 'ahmed@stewart.com';
    type2.started = DateTime.now();
    type2.price = 45.84212437433066;
    type2.qty = 766;
    type2.completed = true;
    type2.whatever = 'kids';
    type2.web = Uri.parse(
        'http://www.houseplans.com/plan/640-square-feet-1-bedroom-1-bathroom-0-garage-modern-38327');
    type2.other = 'flower';
    type2.note = 'message';
    types.add(type2);

    final type3 = CoreType(types.concept);
    type3.title = 'left';
    type3.email = 'bill@mitchell.com';
    type3.started = DateTime.now();
    type3.price = 53.010108242554466;
    type3.qty = 298;
    type3.completed = false;
    type3.whatever = 'entertainment';
    type3.web = Uri.parse('http://www.jasondavies.com/maps/rotate/');
    type3.other = 'thing';
    type3.note = 'lake';
    types.add(type3);
  }

// added after code gen - begin

// added after code gen - end
}
