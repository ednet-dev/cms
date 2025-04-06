import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:ednet_one/presentation/widgets/layout/graph/domain/domain_model_graph.dart';

class DomainState {
  final ednet.Domain? selectedDomain;
  final ednet.Model? selectedModel;
  final ednet.Entities? selectedEntries;
  final ednet.Entities? selectedEntities;
  final ednet.Concept? selectedConcept;
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
    ednet.Domain? selectedDomain,
    ednet.Model? selectedModel,
    ednet.Entities? selectedEntries,
    ednet.Entities? selectedEntities,
    ednet.Concept? selectedConcept,
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
