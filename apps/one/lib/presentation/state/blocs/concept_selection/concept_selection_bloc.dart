import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:ednet_one/presentation/widgets/layout/graph/domain/domain_model_graph.dart';
import 'package:flutter/foundation.dart';

import 'concept_selection_event.dart';
import 'concept_selection_state.dart';

/// Bloc for handling concept selection actions and state
class ConceptSelectionBloc
    extends Bloc<ConceptSelectionEvent, ConceptSelectionState> {
  final ednet.IOneApplication app;

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
      debugPrint('🔍 Updating concepts for model: ${event.model.code}');

      // First, clear the current state to prevent type mismatches
      emit(ConceptSelectionState.initial());

      ednet.Model model = event.model;
      ednet.Concepts? entryConcepts;

      // Safely check if concepts exist
      if (model.concepts.isNotEmpty) {
        // First try to get ordered entry concepts
        try {
          var orderedConcepts = model.getOrderedEntryConcepts();
          if (orderedConcepts.isNotEmpty) {
            entryConcepts = ednet.Concepts();
            for (var concept in orderedConcepts) {
              entryConcepts.add(concept);
                        }
          }
        } catch (e) {
          debugPrint('Error getting ordered entry concepts: $e');
          // Fall back to filtering concepts directly
          entryConcepts = ednet.Concepts();
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
        ConceptSelectionState(
          selectedConcept: null, // Don't auto-select concept
          availableConcepts: entryConcepts ?? ednet.Concepts(),
          selectedEntities: null,
          model: model,
          domainModelGraph: domainModelGraph,
        ),
      );
    } catch (e, stack) {
      debugPrint('Error in _onUpdateConceptsForModel: $e');
      debugPrint('Stack trace: $stack');

      // Emit initial state on error
      emit(ConceptSelectionState.initial());
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

      debugPrint(
        '🔍 Selecting concept: ${concept.code} in model: ${model.code}',
      );
      debugPrint('🔍 Domain code: ${model.domain.code}');
      debugPrint('🔍 Model code: ${model.code}');
      debugPrint('🔍 Concept code: ${concept.code}');
      debugPrint('🔍 Is entry concept: ${concept.entry}');

      // First clear the current state to prevent type mismatches
      emit(state.copyWith(selectedConcept: null, selectedEntities: null));

      try {
        debugPrint(
          '🔍 Getting domain model for: ${model.domain.codeFirstLetterLower}_${model.codeFirstLetterLower}',
        );
        var domainModel = app.getDomainModels(
          model.domain.codeFirstLetterLower,
          model.codeFirstLetterLower,
        );

        debugPrint('🔍 Got domain model: ${domainModel != null}');
        debugPrint('🔍 Domain model type: ${domainModel.runtimeType}');

        var modelEntries = domainModel.getModelEntries(concept.model.code);
        debugPrint('🔍 Got model entries: ${modelEntries != null}');
        debugPrint('🔍 Model entries type: ${modelEntries?.runtimeType}');

        ednet.Entities? entities;
        if (modelEntries != null) {
          try {
            debugPrint(
              '🔍 Attempting to get entities for concept: ${concept.code}',
            );
            entities = modelEntries.getEntry(concept.code);
            debugPrint(
              '🔍 Found ${entities.length ?? 0} entities for concept: ${concept.code}',
            );
            debugPrint('🔍 First entity: ${entities.first.oid}');
                    } catch (e) {
            debugPrint(
              '❌ Error getting entities for concept ${concept.code}: $e',
            );
            entities = null;
          }
        }

        emit(
          state.copyWith(selectedConcept: concept, selectedEntities: entities),
        );
      } catch (e, stack) {
        debugPrint('❌ Error fetching entities for concept ${concept.code}: $e');
        debugPrint('❌ Stack trace: $stack');
        emit(state.copyWith(selectedConcept: concept, selectedEntities: null));
      }
    } catch (e, stack) {
      debugPrint('❌ Unexpected error in _onSelectConcept: $e');
      debugPrint('❌ Stack trace: $stack');
      emit(ConceptSelectionState.initial());
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
    try {
      debugPrint('Refreshing entities for concept: ${event.concept.code}');

      // Try to get entities for this entry concept
      if (event.concept.entry) {
        // For entry concepts, we can try to directly access entities
        debugPrint('This is an entry concept - should have entities');

        // If your concept has a related model, you might need to find it
        final model = event.concept.model;
        debugPrint(
          'Found model: ${model.code} for concept: ${event.concept.code}',
        );

        // Simply force a selection of the same concept again
        // This should trigger the normal entity loading process
        _onSelectConcept(SelectConceptEvent(event.concept), emit);
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
  void updateConceptsDirectly(ednet.Concepts concepts) {
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
