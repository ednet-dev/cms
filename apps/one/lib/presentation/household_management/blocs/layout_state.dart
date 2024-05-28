// layout_state.dart
import 'package:ednet_core/ednet_core.dart';

enum LayoutType { defaultLayout, alternativeLayout }

class LayoutState {
  final Entity? selectedEntity;
  final LayoutType layoutType;

  LayoutState(
      {this.selectedEntity, this.layoutType = LayoutType.defaultLayout});

  LayoutState copyWith({Entity? selectedEntity, LayoutType? layoutType}) {
    return LayoutState(
      selectedEntity: selectedEntity ?? this.selectedEntity,
      layoutType: layoutType ?? this.layoutType,
    );
  }
}
