import 'package:ednet_core/ednet_core.dart';

/// State for the model selection bloc
///
/// Contains the currently selected model and a list of all available models
/// for the current domain.
class ModelSelectionState extends ValueObject {
  /// Currently selected model
  final Model? selectedModel;

  /// List of available models from the current domain
  final Models availableModels;

  /// Currently selected domain (for context)
  final Domain? domain;

  /// Creates a new model selection state
  ModelSelectionState({
    this.selectedModel,
    required this.availableModels,
    this.domain,
  });

  /// Initial state with no selected model
  factory ModelSelectionState.initial() => ModelSelectionState(
    selectedModel: null,
    availableModels: Models(),
    domain: null,
  );

  /// Create a model selection state for a specific domain
  factory ModelSelectionState.forDomain(Domain domain) => ModelSelectionState(
    selectedModel: domain.models.isNotEmpty ? domain.models.first : null,
    availableModels: domain.models,
    domain: domain,
  );

  /// Creates a copy of this state with the given fields replaced
  @override
  ModelSelectionState copyWith({
    Model? selectedModel,
    Models? availableModels,
    Domain? domain,
  }) {
    return ModelSelectionState(
      selectedModel: selectedModel ?? this.selectedModel,
      availableModels: availableModels ?? this.availableModels,
      domain: domain ?? this.domain,
    );
  }

  /// Properties used for equality comparison and hash code generation
  @override
  List<Object?> get props => [selectedModel, availableModels, domain];

  /// Convert the state to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'selectedModel': selectedModel?.toJsonMap(),
      'availableModels':
          availableModels.map((model) => model.toJsonMap()).toList(),
      'domain': domain?.toJsonMap(),
    };
  }
}
