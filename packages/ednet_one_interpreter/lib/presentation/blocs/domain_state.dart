import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/presentation/widgets/layout/graph/domain/domain_model_graph.dart';

class DomainState {
  final Domain? selectedDomain;
  final Model? selectedModel;
  final Entities? selectedEntries;
  final Entities? selectedEntities;
  final Concept? selectedConcept;
  final DomainModelGraph? domainModelGraph;

  DomainState({
    required this.selectedDomain,
    required this.selectedModel,
    required this.selectedEntries,
    required this.selectedEntities,
    required this.selectedConcept,
    required this.domainModelGraph,
  });

  factory DomainState.initial() => DomainState(
        selectedDomain: null,
        selectedModel: null,
        selectedEntries: null,
        selectedEntities: null,
        selectedConcept: null,
        domainModelGraph: null,
      );

  DomainState copyWith({
    Domain? selectedDomain,
    Model? selectedModel,
    Entities? selectedEntries,
    Entities? selectedEntities,
    Concept? selectedConcept,
    DomainModelGraph? domainModelGraph,
  }) {
    return DomainState(
      selectedDomain: selectedDomain ?? this.selectedDomain,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      selectedEntities: selectedEntities ?? this.selectedEntities,
      selectedConcept: selectedConcept ?? this.selectedConcept,
      domainModelGraph: domainModelGraph ?? this.domainModelGraph,
    );
  }
}
