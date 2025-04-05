import 'package:ednet_core/ednet_core.dart';

/// State for the domain selection bloc
///
/// Contains the currently selected domain and a list of all available domains.
/// This state object extends the ednet_core ValueObject for immutability and equality.
class DomainSelectionState extends ValueObject {
  /// Currently selected domain
  final Domain? selectedDomain;

  /// All available domains
  final Domains allDomains;

  /// Creates a new domain selection state
  DomainSelectionState({this.selectedDomain, required this.allDomains});

  /// Initial state with no selected domain
  factory DomainSelectionState.initial() =>
      DomainSelectionState(selectedDomain: null, allDomains: Domains());

  /// Creates a copy of this state with the given fields replaced
  DomainSelectionState copyWith({Domain? selectedDomain, Domains? allDomains}) {
    return DomainSelectionState(
      selectedDomain: selectedDomain ?? this.selectedDomain,
      allDomains: allDomains ?? this.allDomains,
    );
  }

  /// Properties used for equality comparison and hash code generation
  List<Object?> get props => [selectedDomain, allDomains];

  /// Convert the state to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'selectedDomain': selectedDomain?.toJsonMap(),
      'allDomains': allDomains.map((domain) => domain.toJsonMap()).toList(),
    };
  }
}
