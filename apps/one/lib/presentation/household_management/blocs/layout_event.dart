// layout_state.dart
import 'package:ednet_core/ednet_core.dart';

abstract class LayoutEvent {}

class SelectEntityEvent extends LayoutEvent {
  final Entity entity;

  SelectEntityEvent({required this.entity});
}
