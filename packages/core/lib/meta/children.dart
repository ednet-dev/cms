part of ednet_core;

class Children extends Entities<Property> {
  int get externalCount {
    int externalCount = 0;
    for (var child in this) {
      if ((child as Neighbor).external) externalCount++;
    }
    return externalCount;
  }
}

class Child extends Neighbor {
  bool navigate = true;

  Child(Concept sourceConcept, Concept destinationConcept, String childCode)
      : super(sourceConcept, destinationConcept, childCode) {
    sourceConcept.children.add(this);
    destinationConcept.sourceChildren.add(this);
    minc = '0';
    maxc = 'N';
  }
}
