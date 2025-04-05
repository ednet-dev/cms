import 'package:ednet_core/ednet_core.dart';
import 'package:equatable/equatable.dart';

class DomainState extends Equatable {
  final Domain? selectedDomain;
  final Model? selectedModel;
  final Entities? selectedEntries;
  final Entities? selectedEntities;
  final Concept? selectedConcept;
  final bool isLoading;
  final String? errorMessage;
  final bool useStaging;
  final Map<String, List<String>> availableSpecifications;
  final bool isDomainModelChanged;

  // Session and navigation state
  final List<String> navigationPath;
  final String layoutType;

  // Draft management
  final Map<String, List<String>> availableDrafts;
  final bool hasDraftForCurrentModel;

  // Version management
  final List<String> availableVersions;
  final String? currentVersionTimestamp;

  const DomainState({
    this.selectedDomain,
    this.selectedModel,
    this.selectedEntries,
    this.selectedEntities,
    this.selectedConcept,
    this.isLoading = false,
    this.errorMessage,
    this.useStaging = true,
    this.availableSpecifications = const {},
    this.isDomainModelChanged = false,
    this.navigationPath = const ['Home'],
    this.layoutType = 'default',
    this.availableDrafts = const {},
    this.hasDraftForCurrentModel = false,
    this.availableVersions = const [],
    this.currentVersionTimestamp,
  });

  factory DomainState.initial() {
    return const DomainState(
      isLoading: false,
      useStaging: true,
      navigationPath: ['Home'],
      layoutType: 'default',
    );
  }

  DomainState copyWith({
    Domain? selectedDomain,
    Model? selectedModel,
    Entities? selectedEntries,
    Entities? selectedEntities,
    Concept? selectedConcept,
    bool? isLoading,
    String? errorMessage,
    bool? useStaging,
    Map<String, List<String>>? availableSpecifications,
    bool? isDomainModelChanged,
    List<String>? navigationPath,
    String? layoutType,
    Map<String, List<String>>? availableDrafts,
    bool? hasDraftForCurrentModel,
    List<String>? availableVersions,
    String? currentVersionTimestamp,
  }) {
    return DomainState(
      selectedDomain: selectedDomain ?? this.selectedDomain,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      selectedEntities: selectedEntities ?? this.selectedEntities,
      selectedConcept: selectedConcept ?? this.selectedConcept,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      useStaging: useStaging ?? this.useStaging,
      availableSpecifications:
          availableSpecifications ?? this.availableSpecifications,
      isDomainModelChanged: isDomainModelChanged ?? this.isDomainModelChanged,
      navigationPath: navigationPath ?? this.navigationPath,
      layoutType: layoutType ?? this.layoutType,
      availableDrafts: availableDrafts ?? this.availableDrafts,
      hasDraftForCurrentModel:
          hasDraftForCurrentModel ?? this.hasDraftForCurrentModel,
      availableVersions: availableVersions ?? this.availableVersions,
      currentVersionTimestamp:
          currentVersionTimestamp ?? this.currentVersionTimestamp,
    );
  }

  @override
  List<Object?> get props => [
    selectedDomain,
    selectedModel,
    selectedEntries,
    selectedEntities,
    selectedConcept,
    isLoading,
    errorMessage,
    useStaging,
    availableSpecifications,
    isDomainModelChanged,
    navigationPath,
    layoutType,
    availableDrafts,
    hasDraftForCurrentModel,
    availableVersions,
    currentVersionTimestamp,
  ];
}
