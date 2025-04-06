import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/domain/domain_model_graph.dart';
import 'package:flutter/foundation.dart';

import 'concept_selection_event.dart';
import 'concept_selection_state.dart';

/// Bloc for handling concept selection actions and state
class ConceptSelectionBloc
    extends Bloc<ConceptSelectionEvent, ConceptSelectionState> {
  final IOneApplication app;

  ConceptSelectionBloc({required this.app})
    : super(ConceptSelectionState.initial()) {
    on<InitializeConceptSelectionEvent>(_onInitialize);
    on<UpdateConceptsForModelEvent>(_onUpdateConceptsForModel);
    on<SelectConceptEvent>(_onSelectConcept);
    on<ExportDSLEvent>(_onExportDSL);
    on<GenerateCodeEvent>(_onGenerateCode);
    on<RefreshConceptEvent>(_onRefreshConcept);
  }

  /// Handles the initialize event
  void _onInitialize(
    InitializeConceptSelectionEvent event,
    Emitter<ConceptSelectionState> emit,
  ) {
    // The concept list will be populated when a model is selected
    emit(state);
  }

  /// Handles updating the concepts list when a model is selected
  void _onUpdateConceptsForModel(
    UpdateConceptsForModelEvent event,
    Emitter<ConceptSelectionState> emit,
  ) {
    try {
      debugPrint('Updating concepts for model: ${event.model.code}');
      Model model = event.model;
      Concepts? entryConcepts;

      // Safely check if concepts exist
      if (model.concepts.isNotEmpty) {
        // First try to get ordered entry concepts
        try {
          var orderedConcepts = model.getOrderedEntryConcepts();
          if (orderedConcepts != null && orderedConcepts.isNotEmpty) {
            entryConcepts = Concepts();
            for (var concept in orderedConcepts) {
              if (concept is Concept) {
                entryConcepts.add(concept);
              }
            }
          }
        } catch (e) {
          debugPrint('Error getting ordered entry concepts: $e');
          // Fall back to filtering concepts directly
          entryConcepts = Concepts();
          for (var concept in model.concepts) {
            if (concept.entry) {
              entryConcepts.add(concept);
            }
          }
        }

        // If no entry concepts found but the model has concepts, use all concepts
        if ((entryConcepts == null || entryConcepts.isEmpty) &&
            model.concepts.isNotEmpty) {
          debugPrint('No entry concepts found, using all concepts');
          entryConcepts = model.concepts;
        }
      }

      DomainModelGraph? domainModelGraph;
      if (state.model != null) {
        try {
          domainModelGraph =
              event.domainModelGraph ??
              DomainModelGraph(domain: state.model!.domain, model: model);
        } catch (e) {
          debugPrint('Error creating domain model graph: $e');
          // Continue without graph
        }
      }

      // Log the concepts we found
      debugPrint(
        'Found ${entryConcepts?.length ?? 0} concepts for model ${model.code}',
      );

      emit(
        state.copyWith(
          selectedConcept:
              entryConcepts?.isNotEmpty == true ? entryConcepts!.first : null,
          availableConcepts: entryConcepts ?? Concepts(),
          selectedEntities: null,
          model: model,
          domainModelGraph: domainModelGraph,
        ),
      );
    } catch (e, stack) {
      debugPrint('Error in _onUpdateConceptsForModel: $e');
      debugPrint('Stack trace: $stack');

      // Emit state with empty concepts but preserve the model to avoid UI breakage
      emit(
        state.copyWith(
          selectedConcept: null,
          availableConcepts: Concepts(),
          selectedEntities: null,
          model: event.model,
          domainModelGraph: null,
        ),
      );
    }
  }

  /// Handles the select concept event
  void _onSelectConcept(
    SelectConceptEvent event,
    Emitter<ConceptSelectionState> emit,
  ) {
    try {
      final concept = event.concept;
      final model = state.model;

      if (model == null) {
        debugPrint('Warning: Cannot select concept - model is null');
        return;
      }

      debugPrint('Selecting concept: ${concept.code} in model: ${model.code}');

      // First, update the state with the selected concept but no entities yet
      // This allows the UI to show the selection immediately while entities load
      emit(
        state.copyWith(
          selectedConcept: concept,
          selectedEntities: null, // Clear entities first
        ),
      );

      try {
        var domainModel = app.getDomainModels(
          model.domain.codeFirstLetterLower,
          model.codeFirstLetterLower,
        );

        debugPrint('Got domain model for: ${model.domain.code}_${model.code}');

        var modelEntries = domainModel.getModelEntries(concept.model.code);
        debugPrint('Got model entries for: ${concept.model.code}');

        Entities? entities;
        if (modelEntries != null) {
          try {
            // Wrap this in try-catch as getEntry might throw "No element" error
            entities = modelEntries.getEntry(concept.code);
            debugPrint(
              'Found ${entities?.length ?? 0} entities for concept: ${concept.code}',
            );
          } catch (e) {
            debugPrint(
              'Error getting entities for concept ${concept.code}: $e',
            );
            // Continue with null entities rather than failing
            entities = null;
          }
        } else {
          debugPrint('No model entries found for: ${concept.model.code}');
        }

        // Update state with entities (which might be null if not found)
        emit(
          state.copyWith(selectedConcept: concept, selectedEntities: entities),
        );
      } catch (e, stack) {
        debugPrint('Error fetching entities for concept ${concept.code}: $e');
        debugPrint('Stack trace: $stack');

        // Keep the concept selected but with null entities
        emit(state.copyWith(selectedConcept: concept, selectedEntities: null));
      }
    } catch (e, stack) {
      debugPrint('Unexpected error in _onSelectConcept: $e');
      debugPrint('Stack trace: $stack');
      // Don't update state if we completely failed
    }
  }

  /// Handles exporting DSL
  void _onExportDSL(ExportDSLEvent event, Emitter<ConceptSelectionState> emit) {
    // No state change needed, DSL retrieval done externally
  }

  /// Handles code generation
  void _onGenerateCode(
    GenerateCodeEvent event,
    Emitter<ConceptSelectionState> emit,
  ) async {
    // Implement code generation logic if needed
  }

  void _onRefreshConcept(
    RefreshConceptEvent event,
    Emitter<ConceptSelectionState> emit,
  ) {
    if (event.concept == null) return;

    // This is a refresh event for an already selected concept
    // We need to fetch its entities again
    try {
      debugPrint('Refreshing entities for concept: ${event.concept.code}');

      // Try to get entities for this entry concept
      if (event.concept.entry) {
        // For entry concepts, we can try to directly access entities
        debugPrint('This is an entry concept - should have entities');

        // If your concept has a related model, you might need to find it
        final model = event.concept.model;
        if (model != null) {
          debugPrint(
            'Found model: ${model.code} for concept: ${event.concept.code}',
          );

          // Simply force a selection of the same concept again
          // This should trigger the normal entity loading process
          _onSelectConcept(SelectConceptEvent(event.concept), emit);
        }
      }
    } catch (e, stack) {
      debugPrint('Error refreshing entities: $e');
      debugPrint('Stack trace: $stack');
    }
  }

  /// Returns the DSL for the current domain model graph
  String getDSL() {
    if (state.domainModelGraph != null) {
      return (state.domainModelGraph as DomainModelGraph).toYamlDSL();
    } else {
      return 'No graph available. Select a domain and model first.';
    }
  }

  /// A method to directly update concepts in the state
  /// This is a workaround for initialization issues
  void updateConceptsDirectly(Concepts concepts) {
    if (concepts.isEmpty) return;

    emit(
      ConceptSelectionState(
        availableConcepts: concepts,
        selectedConcept: state.selectedConcept,
        selectedEntities: state.selectedEntities,
      ),
    );
  }
}
