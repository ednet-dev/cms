part of ednet_core;

abstract class Neighbor extends Property {
  bool internal = true;
  bool inheritance = false;
  bool reflexive = false;
  bool twin = false;
  Neighbor? opposite;

  // Added for extended DSL support
  String _category = 'rel'; // Default category is 'rel'

  // the source concept is inherited from Property
  Concept destinationConcept;

  Neighbor(Concept sourceConcept, this.destinationConcept, String neighborCode)
    : super(sourceConcept, neighborCode) {}

  // is external a reserved word?
  bool get external => !internal;

  // Getter and setter for category
  String get category => _category;

  set category(String category) {
    _category = category;
  }

  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['internal'] = internal;
    graph['inheritance'] = inheritance;
    graph['reflexive'] = reflexive;
    graph['twin'] = twin;
    graph['category'] = _category;
    graph['destinationConcept'] = destinationConcept.code;

    if (opposite != null) {
      graph['opposite'] = opposite!.code;
    }

    return graph;
  }
}
