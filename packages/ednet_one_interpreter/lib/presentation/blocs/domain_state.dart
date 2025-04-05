import 'package:ednet_core/ednet_core.dart';

class DomainState {
  final Domain? selectedDomain;
  final Model? selectedModel;
  final Entities? selectedEntries;
  final Entities? selectedEntities;
  final Concept? selectedConcept;

  DomainState({
    required this.selectedDomain,
    required this.selectedModel,
    required this.selectedEntries,
    required this.selectedEntities,
    required this.selectedConcept,
  });

  factory DomainState.initial() => DomainState(
    selectedDomain: null,
    selectedModel: null,
    selectedEntries: null,
    selectedEntities: null,
    selectedConcept: null,
  );

  DomainState copyWith({
    Domain? selectedDomain,
    Model? selectedModel,
    Entities? selectedEntries,
    Entities? selectedEntities,
    Concept? selectedConcept,
  }) {
    return DomainState(
      selectedDomain: selectedDomain ?? this.selectedDomain,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      selectedEntities: selectedEntities ?? this.selectedEntities,
      selectedConcept: selectedConcept ?? this.selectedConcept,
    );
  }
}
