import 'package:bloc/bloc.dart';
import 'package:ednet_core/ednet_core.dart';

import 'domain_selection_event.dart';
import 'domain_selection_state.dart';

/// Bloc for handling domain selection actions and state
class DomainSelectionBloc
    extends Bloc<DomainSelectionEvent, DomainSelectionState> {
  final IOneApplication app;

  DomainSelectionBloc({required this.app})
    : super(DomainSelectionState.initial()) {
    on<InitializeDomainSelectionEvent>(_onInitialize);
    on<SelectDomainEvent>(_onSelectDomain);
  }

  /// Handles the initialize event
  void _onInitialize(
    InitializeDomainSelectionEvent event,
    Emitter<DomainSelectionState> emit,
  ) {
    Domain? selectedDomain;

    // Initialize with the first domain if available
    if (app.groupedDomains.isNotEmpty) {
      selectedDomain = app.groupedDomains.first;
    }

    emit(
      state.copyWith(
        selectedDomain: selectedDomain,
        allDomains: app.groupedDomains,
      ),
    );
  }

  /// Handles the select domain event
  void _onSelectDomain(
    SelectDomainEvent event,
    Emitter<DomainSelectionState> emit,
  ) {
    emit(state.copyWith(selectedDomain: event.domain));
  }

  /// A method to directly update domains in the state
  /// This is a workaround for initialization issues
  void updateDomainsDirectly(Domains domains) {
    if (domains.isEmpty) return;

    emit(
      DomainSelectionState(
        allDomains: domains,
        selectedDomain: state.selectedDomain,
      ),
    );
  }
}
