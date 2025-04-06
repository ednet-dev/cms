import 'package:ednet_core/ednet_core.dart' as ednet;

/// State for the model selection bloc
///
/// Contains the currently selected model and a list of all available models
/// for the current domain.
class ModelSelectionState extends ednet.ValueObject {
  /// Currently selected model
  final ednet.Model? selectedModel;

  /// List of available models from the current domain
  final ednet.Models availableModels;

  /// Currently selected domain (for context)
  final ednet.Domain? domain;

  /// Creates a new model selection state
  ModelSelectionState({
    this.selectedModel,
    required this.availableModels,
    this.domain,
  });

  /// Initial state with no selected model
  factory ModelSelectionState.initial() => ModelSelectionState(
    selectedModel: null,
    availableModels: ednet.Models(),
    domain: null,
  );

  /// Create a model selection state for a specific domain
  factory ModelSelectionState.forDomain(ednet.Domain domain) =>
      ModelSelectionState(
        selectedModel: domain.models.isNotEmpty ? domain.models.first : null,
        availableModels: domain.models,
        domain: domain,
      );

  /// Creates a copy of this state with the given fields replaced
  ModelSelectionState copyWith({
    ednet.Model? selectedModel,
    ednet.Models? availableModels,
    ednet.Domain? domain,
  }) {
    return ModelSelectionState(
      selectedModel: selectedModel ?? this.selectedModel,
      availableModels: availableModels ?? this.availableModels,
      domain: domain ?? this.domain,
    );
  }

  /// Properties used for equality comparison and hash code generation
  @override
  List<Object> get props => [
    selectedModel ?? ednet.Model(domain ?? ednet.Domain('default'), 'default'),
    availableModels,
    domain ?? ednet.Domain('default'),
  ];

  /// Convert the state to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'selectedModel': selectedModel?.code,
      'availableModels': availableModels.map((model) => model.code).toList(),
      'domain': domain?.code,
    };
  }
}
