// layout_state.dart

/// Enum defining available layout types.
enum LayoutType {
  /// Standard three-panel layout.
  standardLayout,

  /// Alternative visualization layout.
  alternativeLayout,
}

/// State for managing layout configuration in the application.
class LayoutState {
  /// The current layout type.
  final LayoutType layoutType;

  /// Horizontal shift value for focusing on specific parts of the domain model.
  final int horizontalShift;

  /// Vertical shift value for focusing on specific parts of the domain model.
  final int verticalShift;

  /// History of shift operations to enable undo/redo.
  final List<String> shiftHistory;

  /// Creates a new layout state.
  LayoutState({
    required this.layoutType,
    required this.horizontalShift,
    required this.verticalShift,
    required this.shiftHistory,
  });

  /// Creates the initial layout state.
  factory LayoutState.initial() => LayoutState(
    layoutType: LayoutType.standardLayout,
    horizontalShift: 0,
    verticalShift: 0,
    shiftHistory: const [],
  );

  /// Creates a copy with the given values replaced.
  LayoutState copyWith({
    LayoutType? layoutType,
    int? horizontalShift,
    int? verticalShift,
    List<String>? shiftHistory,
  }) {
    return LayoutState(
      layoutType: layoutType ?? this.layoutType,
      horizontalShift: horizontalShift ?? this.horizontalShift,
      verticalShift: verticalShift ?? this.verticalShift,
      shiftHistory: shiftHistory ?? this.shiftHistory,
    );
  }
}
