// layout_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_event.dart';
import 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(LayoutState()) {
    on<SelectEntityEvent>(_onSelectEntity);
    on<ToggleLayoutEvent>(_onToggleLayout);
  }

  void _onSelectEntity(SelectEntityEvent event, Emitter<LayoutState> emit) {
    emit(state.copyWith(selectedEntity: event.entity));
  }

  void _onToggleLayout(ToggleLayoutEvent event, Emitter<LayoutState> emit) {
    final newLayoutType = state.layoutType == LayoutType.defaultLayout
        ? LayoutType.alternativeLayout
        : LayoutType.defaultLayout;
    emit(state.copyWith(layoutType: newLayoutType));
  }
}
