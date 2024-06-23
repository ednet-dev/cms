part of ednet_core;

abstract class Neighbor extends Property {
  bool internal = true;
  bool inheritance = false;
  bool reflexive = false;
  bool twin = false;
  Neighbor? opposite;

  // the source concept is inherited from Property
  Concept destinationConcept;

  Neighbor(Concept sourceConcept, this.destinationConcept, String neighborCode)
      : super(sourceConcept, neighborCode) {}

  // is external a reserved word?
  bool get external => !internal;

  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['internal'] = internal;
    graph['inheritance'] = inheritance;
    graph['reflexive'] = reflexive;
    graph['twin'] = twin;
    graph['destinationConcept'] = destinationConcept.code;

    if (opposite != null) {
      graph['opposite'] = opposite!.code;
    }

    return graph;
  }
}
