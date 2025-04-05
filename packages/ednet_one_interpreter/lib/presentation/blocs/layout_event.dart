// layout_event.dart

/// Base class for all layout events.
abstract class LayoutEvent {}

/// Event to toggle between layout types.
class ToggleLayoutEvent extends LayoutEvent {}

/// Event to shift focus left in the layout.
class ShiftLeftEvent extends LayoutEvent {}

/// Event to shift focus right in the layout.
class ShiftRightEvent extends LayoutEvent {}

/// Event to shift focus up in the layout.
class ShiftUpEvent extends LayoutEvent {}

/// Event to shift focus down in the layout.
class ShiftDownEvent extends LayoutEvent {}

/// Event to reset the layout to its initial state.
class ResetLayoutEvent extends LayoutEvent {}
