import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/domain/domain_model_graph.dart';

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
    Model model = event.model;
    Concepts? entryConcepts;

    if (model.concepts.isNotEmpty) {
      var orderedConcepts = model.getOrderedEntryConcepts();
      if (orderedConcepts != null && orderedConcepts.isNotEmpty) {
        entryConcepts = Concepts();
        for (var concept in orderedConcepts) {
          if (concept is Concept) {
            entryConcepts.add(concept);
          }
        }
      }
    }

    DomainModelGraph? domainModelGraph;
    if (state.model != null) {
      domainModelGraph =
          event.domainModelGraph ??
          DomainModelGraph(domain: state.model!.domain, model: model);
    }

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
  }

  /// Handles the select concept event
  void _onSelectConcept(
    SelectConceptEvent event,
    Emitter<ConceptSelectionState> emit,
  ) {
    final concept = event.concept;
    final model = state.model;

    if (model == null) return;

    var domainModel = app.getDomainModels(
      model.domain.codeFirstLetterLower,
      model.codeFirstLetterLower,
    );

    var modelEntries = domainModel.getModelEntries(concept.model.code);
    var entry = modelEntries?.getEntry(concept.code);

    emit(state.copyWith(selectedConcept: concept, selectedEntities: entry));
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

  /// Returns the DSL for the current domain model graph
  String getDSL() {
    if (state.domainModelGraph != null) {
      return (state.domainModelGraph as DomainModelGraph).toYamlDSL();
    } else {
      return 'No graph available. Select a domain and model first.';
    }
  }
}
