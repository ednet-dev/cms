part of ednet_core;

class Parent extends Neighbor {
  bool absorb = true;

  Parent(Concept sourceConcept, Concept destinationConcept, String parentCode)
      : super(sourceConcept, destinationConcept, parentCode) {
    sourceConcept.parents.add(this);
    destinationConcept.sourceParents.add(this);
    minc = '1';
    maxc = '1';
  }
}
