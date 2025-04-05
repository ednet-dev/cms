import 'layout_state.dart';

/// Initial layout state with default values.
class LayoutInitial extends LayoutState {
  /// Creates the initial layout state.
  LayoutInitial()
    : super(
        layoutType: LayoutType.standardLayout,
        horizontalShift: 0,
        verticalShift: 0,
        shiftHistory: const [],
      );
}
