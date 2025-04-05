import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/shell_app.dart';
import 'package:ednet_one_interpreter/models/session_manager.dart';

import 'domain_event.dart';
import 'domain_state.dart';

class DomainBloc extends Bloc<DomainBlocEvent, DomainState> {
  final IOneApplication app;
  final SessionManager _sessionManager = SessionManager();

  DomainBloc({required this.app}) : super(DomainState.initial()) {
    on<InitializeDomainEvent>(_onInitialize);
    on<SelectDomainEvent>(_onSelectDomain);
    on<SelectModelEvent>(_onSelectModel);
    on<SelectConceptEvent>(_onSelectConcept);
    on<ExportDSLEvent>(_onExportDSL);
    on<GenerateCodeEvent>(_onGenerateCode);
    on<UpdateDomainModelEvent>(_onUpdateDomainModel);
    on<SaveDomainModelChangesEvent>(_onSaveDomainModelChanges);
    on<SwitchEnvironmentEvent>(_onSwitchEnvironment);
    on<ListSpecificationsEvent>(_onListSpecifications);
    on<LoadFromSpecificationEvent>(_onLoadFromSpecification);
    on<CreateConceptEvent>(_onCreateConcept);
    on<UpdateConceptEvent>(_onUpdateConcept);
    on<DeleteConceptEvent>(_onDeleteConcept);

    // Session management events
    on<SaveSessionEvent>(_onSaveSession);
    on<RestoreSessionEvent>(_onRestoreSession);
    on<SaveNavigationStateEvent>(_onSaveNavigationState);
    on<RestoreNavigationStateEvent>(_onRestoreNavigationState);

    // Draft management events
    on<SaveDraftEvent>(_onSaveDraft);
    on<LoadDraftEvent>(_onLoadDraft);
    on<ListDraftsEvent>(_onListDrafts);
    on<CommitDraftEvent>(_onCommitDraft);
    on<DiscardDraftEvent>(_onDiscardDraft);

    // Version management events
    on<ListVersionsEvent>(_onListVersions);
    on<LoadVersionEvent>(_onLoadVersion);

    // Initialize available specifications and restore session
    add(ListSpecificationsEvent());
    add(RestoreSessionEvent());
    add(ListDraftsEvent());
  }

  void _onInitialize(InitializeDomainEvent event, Emitter<DomainState> emit) {
    // Initialize with first domain and model if available
    Domain? selectedDomain;
    Model? selectedModel;
    Entities? selectedEntries;
    Entities? selectedEntities;
    Concept? selectedConcept;

    if (app.groupedDomains.isNotEmpty) {
      selectedDomain = app.groupedDomains.first;
      if (selectedDomain.models.isNotEmpty) {
        selectedModel = selectedDomain.models.first;
        selectedEntries = selectedModel.concepts;
      }
    }

    emit(
      state.copyWith(
        selectedDomain: selectedDomain,
        selectedModel: selectedModel,
        selectedEntries: selectedEntries,
        selectedEntities: selectedEntities,
        selectedConcept: selectedConcept,
      ),
    );
  }

  void _onSelectDomain(SelectDomainEvent event, Emitter<DomainState> emit) {
    Domain domain = event.domain;
    Model? selectedModel;
    Entities? selectedEntries;
    Entities? selectedEntities;
    Concept? selectedConcept;

    if (domain.models.isNotEmpty) {
      selectedModel = domain.models.first;
      selectedEntries =
          selectedModel.concepts.isNotEmpty ? selectedModel.concepts : null;
    }

    emit(
      state.copyWith(
        selectedDomain: domain,
        selectedModel: selectedModel,
        selectedEntries: selectedEntries,
        selectedEntities: selectedEntities,
        selectedConcept: selectedConcept,
      ),
    );

    // Auto-save session when domain selection changes
    add(SaveSessionEvent());

    // Check if there's a draft for this domain model
    if (selectedModel != null) {
      _checkForDraft(
        domain.codeFirstLetterLower,
        selectedModel.codeFirstLetterLower,
      );
    }
  }

  void _onSelectModel(SelectModelEvent event, Emitter<DomainState> emit) {
    final domain = state.selectedDomain;
    if (domain == null) return; // No domain selected

    Model model = event.model;
    Entities? selectedEntries =
        model.concepts.isNotEmpty ? model.getOrderedEntryConcepts() : null;

    emit(
      state.copyWith(
        selectedModel: model,
        selectedEntries: selectedEntries,
        selectedEntities: null,
        selectedConcept: null,
      ),
    );

    // Auto-save session when model selection changes
    add(SaveSessionEvent());

    // Check if there's a draft for this domain model
    _checkForDraft(domain.codeFirstLetterLower, model.codeFirstLetterLower);
  }

  void _onSelectConcept(SelectConceptEvent event, Emitter<DomainState> emit) {
    final concept = event.concept;
    final selectedDomain = state.selectedDomain;
    final selectedModel = state.selectedModel;

    if (selectedDomain == null || selectedModel == null) return;
    var domainModel = app.getDomainModels(
      selectedDomain.codeFirstLetterLower,
      selectedModel.codeFirstLetterLower,
    );
    var modelEntries = domainModel.getModelEntries(concept.model.code);
    var entry = modelEntries?.getEntry(concept.code);

    emit(state.copyWith(selectedConcept: concept, selectedEntities: entry));

    // Auto-save session when concept selection changes
    add(SaveSessionEvent());
  }

  void _onExportDSL(ExportDSLEvent event, Emitter<DomainState> emit) {
    // This will now use the more detailed DSL export implementation from ShellApp
    // No need to update state here as this is just an export operation
  }

  void _onGenerateCode(
    GenerateCodeEvent event,
    Emitter<DomainState> emit,
  ) async {
    final domain = event.domain ?? state.selectedDomain;
    final model = event.model ?? state.selectedModel;

    if (domain == null || model == null) {
      emit(
        state.copyWith(
          errorMessage: 'No domain or model selected for code generation',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final success = await shellApp.generateCode(domain, model);

        if (success) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: null,
              isDomainModelChanged: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to generate code',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support code generation',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error generating code: $e',
        ),
      );
    }
  }

  void _onUpdateDomainModel(
    UpdateDomainModelEvent event,
    Emitter<DomainState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final success = await shellApp.updateDomainModel(
          event.domain,
          event.model,
          event.updates,
        );

        if (success) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: null,
              isDomainModelChanged: true,
            ),
          );

          // Auto-save draft when model is updated
          add(SaveDraftEvent(domain: event.domain, model: event.model));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to update domain model',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                'App implementation does not support domain model updates',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error updating domain model: $e',
        ),
      );
    }
  }

  void _onSaveDomainModelChanges(
    SaveDomainModelChangesEvent event,
    Emitter<DomainState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final success = await shellApp.saveDomainModelChanges(
          event.domain,
          event.model,
        );

        if (success) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: null,
              isDomainModelChanged: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to save domain model changes',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                'App implementation does not support saving domain model changes',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error saving domain model changes: $e',
        ),
      );
    }
  }

  void _onSwitchEnvironment(
    SwitchEnvironmentEvent event,
    Emitter<DomainState> emit,
  ) {
    emit(
      state.copyWith(
        useStaging: event.useStaging,
        // Reset selections when switching environments
        selectedDomain: null,
        selectedModel: null,
        selectedEntries: null,
        selectedEntities: null,
        selectedConcept: null,
        isDomainModelChanged: false,
      ),
    );

    // Refresh the available specifications and drafts
    add(ListSpecificationsEvent());
    add(ListDraftsEvent());
  }

  void _onListSpecifications(
    ListSpecificationsEvent event,
    Emitter<DomainState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final specifications = await shellApp.listAvailableSpecifications();

        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: null,
            availableSpecifications: specifications,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                'App implementation does not support listing specifications',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error listing specifications: $e',
        ),
      );
    }
  }

  void _onLoadFromSpecification(
    LoadFromSpecificationEvent event,
    Emitter<DomainState> emit,
  ) {
    // This would load a domain model from a specification file
    // Implementation would depend on how specifications are loaded
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Here we would need to implement the loading of a specification
    // For now, this is a placeholder

    emit(
      state.copyWith(
        isLoading: false,
        errorMessage: 'Loading from specification not yet implemented',
      ),
    );
  }

  void _onCreateConcept(CreateConceptEvent event, Emitter<DomainState> emit) {
    final domain = state.selectedDomain;
    final model = state.selectedModel;

    if (domain == null || model == null) {
      emit(
        state.copyWith(
          errorMessage: 'No domain or model selected for concept creation',
        ),
      );
      return;
    }

    // Create a new concept and add it to the model using the correct constructor
    final concept = Concept(model, event.code);

    // Set the description
    concept.description = event.description;

    // Add attributes if specified
    if (event.attributes.isNotEmpty) {
      for (var entry in event.attributes.entries) {
        // Handle attributes based on type
        // This is a simplified implementation and would need to be extended
        // based on the actual attribute types supported
        print('Adding attribute: ${entry.key} = ${entry.value}');
      }
    }

    // Update state with new concept
    emit(
      state.copyWith(
        selectedEntries: model.concepts,
        isDomainModelChanged: true,
      ),
    );

    // Auto-save draft when concept is created
    add(SaveDraftEvent(domain: domain, model: model));
  }

  void _onUpdateConcept(UpdateConceptEvent event, Emitter<DomainState> emit) {
    final domain = state.selectedDomain;
    final model = state.selectedModel;

    if (domain == null || model == null) {
      emit(
        state.copyWith(
          errorMessage: 'No domain or model selected for concept update',
        ),
      );
      return;
    }

    // Update concept properties
    // This is a simplified version - actual implementation would be more complex
    if (event.updates.containsKey('description')) {
      event.concept.description = event.updates['description'] as String;
    }

    // Mark model as changed and update state
    emit(state.copyWith(isDomainModelChanged: true));

    // Auto-save draft when concept is updated
    add(SaveDraftEvent(domain: domain, model: model));
  }

  void _onDeleteConcept(DeleteConceptEvent event, Emitter<DomainState> emit) {
    final domain = state.selectedDomain;
    final model = state.selectedModel;

    if (domain == null || model == null) {
      emit(
        state.copyWith(
          errorMessage: 'No domain or model selected for concept deletion',
        ),
      );
      return;
    }

    // Remove concept from model
    model.concepts.remove(event.concept);

    // Update state without the deleted concept
    emit(
      state.copyWith(
        selectedEntries: model.concepts,
        selectedConcept: null,
        selectedEntities: null,
        isDomainModelChanged: true,
      ),
    );

    // Auto-save draft when concept is deleted
    add(SaveDraftEvent(domain: domain, model: model));
  }

  // Session management methods

  void _onSaveSession(SaveSessionEvent event, Emitter<DomainState> emit) async {
    try {
      await _sessionManager.saveSession(state);
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  void _onRestoreSession(
    RestoreSessionEvent event,
    Emitter<DomainState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final sessionData = await _sessionManager.loadSession();
      final domainCode = sessionData['domainCode'] as String?;
      final modelCode = sessionData['modelCode'] as String?;

      if (domainCode != null) {
        // Find domain by code
        final domain = app.groupedDomains.singleWhereCode(domainCode);

        if (domain != null) {
          // First select the domain
          add(SelectDomainEvent(domain));

          if (modelCode != null) {
            // Find model by code
            final model = domain.models.singleWhereCode(modelCode);

            if (model != null) {
              // Then select the model
              add(SelectModelEvent(model));
            }
          }
        }
      }

      emit(
        state.copyWith(
          isLoading: false,
          useStaging: sessionData['useStaging'] as bool? ?? true,
        ),
      );

      // Also restore navigation state
      add(RestoreNavigationStateEvent());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error restoring session: $e',
        ),
      );
    }
  }

  void _onSaveNavigationState(
    SaveNavigationStateEvent event,
    Emitter<DomainState> emit,
  ) async {
    try {
      await _sessionManager.saveNavigationState(event.path, event.layoutType);

      emit(
        state.copyWith(
          navigationPath: event.path,
          layoutType: event.layoutType,
        ),
      );
    } catch (e) {
      print('Error saving navigation state: $e');
    }
  }

  void _onRestoreNavigationState(
    RestoreNavigationStateEvent event,
    Emitter<DomainState> emit,
  ) async {
    try {
      final navigationData = await _sessionManager.loadNavigationState();
      final path = navigationData['path'] as List<String>?;
      final layoutType = navigationData['layoutType'] as String?;

      emit(
        state.copyWith(
          navigationPath: path ?? ['Home'],
          layoutType: layoutType ?? 'default',
        ),
      );
    } catch (e) {
      print('Error restoring navigation state: $e');
    }
  }

  // Draft management methods

  void _onSaveDraft(SaveDraftEvent event, Emitter<DomainState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final success = await shellApp.saveDraft(event.domain, event.model);

        if (success) {
          emit(state.copyWith(isLoading: false, hasDraftForCurrentModel: true));

          // Refresh list of drafts
          add(ListDraftsEvent());
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to save draft',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support drafts',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error saving draft: $e',
        ),
      );
    }
  }

  void _onLoadDraft(LoadDraftEvent event, Emitter<DomainState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final draftYaml = await shellApp.loadDraft(
          event.domainCode,
          event.modelCode,
        );

        if (draftYaml != null) {
          // Parse YAML into domain model
          // This would depend on how your application loads and parses YAML
          // For now, this is a placeholder

          emit(
            state.copyWith(
              isLoading: false,
              hasDraftForCurrentModel: true,
              errorMessage: 'Draft loaded (parsing not yet implemented)',
            ),
          );
        } else {
          emit(
            state.copyWith(isLoading: false, errorMessage: 'No draft found'),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support drafts',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error loading draft: $e',
        ),
      );
    }
  }

  void _onListDrafts(ListDraftsEvent event, Emitter<DomainState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final drafts = await shellApp.listAvailableDrafts();

        emit(state.copyWith(isLoading: false, availableDrafts: drafts));

        // Check if there's a draft for the current model
        if (state.selectedDomain != null && state.selectedModel != null) {
          _checkForDraft(
            state.selectedDomain!.codeFirstLetterLower,
            state.selectedModel!.codeFirstLetterLower,
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support drafts',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error listing drafts: $e',
        ),
      );
    }
  }

  void _onCommitDraft(CommitDraftEvent event, Emitter<DomainState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final success = await shellApp.commitDraft(
          event.domainCode,
          event.modelCode,
        );

        if (success) {
          emit(
            state.copyWith(
              isLoading: false,
              hasDraftForCurrentModel: false,
              isDomainModelChanged: false,
            ),
          );

          // Refresh list of drafts and specifications
          add(ListDraftsEvent());
          add(ListSpecificationsEvent());
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to commit draft',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support drafts',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error committing draft: $e',
        ),
      );
    }
  }

  void _onDiscardDraft(
    DiscardDraftEvent event,
    Emitter<DomainState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final success = await shellApp.discardDraft(
          event.domainCode,
          event.modelCode,
        );

        if (success) {
          emit(
            state.copyWith(isLoading: false, hasDraftForCurrentModel: false),
          );

          // Refresh list of drafts
          add(ListDraftsEvent());
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to discard draft',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support drafts',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error discarding draft: $e',
        ),
      );
    }
  }

  // Version management methods

  void _onListVersions(
    ListVersionsEvent event,
    Emitter<DomainState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final versions = await shellApp.listVersions(
          event.domainCode,
          event.modelCode,
        );

        emit(
          state.copyWith(
            isLoading: false,
            availableVersions: versions,
            currentVersionTimestamp:
                versions.isNotEmpty ? versions.first : null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support versions',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error listing versions: $e',
        ),
      );
    }
  }

  void _onLoadVersion(LoadVersionEvent event, Emitter<DomainState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (app is ShellApp) {
        final shellApp = app as ShellApp;
        final versionYaml = await shellApp.loadVersion(
          event.domainCode,
          event.modelCode,
          event.versionTimestamp,
        );

        if (versionYaml != null) {
          // Parse YAML into domain model
          // This would depend on how your application loads and parses YAML
          // For now, this is a placeholder

          emit(
            state.copyWith(
              isLoading: false,
              currentVersionTimestamp: event.versionTimestamp,
              errorMessage: 'Version loaded (parsing not yet implemented)',
            ),
          );
        } else {
          emit(
            state.copyWith(isLoading: false, errorMessage: 'No version found'),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'App implementation does not support versions',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error loading version: $e',
        ),
      );
    }
  }

  String getDSL() {
    final domain = state.selectedDomain;
    final model = state.selectedModel;

    if (domain != null && model != null && app is ShellApp) {
      return (app as ShellApp).exportDomainModelAsDSL(domain, model);
    } else {
      return 'No domain and model selected.';
    }
  }

  /// Helper method to check if a draft exists for the current model
  void _checkForDraft(String domainCode, String modelCode) async {
    if (app is ShellApp) {
      final shellApp = app as ShellApp;
      final hasDraft = await shellApp.hasDraft(domainCode, modelCode);

      if (hasDraft != state.hasDraftForCurrentModel) {
        emit(state.copyWith(hasDraftForCurrentModel: hasDraft));
      }
    }
  }
}
