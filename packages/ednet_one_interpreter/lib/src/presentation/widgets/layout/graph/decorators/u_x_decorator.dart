import 'dart:ui';

abstract class UXDecorator {
  void apply(Canvas canvas, Offset position, double scale);
}
