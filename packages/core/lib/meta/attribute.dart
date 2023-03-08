part of ednet_core;

class Attribute extends Property {
  bool guid = false;
  var init;
  int? increment;
  int? sequence;
  bool _derive = false;
  late int length;

  AttributeType? _type;

  Attribute(Concept sourceConcept, String attributeCode)
      : super(sourceConcept, attributeCode) {
    sourceConcept.attributes.add(this);
    // default type is String
    type = sourceConcept.model.domain.getType('String');
  }

  @override
  set required(bool req) {
    super.required = req;
    if (req && !sourceConcept.hasId) {
      essential = true;
    }
  }

  AttributeType? get type => _type;

  set type(AttributeType? attributeType) {
    _type = attributeType;
    length = attributeType != null ? attributeType.length : 0;
  }

  bool get derive => _derive;

  set derive(bool derive) {
    _derive = derive;
    if (_derive) {
      update = false;
    }
  }
}
