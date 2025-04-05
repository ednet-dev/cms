import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart';

import 'domain_event.dart';
import 'domain_state.dart';

class DomainBloc extends Bloc<DomainBlocEvent, DomainState> {
  final IOneApplication app;

  DomainBloc({required this.app}) : super(DomainState.initial()) {
    on<InitializeDomainEvent>(_onInitialize);
    on<SelectDomainEvent>(_onSelectDomain);
    on<SelectModelEvent>(_onSelectModel);
    on<SelectConceptEvent>(_onSelectConcept);
    on<ExportDSLEvent>(_onExportDSL);
    on<GenerateCodeEvent>(_onGenerateCode);
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
  }

  void _onExportDSL(ExportDSLEvent event, Emitter<DomainState> emit) {
    // This could be implemented to export the DSL representation of the model
  }

  void _onGenerateCode(
    GenerateCodeEvent event,
    Emitter<DomainState> emit,
  ) async {
    // This could be implemented to trigger code generation
  }

  String getDSL() {
    final domain = state.selectedDomain;
    final model = state.selectedModel;

    if (domain != null && model != null) {
      // Return a basic DSL representation
      return 'domain: ${domain.code}\nmodel: ${model.code}';
    } else {
      return 'No domain and model selected.';
    }
  }
}
