import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;

import 'domain_selection_event.dart';
import 'domain_selection_state.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member
/// BLoC for domain selection
///
/// Manages the state of domain selections across the application
class DomainSelectionBloc
    extends Bloc<DomainSelectionEvent, DomainSelectionState> {
  final ednet.IOneApplication app;

  DomainSelectionBloc({required this.app})
    : super(DomainSelectionState.initial()) {
    on<InitializeDomainSelectionEvent>(_onInitialize);
    on<LoadDomainsEvent>(_onLoadDomains);
    on<SelectDomainEvent>(_onSelectDomain);
  }

  /// Handle initialization event
  void _onInitialize(
    InitializeDomainSelectionEvent event,
    Emitter<DomainSelectionState> emit,
  ) {
    ednet.Domain? selectedDomain;

    // Initialize with the first domain if available
    if (app.groupedDomains.isNotEmpty) {
      selectedDomain = app.groupedDomains.first;
    }

    emit(
      DomainSelectionState(
        selectedDomain: selectedDomain,
        availableDomains: app.groupedDomains,
        selectedModels: selectedDomain?.models,
      ),
    );
  }

  /// Handle loading domains from a repository
  void _onLoadDomains(
    LoadDomainsEvent event,
    Emitter<DomainSelectionState> emit,
  ) {
    try {
      // Load domains
      final domains = event.domains;

      // Determine the selected domain
      final selectedDomain =
          event.selectedDomain ?? (domains.isNotEmpty ? domains.first : null);

      // Determine models for the selected domain
      final models = selectedDomain != null ? selectedDomain.models : null;

      // Emit the new state
      emit(
        DomainSelectionState(
          selectedDomain: selectedDomain,
          availableDomains: domains,
          selectedModels: models,
        ),
      );
    } catch (e) {
      // In a real app, handle errors more gracefully
      emit(DomainSelectionState.initial());
    }
  }

  /// Handle domain selection changes
  void _onSelectDomain(
    SelectDomainEvent event,
    Emitter<DomainSelectionState> emit,
  ) {
    try {
      final domain = event.domain;
      final models = domain.models;

      emit(
        DomainSelectionState(
          selectedDomain: domain,
          availableDomains: state.availableDomains,
          selectedModels: models,
        ),
      );
    } catch (e) {
      // In a real app, handle errors more gracefully
      emit(state);
    }
  }

  /// Update domain list when new domains are received
  void updateDomains(ednet.Domains domains) {
    emit(
      DomainSelectionState(
        availableDomains: domains,
        selectedDomain: state.selectedDomain,
        selectedModels: state.selectedModels,
      ),
    );
  }
}
