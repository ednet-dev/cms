// layout_bloc.dart
import 'package:bloc/bloc.dart';

import 'layout_event.dart';
import 'layout_state.dart';

/// Manages the layout state for the application.
///
/// This bloc handles changes in the visualization layout type and
/// shifting focus between different parts of the domain model.
class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  /// Creates a new layout bloc.
  LayoutBloc() : super(LayoutState.initial()) {
    on<ToggleLayoutEvent>(_onToggleLayout);
    on<ShiftLeftEvent>(_onShiftLeft);
    on<ShiftRightEvent>(_onShiftRight);
    on<ShiftUpEvent>(_onShiftUp);
    on<ShiftDownEvent>(_onShiftDown);
    on<ResetLayoutEvent>(_onResetLayout);
  }

  /// Toggles between standard and alternative layout.
  void _onToggleLayout(ToggleLayoutEvent event, Emitter<LayoutState> emit) {
    final newLayoutType =
        state.layoutType == LayoutType.standardLayout
            ? LayoutType.alternativeLayout
            : LayoutType.standardLayout;
    emit(state.copyWith(layoutType: newLayoutType));
  }

  /// Shifts the focus left in the domain model navigation.
  void _onShiftLeft(ShiftLeftEvent event, Emitter<LayoutState> emit) {
    emit(
      state.copyWith(
        horizontalShift: state.horizontalShift - 1,
        shiftHistory: [...state.shiftHistory, 'left'],
      ),
    );
  }

  /// Shifts the focus right in the domain model navigation.
  void _onShiftRight(ShiftRightEvent event, Emitter<LayoutState> emit) {
    emit(
      state.copyWith(
        horizontalShift: state.horizontalShift + 1,
        shiftHistory: [...state.shiftHistory, 'right'],
      ),
    );
  }

  /// Shifts the focus up in the domain model navigation.
  void _onShiftUp(ShiftUpEvent event, Emitter<LayoutState> emit) {
    emit(
      state.copyWith(
        verticalShift: state.verticalShift - 1,
        shiftHistory: [...state.shiftHistory, 'up'],
      ),
    );
  }

  /// Shifts the focus down in the domain model navigation.
  void _onShiftDown(ShiftDownEvent event, Emitter<LayoutState> emit) {
    emit(
      state.copyWith(
        verticalShift: state.verticalShift + 1,
        shiftHistory: [...state.shiftHistory, 'down'],
      ),
    );
  }

  /// Resets the layout to its initial state.
  void _onResetLayout(ResetLayoutEvent event, Emitter<LayoutState> emit) {
    emit(LayoutState.initial());
  }
}
