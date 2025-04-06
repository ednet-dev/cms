import 'package:ednet_core/ednet_core.dart' as ednet;

/// State for the concept selection bloc
///
/// Contains the currently selected concept, available concepts, and the
/// entities/entries associated with the selected concept.
class ConceptSelectionState extends ednet.ValueObject {
  /// Currently selected concept
  final ednet.Concept? selectedConcept;

  /// List of available concepts
  final ednet.Concepts availableConcepts;

  /// Entities associated with the selected concept
  final ednet.Entities? selectedEntities;

  /// Currently selected model (for context)
  final ednet.Model? model;

  /// Graph representation of the domain model
  final dynamic domainModelGraph;

  /// Creates a new concept selection state
  ConceptSelectionState({
    this.selectedConcept,
    required this.availableConcepts,
    this.selectedEntities,
    this.model,
    this.domainModelGraph,
  });

  /// Initial state with no selected concept
  factory ConceptSelectionState.initial() => ConceptSelectionState(
    selectedConcept: null,
    availableConcepts: ednet.Concepts(),
    selectedEntities: null,
    model: null,
    domainModelGraph: null,
  );

  /// Create a concept selection state for a specific model
  factory ConceptSelectionState.forModel(ednet.Model model, {dynamic graph}) {
    final concepts = model.getOrderedEntryConcepts();
    return ConceptSelectionState(
      selectedConcept: concepts.isNotEmpty ? concepts.first : null,
      availableConcepts: concepts,
      selectedEntities: null,
      model: model,
      domainModelGraph: graph,
    );
  }

  /// Creates a copy of this state with the given fields replaced
  @override
  ConceptSelectionState copyWith({
    ednet.Concept? selectedConcept,
    ednet.Concepts? availableConcepts,
    ednet.Entities? selectedEntities,
    ednet.Model? model,
    dynamic domainModelGraph,
  }) {
    return ConceptSelectionState(
      selectedConcept: selectedConcept ?? this.selectedConcept,
      availableConcepts: availableConcepts ?? this.availableConcepts,
      selectedEntities: selectedEntities ?? this.selectedEntities,
      model: model ?? this.model,
      domainModelGraph: domainModelGraph ?? this.domainModelGraph,
    );
  }

  /// Properties used for equality comparison and hash code generation
  @override
  List<Object> get props => [
    selectedConcept ??
        ednet.Concept(
          model ?? ednet.Model(ednet.Domain('default'), 'default'),
          'default',
        ),
    availableConcepts,
    selectedEntities ?? ednet.Models(),
    model ?? ednet.Model(ednet.Domain('default'), 'default'),
    domainModelGraph ?? Object(),
  ];

  /// Convert the state to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'selectedConcept': selectedConcept?.code,
      'availableConcepts':
          availableConcepts.map((concept) => concept.code).toList(),
      'selectedEntities': selectedEntities != null ? true : false,
      'model': model?.code,
      'hasDomainModelGraph': domainModelGraph != null,
    };
  }
}
