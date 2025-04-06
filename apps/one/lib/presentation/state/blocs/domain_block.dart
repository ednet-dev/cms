import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:bloc/bloc.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/domain/domain_model_graph.dart';

import 'domain_event.dart' as local;
import 'domain_state.dart';

class DomainBloc extends Bloc<local.DomainEvent, DomainState> {
  final ednet.IOneApplication app;

  DomainBloc({required this.app}) : super(DomainState.initial()) {
    on<local.InitializeDomainEvent>(_onInitialize);
    on<local.SelectDomainEvent>(_onSelectDomain);
    on<local.SelectModelEvent>(_onSelectModel);
    on<local.SelectConceptEvent>(_onSelectConcept);
    on<local.ExportDSLEvent>(_onExportDSL);
    on<local.GenerateCodeEvent>(_onGenerateCode);
  }

  void _onInitialize(
    local.InitializeDomainEvent event,
    Emitter<DomainState> emit,
  ) {
    // Initialize with first domain and model if available
    ednet.Domain? selectedDomain;
    ednet.Model? selectedModel;
    ednet.Entities? selectedEntries;
    DomainModelGraph? domainModelGraph;
    ednet.Entities? selectedEntities;
    ednet.Concept? selectedConcept;

    if (app.groupedDomains.isNotEmpty) {
      selectedDomain = app.groupedDomains.first;
      if (selectedDomain.models.isNotEmpty) {
        selectedModel = selectedDomain.models.first;
        selectedEntries = selectedModel.concepts;
        domainModelGraph = DomainModelGraph(
          domain: selectedDomain,
          model: selectedModel,
        );
      }
    }

    emit(
      state.copyWith(
        selectedDomain: selectedDomain,
        selectedModel: selectedModel,
        selectedEntries: selectedEntries,
        selectedEntities: selectedEntities,
        selectedConcept: selectedConcept,
        domainModelGraph: domainModelGraph,
      ),
    );
  }

  void _onSelectDomain(
    local.SelectDomainEvent event,
    Emitter<DomainState> emit,
  ) {
    ednet.Domain domain = event.domain;
    ednet.Model? selectedModel;
    ednet.Entities? selectedEntries;
    DomainModelGraph? domainModelGraph;
    ednet.Entities? selectedEntities;
    ednet.Concept? selectedConcept;

    if (domain.models.isNotEmpty) {
      selectedModel = domain.models.first;
      selectedEntries =
          selectedModel.concepts.isNotEmpty ? selectedModel.concepts : null;
      if (selectedModel != null) {
        domainModelGraph = DomainModelGraph(
          domain: domain,
          model: selectedModel,
        );
      }
    }

    emit(
      state.copyWith(
        selectedDomain: domain,
        selectedModel: selectedModel,
        selectedEntries: selectedEntries,
        selectedEntities: selectedEntities,
        selectedConcept: selectedConcept,
        domainModelGraph: domainModelGraph,
      ),
    );
  }

  void _onSelectModel(local.SelectModelEvent event, Emitter<DomainState> emit) {
    final domain = state.selectedDomain;
    if (domain == null) return; // No domain selected

    ednet.Model model = event.model;
    ednet.Entities? selectedEntries =
        model.concepts.isNotEmpty ? model.getOrderedEntryConcepts() : null;
    DomainModelGraph? domainModelGraph = DomainModelGraph(
      domain: domain,
      model: model,
    );

    emit(
      state.copyWith(
        selectedModel: model,
        selectedEntries: selectedEntries,
        selectedEntities: null,
        selectedConcept: null,
        domainModelGraph: domainModelGraph,
      ),
    );
  }

  void _onSelectConcept(
    local.SelectConceptEvent event,
    Emitter<DomainState> emit,
  ) {
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
  }

  void _onExportDSL(local.ExportDSLEvent event, Emitter<DomainState> emit) {
    // Just triggers DSL export via method call, no state change needed.
    // Could store DSL in state if desired. For now, DSL retrieval done externally.
  }

  void _onGenerateCode(
    local.GenerateCodeEvent event,
    Emitter<DomainState> emit,
  ) async {
    // Implement code generation and update state if needed
    // This might call external code generation logic and upon completion may show a message
  }

  String getDSL() {
    if (state.domainModelGraph != null) {
      return state.domainModelGraph!.toYamlDSL();
    } else {
      return 'No graph available. Select a domain and model first.';
    }
  }
}
