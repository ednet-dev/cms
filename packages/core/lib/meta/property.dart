part of ednet_core;

abstract class Property extends Entity<Property> {
  String minc = '0';
  String maxc = '1';
  bool _id = false;
  bool essential = false;
  bool update = true;
  bool sensitive = false;
  String? label;

  Concept sourceConcept;

  Property(this.sourceConcept, String propertyCode) {
    code = propertyCode;
  }

  @override
  set code(String? code) {
    super.code = code;
    label ??= camelCaseLowerSeparator(code!, ' ');
  }

  bool get maxMany => maxc != '0' && maxc != '1' ? true : false;

  bool get identifier => _id;

  set identifier(bool id) {
    _id = id;
    if (id) {
      minc = '1';
      maxc = '1';
      essential = true;
      update = false;
    }
  }

  bool get required => minc == '1' ? true : false;

  set required(bool req) {
    req ? minc = '1' : minc = '0';
  }

// get external;
}
