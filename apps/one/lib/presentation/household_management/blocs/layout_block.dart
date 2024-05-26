// layout_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_event.dart';
import 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(LayoutState()) {
    on<SelectEntityEvent>(_onSelectEntity);
  }

  void _onSelectEntity(SelectEntityEvent event, Emitter<LayoutState> emit) {
    emit(state.copyWith(selectedEntity: event.entity));
  }
}
