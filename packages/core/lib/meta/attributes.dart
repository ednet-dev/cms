part of ednet_core;

class Attributes extends Entities<Property> {
  @override
  List<Attribute> toList({bool growable = true}) {
    var attributeList = <Attribute>[];
    for (var property in this.whereType<Attribute>()) {
      attributeList.add(property);
    }
    return attributeList;
  }
}

