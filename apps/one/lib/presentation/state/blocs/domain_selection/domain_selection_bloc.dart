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
    on<RefreshDomainsEvent>(_onRefreshDomains);
    on<ClearDomainSelectionEvent>(_onClearDomainSelection);
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

  /// Handle domain refresh event
  void _onRefreshDomains(
    RefreshDomainsEvent event,
    Emitter<DomainSelectionState> emit,
  ) {
    try {
      // Re-fetch grouped domains from the application
      final domains = app.groupedDomains;

      // Keep the current selection if it still exists in the refreshed domains
      final selectedDomain = state.selectedDomain;
      final domainStillExists =
          selectedDomain != null &&
          domains.any((domain) => domain.code == selectedDomain.code);

      emit(
        DomainSelectionState(
          selectedDomain: domainStillExists ? selectedDomain : null,
          availableDomains: domains,
          selectedModels: domainStillExists ? state.selectedModels : null,
        ),
      );
    } catch (e) {
      // Log the error in a production app
      emit(state);
    }
  }

  /// Handle clearing the domain selection
  void _onClearDomainSelection(
    ClearDomainSelectionEvent event,
    Emitter<DomainSelectionState> emit,
  ) {
    emit(
      DomainSelectionState(
        selectedDomain: null,
        availableDomains: state.availableDomains,
        selectedModels: null,
      ),
    );
  }
}
