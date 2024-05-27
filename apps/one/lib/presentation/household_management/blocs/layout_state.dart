// layout_event.dart
import 'package:ednet_core/ednet_core.dart';

class LayoutState {
  final Entity? selectedEntity;

  LayoutState({this.selectedEntity});

  LayoutState copyWith({Entity? selectedEntity}) {
    return LayoutState(selectedEntity: selectedEntity ?? this.selectedEntity);
  }
}
