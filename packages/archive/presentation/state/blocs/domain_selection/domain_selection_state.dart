import 'package:ednet_core/ednet_core.dart' as ednet;

/// State for the domain selection bloc
///
/// Contains the currently selected domain and a list of all available domains.
/// This state object extends the ednet_core ValueObject for immutability and equality.
class DomainSelectionState extends ednet.ValueObject {
  /// Currently selected domain
  final ednet.Domain? selectedDomain;

  /// List of available domains
  final ednet.Domains availableDomains;

  /// Models associated with the selected domain
  final ednet.Models? selectedModels;

  /// Creates a new domain selection state
  DomainSelectionState({
    this.selectedDomain,
    required this.availableDomains,
    this.selectedModels,
  });

  /// Initial state with no selected domain
  factory DomainSelectionState.initial() => DomainSelectionState(
    selectedDomain: null,
    availableDomains: ednet.Domains(),
    selectedModels: null,
  );

  /// Create a copy with the given fields replaced
  DomainSelectionState copyWith({
    ednet.Domain? selectedDomain,
    ednet.Domains? availableDomains,
    ednet.Models? selectedModels,
  }) {
    return DomainSelectionState(
      selectedDomain: selectedDomain ?? this.selectedDomain,
      availableDomains: availableDomains ?? this.availableDomains,
      selectedModels: selectedModels ?? this.selectedModels,
    );
  }

  /// Properties used for equality comparison and hash code generation
  @override
  List<Object> get props => [
    selectedDomain ?? ednet.Domain('default'),
    availableDomains,
    selectedModels ?? ednet.Models(),
  ];

  /// Convert the state to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'selectedDomain': selectedDomain?.code,
      'availableDomains':
          availableDomains.map((domain) => domain.code).toList(),
      'selectedModels': selectedModels != null ? true : false,
    };
  }
}
